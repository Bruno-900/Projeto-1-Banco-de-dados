-- Criação do banco de dados e seleção do mesmo
CREATE DATABASE Zoologico_Projeto;
USE Zoologico_Projeto;

CREATE TABLE Visitante (
    ID_Visitante INT PRIMARY KEY,
    Nome VARCHAR(100),
    CPF VARCHAR(14),
    Telefone VARCHAR(20),
    Email VARCHAR(100),
    Endereco VARCHAR(255),
    Idade INT
);

CREATE TABLE Promocao (
    ID_Promocao INT PRIMARY KEY,
    Codigo_Promocional VARCHAR(50),
    Tipo_Desconto VARCHAR(50),
    Data_Inicio DATE,
    Desconto_Valor DECIMAL(10,2),
    Data_Fim DATE
);

CREATE TABLE Detalhes_Pagamento (
    ID_Pagamento INT PRIMARY KEY,
    Nome_Titular_Cartao VARCHAR(100),
    Numero_Cartao VARCHAR(20),
    Cartao_Validade VARCHAR(7),
    Codigo_Boleto VARCHAR(50),
    Metodo VARCHAR(50)
);

CREATE TABLE Pagamento (
    ID_Pagamento INT PRIMARY KEY,
    Metodo VARCHAR(50),
    Status_Compra VARCHAR(50),
    Data_Processamento DATETIME,
    fk_Detalhes_Pagamento_ID INT,
    CONSTRAINT fk_Pagamento_Detalhes FOREIGN KEY (fk_Detalhes_Pagamento_ID) REFERENCES Detalhes_Pagamento(ID_Pagamento)
);

CREATE TABLE Compra (
    ID_Compra INT PRIMARY KEY,
    Data_Compra DATETIME,
    Valor_Total DECIMAL(10,2),
    fk_Visitante_ID_Visitante INT,
    fk_Promocao_ID_Promocao INT,
    fk_Pagamento_ID_Pagamento INT,
    CONSTRAINT fk_Compra_Visitante FOREIGN KEY (fk_Visitante_ID_Visitante) REFERENCES Visitante(ID_Visitante),
    CONSTRAINT fk_Compra_Promocao FOREIGN KEY (fk_Promocao_ID_Promocao) REFERENCES Promocao(ID_Promocao),
    CONSTRAINT fk_Compra_Pagamento FOREIGN KEY (fk_Pagamento_ID_Pagamento) REFERENCES Pagamento(ID_Pagamento)
);

CREATE TABLE Tipo (
    ID_Tipo INT PRIMARY KEY,
    Tipo_Ingresso VARCHAR(100),
    Descricao TEXT,
    Quantidade_Disponivel INT,
    Preco DECIMAL(10,2)
);

CREATE TABLE Tutor (
    ID_Tutor INT PRIMARY KEY,
    Nome VARCHAR(100)
);


CREATE TABLE CHECKIN_Ingresso (
    ID_CHECKIN INT PRIMARY KEY,
    Data_Hora DATETIME,
    Status VARCHAR(50),
    Preco DECIMAL(10,2),
    Tutor_s_n BOOLEAN,
    ID_Ingresso INT,
    Data_Visita DATE,
    Data_Hora_Checkin DATETIME,
    Status_Ingresso VARCHAR(50),
    fk_Compra_ID_Compra INT,
    fk_Tipo_ID_Tipo INT,
    CONSTRAINT fk_Checkin_Compra FOREIGN KEY (fk_Compra_ID_Compra) REFERENCES Compra(ID_Compra),
    CONSTRAINT fk_Checkin_Tipo FOREIGN KEY (fk_Tipo_ID_Tipo) REFERENCES Tipo(ID_Tipo)
);

CREATE TABLE Vinculo_Tutor_Ingresso (
    ID_Vinculo INT PRIMARY KEY,
    ID_Tutor INT,
    ID_CHECKIN INT,
    CONSTRAINT FK_Vinculo_Tutor FOREIGN KEY (ID_Tutor) REFERENCES Tutor(ID_Tutor),
    CONSTRAINT FK_Vinculo_Checkin FOREIGN KEY (ID_CHECKIN) REFERENCES CHECKIN_Ingresso(ID_CHECKIN)
);


