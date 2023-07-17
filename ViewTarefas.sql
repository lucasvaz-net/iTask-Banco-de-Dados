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