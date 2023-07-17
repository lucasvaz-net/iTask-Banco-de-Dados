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