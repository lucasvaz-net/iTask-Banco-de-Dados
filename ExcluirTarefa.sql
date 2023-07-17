
CREATE PROCEDURE [dbo].[ExcluirTarefa] CREATE PROCEDURE ExcluirTarefa (
    @tarefa_id INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Atualizar o status da tarefa para exclu�do
    UPDATE Tarefas
    SET status_id = 4
    WHERE id = @tarefa_id;

    -- Registrar o log da exclus�o
    INSERT INTO LogTarefas (tarefa_id, data_registro, descricao)
    VALUES (@tarefa_id, GETDATE(), 'Tarefa exclu�da');

    SELECT 'Tarefa exclu�da com sucesso.' AS mensagem;
END;
;