CREATE TABLE Avaliacao (
    ID_Avaliacao INT PRIMARY KEY,
    Nota INT,
    Comentarios TEXT,
    Data_Avaliacao DATE,
    fk_Visitante_ID_Visitante INT,
    fk_Ingresso_ID_Ingresso INT,
    CONSTRAINT fk_Avaliacao_Visitante FOREIGN KEY (fk_Visitante_ID_Visitante) REFERENCES Visitante(ID_Visitante),
    CONSTRAINT fk_Avaliacao_Checkin FOREIGN KEY (fk_Ingresso_ID_Ingresso) REFERENCES CHECKIN_Ingresso(ID_CHECKIN)
);

CREATE TABLE Reembolso (
    ID_Reembolso INT PRIMARY KEY,
    Data_Solicitacao DATE,
    Status VARCHAR(50),
    Valor_Reembolso DECIMAL(10,2),
    Motivo TEXT,
    fk_CHECKIN_Ingresso_ID INT,
    CONSTRAINT fk_Reembolso_Checkin FOREIGN KEY (fk_CHECKIN_Ingresso_ID) REFERENCES CHECKIN_Ingresso(ID_CHECKIN)
);

CREATE TABLE Horario_Funcionamento (
    ID_Funcionamento INT PRIMARY KEY,
    Hora_Abertura TIME,
    Data_Inicio DATE,
    Hora_Encerramento TIME,
    Data_Fim DATE,
    Descricao TEXT
);

CREATE TABLE Capacidade_Diaria (
    ID_Capacidade_Diaria INT PRIMARY KEY,
    Quantidade_Maxima INT,
    Vigencia DATE,
    fk_Horario_Funcionamento INT
);

CREATE TABLE Funcionamento_Capacidade (
    ID_Funcionamento_Capacidade INT PRIMARY KEY,
    fk_Horario_Funcionamento INT,
    fk_Capacidade_Diaria INT,
    CONSTRAINT FK_FuncionamentoCapacidade_HorarioFuncionamento FOREIGN KEY (fk_Horario_Funcionamento) REFERENCES Horario_Funcionamento(ID_Funcionamento),
    CONSTRAINT FK_FuncionamentoCapacidade_CapacidadeDiaria FOREIGN KEY (fk_Capacidade_Diaria) REFERENCES Capacidade_Diaria(ID_Capacidade_Diaria)
);

CREATE TABLE Admin (
    ID_admin INT PRIMARY KEY,
    Nome VARCHAR(100),
    Data_Cadastro DATE,
    Senha VARCHAR(255),
    Cargo VARCHAR(50),
    Ultimo_Login DATETIME
);

CREATE TABLE Acoes_Admin (
    ID_Acoes INT PRIMARY KEY,
    Acao VARCHAR(100),
    Descricao TEXT,
    Data_Hora DATETIME,
    fk_Admin_ID_admin INT,
    CONSTRAINT fk_Acoes_Admin FOREIGN KEY (fk_Admin_ID_admin) REFERENCES Admin(ID_admin)
);

CREATE TABLE Permissoes (
    ID_Permissao INT PRIMARY KEY,
    Nome varchar(200)
);

CREATE TABLE Cargo_Permissoes (
	ID_Cargo_Permissoes INT PRIMARY KEY,
    fk_Permissoes_ID_Permissao INT,
    fk_Admin_ID_admin INT,
    PRIMARY KEY (fk_Permissoes_ID_Permissao, fk_Admin_ID_admin),
    CONSTRAINT fk_Cargo_Permissoes_Permissao FOREIGN KEY (fk_Permissoes_ID_Permissao) REFERENCES Permissoes(ID_Permissao),
    CONSTRAINT fk_Cargo_Permissoes_Admin FOREIGN KEY (fk_Admin_ID_admin) REFERENCES Admin(ID_admin)
);

