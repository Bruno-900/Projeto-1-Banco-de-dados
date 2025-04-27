-- Criação do banco de dados e seleção do mesmo
CREATE DATABASE Zoologico;
USE Zoologico;

-- Tabela Visitante
CREATE TABLE Visitante (
    ID_Visitante INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(200) NOT NULL,
    Idade INT NOT NULL,
    CPF VARCHAR(11) UNIQUE NOT NULL,
    Email VARCHAR(200),
    Endereco VARCHAR(200)
);

-- Tabela Promocao
CREATE TABLE Promocao (
    ID_Promocao INT PRIMARY KEY AUTO_INCREMENT,
    Codigo_Promocional VARCHAR(10) UNIQUE,
    Tipo_Desconto ENUM('Percentual', 'Valor Fixo'),
    Data_Inicio DATE NOT NULL,
	Data_Fim DATE NOT NULL,
    Desconto_Valor DECIMAL(6,2) CHECK (
        (Tipo_Desconto = 'Percentual' AND Desconto_Valor BETWEEN 0 AND 100) OR
        (Tipo_Desconto = 'Valor Fixo' AND Desconto_Valor > 0)
    ),
    CONSTRAINT CHK_Datas CHECK (Data_Fim >= Data_inicio)
);

-- Tabela Compra
CREATE TABLE Compra (
    ID_Compra INT PRIMARY KEY AUTO_INCREMENT,
    Valor_Total DECIMAL(10, 2),
    Data_Compra DATE,
    ID_Visitante INT,
    ID_Promocao INT,
    CONSTRAINT FK_Visitante_Compra FOREIGN KEY (ID_Visitante) REFERENCES Visitante(ID_Visitante),
    CONSTRAINT FK_Promocao_Compra FOREIGN KEY (ID_Promocao) REFERENCES Promocao(ID_Promocao)
);

-- Tabela Pagamento 
CREATE TABLE Pagamento (
    ID_Pagamento INT PRIMARY KEY AUTO_INCREMENT,
    Status_Compra ENUM('Aprovado', 'Pendente', 'Recusado') DEFAULT 'Pendente',
    Data_Processamento DATETIME,
    ID_Compra INT NOT NULL,
    CONSTRAINT FK_Compra_Pagamento FOREIGN KEY (ID_Compra) REFERENCES Compra(ID_Compra)
);

CREATE TABLE Detalhes_Pagamento (
	ID_Pagamento INT PRIMARY KEY,
    metodo ENUM('credito', 'debito', 'Boleto', 'pix') NOT NULL,
    Cartao_NomeTitular VARCHAR(200),
    Cartao_Validade VARCHAR(5),
    Cartao_UltimosDigitos VARCHAR(4),
    Chave_PIX VARCHAR(200),
    Codigo_Boleto VARCHAR(44),
    CONSTRAINT CHK_Metodo_Pagamento CHECK (
        (Cartao_UltimosDigitos IS NOT NULL AND Chave_PIX IS NULL AND Codigo_Boleto IS NULL) OR
        (Chave_PIX IS NOT NULL AND Cartao_UltimosDigitos IS NULL AND Codigo_Boleto IS NULL) OR
        (Codigo_Boleto IS NOT NULL AND Cartao_UltimosDigitos IS NULL AND Chave_PIX IS NULL)
    )
);

-- Tabela Tipo
CREATE TABLE Tipo (
    ID_Tipo INT PRIMARY KEY AUTO_INCREMENT,
    Tipo_Ingresso VARCHAR(200) NOT NULL,
    Quantidade_Disponivel INT NOT NULL CHECK (Quantidade_Disponivel >= 0),
    Preco DECIMAL(6,2) NOT NULL CHECK (Preco > 0),
    Descricao VARCHAR(200) NOT NULL
);

-- Tabela Tutor
CREATE TABLE Tutor (
    ID_Tutor INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(200) NOT NULL
);

-- Tabela Ingresso
CREATE TABLE Ingresso (
    ID_Ingresso INT PRIMARY KEY AUTO_INCREMENT,
    Data_Visita DATE NOT NULL,
    Data_Hora_Checkin DATETIME,
    Status_Ingresso ENUM('Pendente', 'Utilizado', 'Cancelado') DEFAULT 'Pendente',
    tutor BOOLEAN NOT NULL DEFAULT FALSE,
    ID_Compra INT NOT NULL,
    ID_Tipo INT NOT NULL,
    ID_Tutor INT,
    CONSTRAINT FK_Compra_Ingresso FOREIGN KEY (ID_Compra) REFERENCES Compra(ID_Compra),
    CONSTRAINT FK_Tipo_Ingresso FOREIGN KEY (ID_Tipo) REFERENCES Tipo(ID_Tipo),
    CONSTRAINT FK_Tutor_Ingresso FOREIGN KEY (ID_Tutor) REFERENCES Tutor(ID_Tutor)
);

