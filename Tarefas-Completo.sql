CREATE DATABASE [db_a9c2c8_tarefas];

CREATE TABLE [dbo].[Categoria] ([id] int NOT NULL, [nome] varchar(50) NOT NULL);
CREATE TABLE [dbo].[LogTarefas] ([id] int NOT NULL, [tarefa_id] int, [data_registro] datetime, [descricao] text);
CREATE TABLE [dbo].[Status] ([id] int NOT NULL, [nome] varchar(50) NOT NULL);
CREATE TABLE [dbo].[Tarefas] ([id] int NOT NULL, [titulo] varchar(100) NOT NULL, [descricao] text, [data_vencimento] date, [prioridade] int, [categoria_id] int, [status_id] int, [usuario_id] int);
CREATE TABLE [dbo].[Usuario] ([id] int NOT NULL, [nome] varchar(50) NOT NULL, [email] varchar(100) NOT NULL, [senha] varchar(100));

ALTER TABLE [dbo].[Categoria] ADD CONSTRAINT [PK__Categori__3213E83FC2844ECB] PRIMARY KEY ([id]);
ALTER TABLE [dbo].[LogTarefas] ADD CONSTRAINT [PK__LogTaref__3213E83F03AF9258] PRIMARY KEY ([id]);
ALTER TABLE [dbo].[Status] ADD CONSTRAINT [PK__Status__3213E83FA3CF519E] PRIMARY KEY ([id]);
ALTER TABLE [dbo].[Tarefas] ADD CONSTRAINT [PK__Tarefas__3213E83F359F21DC] PRIMARY KEY ([id]);
ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT [PK__Usuario__3213E83F19463B53] PRIMARY KEY ([id]);