CREATE TABLE Conteudo_Site (
    ID_Site INT PRIMARY KEY,
    Tipo VARCHAR(50),
    Data_Publicacao DATE,
    Autor VARCHAR(100),
    fk_Admin_ID_admin INT,
    CONSTRAINT fk_Conteudo_Admin FOREIGN KEY (fk_Admin_ID_admin) REFERENCES Admin(ID_admin)
);

-- 1) Visitante
INSERT INTO Visitante (ID_Visitante, Nome, CPF, Telefone, Email, Endereco, Idade) VALUES
(1, 'Ana Silva',    '123.456.789-00', '(11) 91234-0001', 'ana.silva@example.com',    'Rua A, 100', 28),
(2, 'Bruno Costa',  '987.654.321-11', '(11) 91234-0002', 'bruno.costa@example.com',  'Av. B, 200', 35),
(3, 'Carla Souza',  '111.222.333-44', '(11) 91234-0003', 'carla.souza@example.com',  'Trav. C, 300', 22),
(4, 'Diego Rocha',  '555.666.777-88', '(11) 91234-0004', 'diego.rocha@example.com',  'Praça D, 400', 41),
(5, 'Elisa Martins','999.888.777-66', '(11) 91234-0005', 'elisa.martins@example.com','Alameda E, 500', 30);

-- 2) Promocao
INSERT INTO Promocao (ID_Promocao, Codigo_Promocional, Tipo_Desconto, Data_Inicio, Desconto_Valor, Data_Fim) VALUES
(1, 'PROMO10', 'Percentual', '2025-01-01', 10.00, '2025-03-31'),
(2, 'PROMO20', 'Percentual', '2025-02-15', 20.00, '2025-04-15'),
(3, 'FLAT50',  'Valor Fixo', '2025-03-01', 50.00, '2025-05-01'),
(4, 'EARLYBIRD', 'Percentual','2025-04-01', 15.00, '2025-04-30'),
(5, 'VIP5',    'Percentual', '2025-01-10', 5.00,  '2025-12-31');

-- 3) Detalhes_Pagamento
INSERT INTO Detalhes_Pagamento (ID_Pagamento, Nome_Titular_Cartao, Numero_Cartao, Cartao_Validade, Codigo_Boleto, Metodo) VALUES
(1, 'Ana Silva',     '4111111111111111', '12/26', 'BOLETO001', 'Cartão'),
(2, 'Bruno Costa',   '5555555555554444', '11/25', 'BOLETO002', 'Cartão'),
(3, 'Carla Souza',   '378282246310005',  '10/24', 'BOLETO003', 'Cartão'),
(4, 'Diego Rocha',   NULL,               NULL,     'BOLETO004', 'Boleto'),
(5, 'Elisa Martins', '6011111111111117', '09/27', 'BOLETO005', 'Cartão');

-- 4) Pagamento (usa subquery para fk_Detalhes_Pagamento_ID)
INSERT INTO Pagamento (ID_Pagamento, Metodo, Status_Compra, Data_Processamento, fk_Detalhes_Pagamento_ID) VALUES
(1, 'Cartão', 'Concluído','2025-04-01 10:00:00',
    (SELECT ID_Pagamento FROM Detalhes_Pagamento WHERE Numero_Cartao = '4111111111111111')),
(2, 'Cartão', 'Pendente', '2025-04-02 11:30:00',
    (SELECT ID_Pagamento FROM Detalhes_Pagamento WHERE Numero_Cartao = '5555555555554444')),
(3, 'Cartão', 'Concluído','2025-04-03 12:45:00',
    (SELECT ID_Pagamento FROM Detalhes_Pagamento WHERE Numero_Cartao = '378282246310005')),
(4, 'Boleto', 'Concluído','2025-04-04 14:00:00',
    (SELECT ID_Pagamento FROM Detalhes_Pagamento WHERE Codigo_Boleto   = 'BOLETO004')),
(5, 'Cartão', 'Cancelado','2025-04-05 15:15:00',
    (SELECT ID_Pagamento FROM Detalhes_Pagamento WHERE Numero_Cartao = '6011111111111117'));

