
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