CREATE PROCEDURE [dbo].[AlterarTarefa] CREATE PROCEDURE AlterarTarefa (
    @tarefa_id INT,
    @titulo VARCHAR(100),
    @descricao NVARCHAR(MAX),
    @data_vencimento DATE,
    @prioridade INT,
    @categoria_id INT,
    @status_id INT,
    @usuario_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Obter os valores atuais da tarefa antes da atualização
    DECLARE @titulo_antigo VARCHAR(100);
    DECLARE @descricao_antiga NVARCHAR(MAX);
    DECLARE @data_vencimento_antiga DATE;
    DECLARE @prioridade_antiga INT;
    DECLARE @categoria_id_antiga INT;
    DECLARE @status_id_antigo INT;
    DECLARE @usuario_id_antigo INT;

    SELECT @titulo_antigo = titulo,
           @descricao_antiga = descricao,
           @data_vencimento_antiga = data_vencimento,
           @prioridade_antiga = prioridade,
           @categoria_id_antiga = categoria_id,
           @status_id_antigo = status_id,
           @usuario_id_antigo = usuario_id
    FROM Tarefas
    WHERE id = @tarefa_id;

    -- Atualizar a tarefa
    UPDATE Tarefas
    SET titulo = @titulo,
        descricao = @descricao,
        data_vencimento = @data_vencimento,
        prioridade = @prioridade,
        categoria_id = @categoria_id,
        status_id = @status_id,
        usuario_id = @usuario_id
    WHERE id = @tarefa_id;

    -- Registrar o log da alteração
    INSERT INTO LogTarefas (tarefa_id, data_registro, descricao)
    VALUES (@tarefa_id, GETDATE(), 'Tarefa alterada: ' +
            'Título antigo: ' + @titulo_antigo + ', ' +
            'Descrição antiga: ' + @descricao_antiga + ', ' +
            'Data de vencimento antiga: ' + CONVERT(VARCHAR, @data_vencimento_antiga) + ', ' +
            'Prioridade antiga: ' + CONVERT(VARCHAR, @prioridade_antiga) + ', ' +
            'Categoria antiga: ' + CONVERT(VARCHAR, @categoria_id_antiga) + ', ' +
            'Status antigo: ' + CONVERT(VARCHAR, @status_id_antigo) + ', ' +
            'Usuário antigo: ' + CONVERT(VARCHAR, @usuario_id_antigo));

    SELECT 'Tarefa alterada com sucesso.' AS mensagem;
END;
;
CREATE PROCEDURE [dbo].[CriarTarefa] CREATE PROCEDURE CriarTarefa (
    @titulo VARCHAR(100),
    @descricao TEXT,
    @data_vencimento DATE,
    @prioridade INT,
    @categoria_id INT,
    @status_id INT,
    @usuario_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Inserir a nova tarefa
    INSERT INTO Tarefas (titulo, descricao, data_vencimento, prioridade, categoria_id, status_id, usuario_id)
    VALUES (@titulo, @descricao, @data_vencimento, @prioridade, @categoria_id, @status_id, @usuario_id);

    -- Obter o ID da tarefa recém-inserida
    DECLARE @tarefa_id INT;
    SET @tarefa_id = SCOPE_IDENTITY();

    -- Registrar o log
    INSERT INTO LogTarefas (tarefa_id, data_registro, descricao)
    VALUES (@tarefa_id, GETDATE(), 'Tarefa criada');

    SELECT 'Tarefa criada com sucesso.' AS mensagem;
END;
;
CREATE PROCEDURE [dbo].[ExcluirTarefa] CREATE PROCEDURE ExcluirTarefa (
    @tarefa_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Atualizar o status da tarefa para excluído
    UPDATE Tarefas
    SET status_id = 4
    WHERE id = @tarefa_id;

    -- Registrar o log da exclusão
    INSERT INTO LogTarefas (tarefa_id, data_registro, descricao)
    VALUES (@tarefa_id, GETDATE(), 'Tarefa excluída');

    SELECT 'Tarefa excluída com sucesso.' AS mensagem;
END;
;
CREATE PROCEDURE [dbo].[VerificaLogin] CREATE PROCEDURE VerificaLogin
    @Email VARCHAR(100),
    @Senha VARCHAR(100),
    @IsValid BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM ViewUsuario WHERE Email = @Email AND Senha = @Senha)
        SET @IsValid = 1;
    ELSE
        SET @IsValid = 0;
END;
CREATE PROCEDURE [dbo].[VerificarLoginSenha] -- Criação da stored procedure VerificarLoginSenha
CREATE PROCEDURE VerificarLoginSenha
    @email VARCHAR(100),
    @senha VARCHAR(100),
    @status INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM Usuario WHERE email = @email AND senha = @senha)
        SET @status = 1; -- Login válido
    ELSE
        SET @status = 0; -- Login inválido
END
;


CREATE VIEW [dbo].[ViewTarefas] AS CREATE VIEW ViewTarefas AS
SELECT T.id AS tarefa_id, L.data_registro, L.descricao AS log_descricao,
       T.titulo, T.descricao AS tarefa_descricao, T.data_vencimento, T.prioridade,
       C.nome AS categoria, S.nome AS status,
       U.nome AS usuario
FROM Tarefas T
INNER JOIN LogTarefas L ON T.id = L.tarefa_id
INNER JOIN Categoria C ON T.categoria_id = C.id
INNER JOIN Status S ON T.status_id = S.id
INNER JOIN Usuario U ON T.usuario_id = U.id

;
CREATE VIEW [dbo].[ViewTarefasNaoExcluidas] AS CREATE VIEW ViewTarefasNaoExcluidas AS
SELECT T.id, T.titulo, T.descricao, T.data_vencimento, T.prioridade, C.nome AS categoria, S.nome AS status, U.nome AS usuario
FROM Tarefas T
JOIN Categoria C ON T.categoria_id = C.id
JOIN Status S ON T.status_id = S.id
JOIN Usuario U ON T.usuario_id = U.id
WHERE T.status_id <> 4;
;
CREATE VIEW [dbo].[viewusuario] AS 
create view viewusuario
as
select * from usuario;