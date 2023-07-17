CREATE VIEW ViewTarefasNaoExcluidas AS
SELECT T.id, T.titulo, T.descricao, T.data_vencimento, T.prioridade, C.nome AS categoria, S.nome AS status, U.nome AS usuario
FROM Tarefas T
JOIN Categoria C ON T.categoria_id = C.id
JOIN Status S ON T.status_id = S.id
JOIN Usuario U ON T.usuario_id = U.id
WHERE T.status_id <> 4;