-- 5) Compra (subqueries para fk_Visitante, fk_Promocao, fk_Pagamento)
INSERT INTO Compra (ID_Compra, Data_Compra, Valor_Total, fk_Visitante_ID_Visitante, fk_Promocao_ID_Promocao, fk_Pagamento_ID_Pagamento) VALUES
(1, '2025-04-10 09:00:00', 150.00,
    (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Ana Silva'),
    (SELECT ID_Promocao  FROM Promocao  WHERE Codigo_Promocional = 'PROMO10'),
    (SELECT ID_Pagamento FROM Pagamento WHERE Status_Compra = 'Concluído' AND ID_Pagamento = 1)),
(2, '2025-04-11 10:30:00', 200.00,
    (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Bruno Costa'),
    (SELECT ID_Promocao  FROM Promocao  WHERE Codigo_Promocional = 'PROMO20'),
    (SELECT ID_Pagamento FROM Pagamento WHERE ID_Pagamento = 2)),
(3, '2025-04-12 11:45:00', 120.00,
    (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Carla Souza'),
    (SELECT ID_Promocao  FROM Promocao  WHERE Codigo_Promocional = 'FLAT50'),
    (SELECT ID_Pagamento FROM Pagamento WHERE ID_Pagamento = 3)),
(4, '2025-04-13 14:20:00', 300.00,
    (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Diego Rocha'),
    (SELECT ID_Promocao  FROM Promocao  WHERE Codigo_Promocional = 'EARLYBIRD'),
    (SELECT ID_Pagamento FROM Pagamento WHERE ID_Pagamento = 4)),
(5, '2025-04-14 16:00:00',  80.00,
    (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Elisa Martins'),
    (SELECT ID_Promocao  FROM Promocao  WHERE Codigo_Promocional = 'VIP5'),
    (SELECT ID_Pagamento FROM Pagamento WHERE ID_Pagamento = 5));

-- 6) Tutor
INSERT INTO Tutor (ID_Tutor, Nome) VALUES
(1, 'Maria Alves'),
(2, 'Pedro Lima'),
(3, 'Juliana Fernandes'),
(4, 'Rafael Santos'),
(5, 'Patrícia Oliveira');

-- 7) Tipo
INSERT INTO Tipo (ID_Tipo, Tipo_Ingresso, Descricao, Quantidade_Disponivel, Preco) VALUES
(1, 'Adulto',   'Ingresso para adultos',   100, 50.00),
(2, 'Criança',  'Ingresso infantil',       50,  25.00),
(3, 'Idoso',    'Ingresso para idosos',    30,  30.00),
(4, 'Estudante','Ingresso para estudantes',70,  40.00),
(5, 'VIP',      'Ingresso VIP',            20, 100.00);

-- 8) CHECKIN_Ingresso (subqueries para fk_Tutor, fk_Compra, fk_Tipo)
INSERT INTO CHECKIN_Ingresso (
    ID_CHECKIN, Data_Hora, Status, Preco, Tutor_s_n, ID_Ingresso,
    Data_Visita, Data_Hora_Checkin, Status_Ingresso,
    fk_Tutor_ID_Tutor, fk_Compra_ID_Compra, fk_Tipo_ID_Tipo
) VALUES
(1, '2025-04-15 09:05:00', 'Ativo', 50.00, FALSE, 1, '2025-05-01', '2025-05-01 09:05:00', 'Usado',
    (SELECT ID_Tutor FROM Tutor WHERE Nome = 'Maria Alves'),
    (SELECT ID_Compra FROM Compra WHERE ID_Compra = 1),
    (SELECT ID_Tipo   FROM Tipo  WHERE Tipo_Ingresso = 'Adulto')),
(2, '2025-04-15 09:10:00', 'Ativo', 25.00, TRUE, 2, '2025-05-02', '2025-05-02 09:10:00', 'Usado',
    (SELECT ID_Tutor FROM Tutor WHERE Nome = 'Pedro Lima'),
    (SELECT ID_Compra FROM Compra WHERE ID_Compra = 2),
    (SELECT ID_Tipo   FROM Tipo  WHERE Tipo_Ingresso = 'Criança')),
(3, '2025-04-15 09:15:00', 'Ativo', 30.00, FALSE, 3, '2025-05-03', '2025-05-03 09:15:00', 'Usado',
    (SELECT ID_Tutor FROM Tutor WHERE Nome = 'Juliana Fernandes'),
    (SELECT ID_Compra FROM Compra WHERE ID_Compra = 3),
    (SELECT ID_Tipo   FROM Tipo  WHERE Tipo_Ingresso = 'Idoso')),
(4, '2025-04-15 09:20:00', 'Ativo', 40.00, TRUE, 4, '2025-05-04', '2025-05-04 09:20:00', 'Usado',
    (SELECT ID_Tutor FROM Tutor WHERE Nome = 'Rafael Santos'),
    (SELECT ID_Compra FROM Compra WHERE ID_Compra = 4),
    (SELECT ID_Tipo   FROM Tipo  WHERE Tipo_Ingresso = 'Estudante')),
(5, '2025-04-15 09:25:00', 'Ativo',100.00, FALSE, 5, '2025-05-05', '2025-05-05 09:25:00', 'Usado',
    (SELECT ID_Tutor FROM Tutor WHERE Nome = 'Patrícia Oliveira'),
    (SELECT ID_Compra FROM Compra WHERE ID_Compra = 5),
    (SELECT ID_Tipo   FROM Tipo  WHERE Tipo_Ingresso = 'VIP'));

-- 9) Avaliacao (subqueries para fk_Visitante e fk_Ingresso)
INSERT INTO Avaliacao (ID_Avaliacao, Nota, Comentarios, Data_Avaliacao, fk_Visitante_ID_Visitante, fk_Ingresso_ID_Ingresso) VALUES
(1, 5, 'Excelente experiência', '2025-05-02',
    (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Ana Silva'),
    (SELECT ID_CHECKIN  FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 1)),
(2, 4, 'Muito bom, porém poderia melhorar', '2025-05-03',
    (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Bruno Costa'),
    (SELECT ID_CHECKIN  FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 2)),
(3, 3, 'Ok, mas fila longa', '2025-05-04',
    (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Carla Souza'),
    (SELECT ID_CHECKIN  FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 3)),
(4, 5, 'Adorei!', '2025-05-05',
    (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Diego Rocha'),
    (SELECT ID_CHECKIN  FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 4)),
(5, 2, 'Pouca organização', '2025-05-06',
    (SELECT ID_Visitante FROM Visitante WHERE Nome = 'Elisa Martins'),
    (SELECT ID_CHECKIN  FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 5));

-- 10) Reembolso (subquery para fk_CHECKIN_Ingresso_ID)
INSERT INTO Reembolso (ID_Reembolso, Data_Solicitacao, Status, Valor_Reembolso, Motivo, fk_CHECKIN_Ingresso_ID) VALUES
(1, '2025-05-07', 'Aprovado', 50.00, 'Mudança de planos',
    (SELECT ID_CHECKIN FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 1)),
(2, '2025-05-08', 'Pendente', 25.00, 'Problema de saúde',
    (SELECT ID_CHECKIN FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 2)),
(3, '2025-05-09', 'Negado',   0.00,  'Atraso no check-in',
    (SELECT ID_CHECKIN FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 3)),
(4, '2025-05-10', 'Aprovado',100.00, 'Evento cancelado',
    (SELECT ID_CHECKIN FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 5)),
(5, '2025-05-11', 'Pendente', 40.00, 'Problema de transporte',
    (SELECT ID_CHECKIN FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 4));

-- 11) Horario_Funcionamento
INSERT INTO Horario_Funcionamento (ID_Funcionamento, Hora_Abertura, Data_Inicio, Hora_Encerramento, Data_Fim, Descricao) VALUES
(1, '08:00:00','2025-01-01','18:00:00','2025-06-30','Horário padrão'),
(2, '09:00:00','2025-07-01','17:00:00','2025-12-31','Horário de verão'),
(3, '10:00:00','2025-05-01','16:00:00','2025-05-31','Horário especial Maio'),
(4, '08:30:00','2025-04-01','18:30:00','2025-04-30','Horário Abril'),
(5, '07:00:00','2025-02-01','19:00:00','2025-02-28','Horário Fevereiro');

-- 12) Capacidade_Diaria (subquery para fk_Horario_Funcionamento)
INSERT INTO Capacidade_Diaria (ID_Capacidade_Diaria,Quantidade_Maxima, Vigencia, fk_Horario_Funcionamento) VALUES
(1,100, '2025-01-01', (SELECT ID_Funcionamento FROM Horario_Funcionamento WHERE ID_Funcionamento = 1)),
(2,150, '2025-07-01', (SELECT ID_Funcionamento FROM Horario_Funcionamento WHERE ID_Funcionamento = 2)),
(3,120, '2025-05-01', (SELECT ID_Funcionamento FROM Horario_Funcionamento WHERE ID_Funcionamento = 3)),
(4,130, '2025-04-01', (SELECT ID_Funcionamento FROM Horario_Funcionamento WHERE ID_Funcionamento = 4)),
(5,110, '2025-02-01', (SELECT ID_Funcionamento FROM Horario_Funcionamento WHERE ID_Funcionamento = 5));

INSERT INTO Funcionamento_Capacidade (ID_Funcionamento_Capacidade, fk_Horario_Funcionamento, fk_Capacidade_Diaria)
VALUES
  (1,(SELECT ID_Funcionamento FROM Horario_Funcionamento WHERE ID_Funcionamento = 1),
    (SELECT ID_Capacidade_Diaria FROM Capacidade_Diaria WHERE fk_Horario_Funcionamento = 1)
  ),
  (2,(SELECT ID_Funcionamento FROM Horario_Funcionamento WHERE ID_Funcionamento = 2),
    (SELECT ID_Capacidade_Diaria FROM Capacidade_Diaria WHERE fk_Horario_Funcionamento = 2)
  ),
  (3,(SELECT ID_Funcionamento FROM Horario_Funcionamento WHERE ID_Funcionamento = 3),
    (SELECT ID_Capacidade_Diaria FROM Capacidade_Diaria WHERE fk_Horario_Funcionamento = 3)
  ),
  (4,(SELECT ID_Funcionamento FROM Horario_Funcionamento WHERE ID_Funcionamento = 4),
    (SELECT ID_Capacidade_Diaria FROM Capacidade_Diaria WHERE fk_Horario_Funcionamento = 4)
  ),
  (5,(SELECT ID_Funcionamento FROM Horario_Funcionamento WHERE ID_Funcionamento = 5),
    (SELECT ID_Capacidade_Diaria FROM Capacidade_Diaria WHERE fk_Horario_Funcionamento = 5));

-- 13) Vinculo_Tutor_Ingresso (subqueries para ID_Tutor e ID_CHECKIN)
INSERT INTO Vinculo_Tutor_Ingresso (ID_Vinculo, ID_Tutor, ID_CHECKIN) VALUES
(1, (SELECT ID_Tutor FROM Tutor WHERE Nome = 'Maria Alves'), 
	(SELECT ID_CHECKIN FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 1)),
(2, (SELECT ID_Tutor FROM Tutor WHERE Nome = 'Pedro Lima'), 
    (SELECT ID_CHECKIN FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 2)),
(3, (SELECT ID_Tutor FROM Tutor WHERE Nome = 'Juliana Fernandes'), 
    (SELECT ID_CHECKIN FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 3)),
(4, (SELECT ID_Tutor FROM Tutor WHERE Nome = 'Rafael Santos'), 
    (SELECT ID_CHECKIN FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 4)),
(5, (SELECT ID_Tutor FROM Tutor WHERE Nome = 'Patrícia Oliveira'), 
    (SELECT ID_CHECKIN FROM CHECKIN_Ingresso WHERE ID_CHECKIN = 5));

-- 14) Admin
INSERT INTO Admin (ID_admin, Nome, Data_Cadastro, Senha, Cargo, Ultimo_Login) VALUES
(1, 'João Admin',     '2024-01-01','$2y$10$abc','Gerente', '2025-04-20 08:00:00'),
(2, 'Mariana Admin',  '2024-02-15','$2y$10$def','Supervisor','2025-04-21 09:15:00'),
(3, 'Lucas Admin',    '2024-03-10','$2y$10$ghi','Operador', '2025-04-22 10:30:00'),
(4, 'Fernanda Admin', '2024-04-05','$2y$10$jkl','Analista',  '2025-04-23 11:45:00'),
(5, 'Ricardo Admin',  '2024-05-20','$2y$10$mno','Diretor',   '2025-04-24 13:00:00');