-- Tabela Avaliacao
CREATE TABLE Avaliacao (
    ID_Avaliacao INT PRIMARY KEY AUTO_INCREMENT,
    Nota INT CHECK (Nota BETWEEN 1 AND 10),
    Comentario TEXT,
    Data_Avaliacao DATE,
    ID_Visitante INT,
    CONSTRAINT FK_Visitante_Avaliacao FOREIGN KEY (ID_Visitante) REFERENCES Visitante(ID_Visitante)
);

-- Tabela Capacidade_Maxima
CREATE TABLE Capacidade_Maxima (
    ID_Capacidade INT PRIMARY KEY AUTO_INCREMENT,
    Capacidade_Publico INT NOT NULL,
    Vigencia DATE NOT NULL,
    Data_Inicio DATE NOT NULL,
    Data_Fim DATE NOT NULL,
    
    CONSTRAINT CHK_Data_Capacidade CHECK (Data_Fim >= Data_Inicio)
    
);

-- Inserindo dados na tabela Visitante
INSERT INTO Visitante (Nome, Idade, CPF, Email, Endereco) VALUES
('Ana Silva', 28, '12345678901', 'ana.silva@email.com', 'Rua das Flores, 123'),
('Pedro Oliveira', 15, '98765432109', 'pedro.oliveira@email.com', 'Avenida Principal, 456'),
('Carla Souza', 35, '11223344556', 'carla.souza@email.com', 'Travessa da Mata, 789'),
('Lucas Pereira', 22, '66778899001', 'lucas.pereira@email.com', 'Alameda dos Rios, 1011'),
('Mariana Santos', 41, '00998877665', 'mariana.santos@email.com', 'Praça Central, 1213');

-- Inserindo dados na tabela Promocao
INSERT INTO Promocao (Codigo_Promocional, Tipo_Desconto, Data_Inicio, Data_Fim, Desconto_Valor) VALUES
('PROMO10', 'Percentual', '2025-05-01', '2025-05-31', 10.00),
('FIXO5', 'Valor Fixo', '2025-06-15', '2025-07-15', 5.00),
('ESTUDANTE20', 'Percentual', '2025-04-20', '2025-05-10', 20.00),
('FAMILIA15', 'Percentual', '2025-07-01', '2025-07-31', 15.00),
('MADRUGA8', 'Valor Fixo', '2025-05-05', '2025-05-15', 8.00);

