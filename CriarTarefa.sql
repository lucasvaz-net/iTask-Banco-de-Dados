
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