-- 15) Acoes_Admin (subquery para fk_Admin_ID_admin)
INSERT INTO Acoes_Admin (ID_Acoes, Acao, Descricao, Data_Hora, fk_Admin_ID_admin) VALUES
(1,'Login','Usuário fez login','2025-04-20 08:00:00', (SELECT ID_admin FROM Admin WHERE Nome = 'João Admin')),
(2,'Alterar Promoção','Atualizou valores de desconto','2025-04-21 09:15:00', (SELECT ID_admin FROM Admin WHERE Nome = 'Mariana Admin')),
(3,'Cancelar Compra','Cancelou compra ID 3','2025-04-22 10:30:00', (SELECT ID_admin FROM Admin WHERE Nome = 'Lucas Admin')),
(4,'Atualizar Horário','Mudou horário Abril','2025-04-23 11:45:00', (SELECT ID_admin FROM Admin WHERE Nome = 'Fernanda Admin')),
(5,'Criar Usuário','Cadastrou novo admin','2025-04-24 13:00:00', (SELECT ID_admin FROM Admin WHERE Nome = 'Ricardo Admin'));

-- 16) Permissoes
INSERT INTO Permissoes (ID_Permissao, Nome) VALUES
(1, 'Acesso_Leitura'),
(2, 'Acesso_Pagamentos'),
(3, 'Acesso_Hoarios'),
(4, 'Gerenciamento_Usuários'),
(5, 'Configuração_Sistema');