-- Inserindo dados na tabela Compra
INSERT INTO Compra (Valor_Total, Data_Compra, ID_Visitante, ID_Promocao) VALUES
(55.00, '2025-05-02', (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Ana Silva'), (SELECT ID_Promocao FROM Promocao WHERE Codigo_Promocional = 'PROMO10')),
(20.00, '2025-05-03', (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Pedro Oliveira'), NULL),
(70.00, '2025-05-05', (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Carla Souza'), (SELECT ID_Promocao FROM Promocao WHERE Codigo_Promocional = 'ESTUDANTE20')),
(100.00, '2025-05-10', (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Lucas Pereira'), (SELECT ID_Promocao FROM Promocao WHERE Codigo_Promocional = 'FAMILIA15')),
(30.00, '2025-05-12', (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Mariana Santos'), NULL);

-- Inserindo dados na tabela Pagamento
INSERT INTO Pagamento (Status_Compra, Data_Processamento, ID_Compra) VALUES
('Aprovado', '2025-05-02 10:00:00', (SELECT ID_Compra FROM Compra WHERE Valor_Total = 55.00)),
('Pendente', '2025-05-03 11:30:00', (SELECT ID_Compra FROM Compra WHERE Valor_Total = 20.00)),
('Aprovado', '2025-05-05 14:45:00', (SELECT ID_Compra FROM Compra WHERE Valor_Total = 70.00)),
('Recusado', '2025-05-10 16:00:00', (SELECT ID_Compra FROM Compra WHERE Valor_Total = 100.00)),
('Aprovado', '2025-05-12 09:15:00', (SELECT ID_Compra FROM Compra WHERE Valor_Total = 30.00));

-- Inserindo dados na tabela Detalhes_Pagamento
INSERT INTO Detalhes_Pagamento (ID_Pagamento, metodo, Cartao_NomeTitular, Cartao_Validade, Cartao_UltimosDigitos, Chave_PIX, Codigo_Boleto) VALUES
((SELECT ID_Pagamento FROM Pagamento WHERE ID_Compra = (SELECT ID_Compra FROM Compra WHERE Valor_Total = 55.00)), 'credito', 'Ana Silva', '12/27', '4567', NULL, NULL),
((SELECT ID_Pagamento FROM Pagamento WHERE ID_Compra = (SELECT ID_Compra FROM Compra WHERE Valor_Total = 20.00)), 'pix', NULL, NULL, NULL, 'chave.aleatoria@email.com', NULL),
((SELECT ID_Pagamento FROM Pagamento WHERE ID_Compra = (SELECT ID_Compra FROM Compra WHERE Valor_Total = 70.00)), 'debito', 'Carla Souza', '08/26', '9012', NULL, NULL),
((SELECT ID_Pagamento FROM Pagamento WHERE ID_Compra = (SELECT ID_Compra FROM Compra WHERE Valor_Total = 100.00)), 'boleto', NULL, NULL, NULL, NULL, '12345678901234567890123456789012345678901234'),
((SELECT ID_Pagamento FROM Pagamento WHERE ID_Compra = (SELECT ID_Compra FROM Compra WHERE Valor_Total = 30.00)), 'credito', 'Mariana Santos', '05/28', '7890', NULL, NULL);

-- Inserindo dados na tabela Tipo
INSERT INTO Tipo (Tipo_Ingresso, Quantidade_Disponivel, Preco, Descricao) VALUES
('Adulto', 100, 40.00, 'Ingresso para visitantes com idade entre 13 e 59 anos'),
('Infantil', 50, 25.00, 'Ingresso para visitantes com idade entre 3 e 12 anos'),
('Estudante', 30, 30.00, 'Ingresso com desconto para estudantes com carteirinha'),
('Sênior', 40, 35.00, 'Ingresso com desconto para visitantes com 60 anos ou mais'),
('Grupo', 20, 120.00, 'Pacote para grupos de até 4 pessoas');

-- Inserindo dados na tabela Tutor
INSERT INTO Tutor (Nome) VALUES
('João Oliveira'),
('Maria Souza'),
('Carlos Pereira'),
('Fernanda Santos'),
('Ricardo Alves');

-- Inserindo dados na tabela Ingresso
INSERT INTO Ingresso (Data_Visita, Data_Hora_Checkin, Status_Ingresso, tutor, ID_Compra, ID_Tipo, ID_Tutor) VALUES
('2025-05-15', '2025-05-15 09:30:00', 'Utilizado', FALSE, (SELECT ID_Compra FROM Compra WHERE Valor_Total = 55.00), (SELECT ID_Tipo FROM Tipo WHERE Tipo_Ingresso = 'Adulto'), NULL),
('2025-05-16', NULL, 'Pendente', TRUE, (SELECT ID_Compra FROM Compra WHERE Valor_Total = 20.00), (SELECT ID_Tipo FROM Tipo WHERE Tipo_Ingresso = 'Infantil'), (SELECT ID_Tutor FROM Tutor WHERE Nome = 'João Oliveira')),
('2025-05-17', '2025-05-17 11:00:00', 'Utilizado', FALSE, (SELECT ID_Compra FROM Compra WHERE Valor_Total = 70.00), (SELECT ID_Tipo FROM Tipo WHERE Tipo_Ingresso = 'Estudante'), NULL),
('2025-05-18', NULL, 'Pendente', FALSE, (SELECT ID_Compra FROM Compra WHERE Valor_Total = 100.00), (SELECT ID_Tipo FROM Tipo WHERE Tipo_Ingresso = 'Grupo'), NULL),
('2025-05-19', '2025-05-19 14:00:00', 'Utilizado', FALSE, (SELECT ID_Compra FROM Compra WHERE Valor_Total = 30.00), (SELECT ID_Tipo FROM Tipo WHERE Tipo_Ingresso = 'Sênior'), NULL);

-- Inserindo dados na tabela Avaliacao
INSERT INTO Avaliacao (Nota, Comentario, Data_Avaliacao, ID_Visitante) VALUES
(9, 'Ótima experiência! Os animais pareciam bem cuidados.', '2025-05-02', (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Ana Silva')),
(7, 'O zoológico é legal, mas achei a praça de alimentação um pouco cara.', '2025-05-05', (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Carla Souza')),
(10, 'Adorei a variedade de espécies e a interação com os cuidadores.', '2025-05-10', (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Lucas Pereira')),
(8, 'Um bom passeio para a família.', '2025-05-12', (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Mariana Santos')),
(6, 'Alguns recintos pareciam um pouco pequenos.', '2025-05-15', (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Pedro Oliveira'));

-- Inserindo dados na tabela Capacidade_Maxima
INSERT INTO Capacidade_Maxima (Capacidade_Publico, Vigencia, Data_Inicio, Data_Fim) VALUES
(500, 'Verão 2025', '2025-06-21', '2025-09-22'),
(400, 'Outono 2025', '2025-03-20', '2025-06-20'),
(450, 'Primavera 2025', '2025-09-23', '2025-12-21'),
(350, 'Inverno 2025', '2025-12-22', '2026-03-19'),
(600, 'Feriados 2025', '2025-11-15', '2025-11-17');