-- 17) Cargo_Permissoes (subqueries para ambas as fks)
INSERT INTO Cargo_Permissoes (ID_Cargo_Permissoes,fk_Permissoes_ID_Permissao, fk_Admin_ID_admin) VALUES
(1,(SELECT ID_Permissao FROM Permissoes WHERE ID_Permissao = 1), (SELECT ID_admin FROM Admin WHERE Nome = 'João Admin')),
(2,(SELECT ID_Permissao FROM Permissoes WHERE ID_Permissao = 2), (SELECT ID_admin FROM Admin WHERE Nome = 'Mariana Admin')),
(3,(SELECT ID_Permissao FROM Permissoes WHERE ID_Permissao = 3), (SELECT ID_admin FROM Admin WHERE Nome = 'Lucas Admin')),
(4,(SELECT ID_Permissao FROM Permissoes WHERE ID_Permissao = 4), (SELECT ID_admin FROM Admin WHERE Nome = 'Fernanda Admin')),
(5,(SELECT ID_Permissao FROM Permissoes WHERE ID_Permissao = 5), (SELECT ID_admin FROM Admin WHERE Nome = 'Ricardo Admin'));

-- 18) Conteudo_Site (subquery para fk_Admin_ID_admin)
INSERT INTO Conteudo_Site (ID_Site, Tipo, Data_Publicacao, Autor, fk_Admin_ID_admin) VALUES
(1, 'Blog',    '2025-03-01', 'João Admin',     (SELECT ID_admin FROM Admin WHERE Nome = 'João Admin')),
(2, 'Notícia', '2025-03-15', 'Mariana Admin',  (SELECT ID_admin FROM Admin WHERE Nome = 'Mariana Admin')),
(3, 'FAQ',     '2025-04-01', 'Lucas Admin',    (SELECT ID_admin FROM Admin WHERE Nome = 'Lucas Admin')),
(4, 'Tutorial','2025-04-10', 'Fernanda Admin', (SELECT ID_admin FROM Admin WHERE Nome = 'Fernanda Admin')),
(5, 'Aviso',   '2025-04-20', 'Ricardo Admin',  (SELECT ID_admin FROM Admin WHERE Nome = 'Ricardo Admin'));

