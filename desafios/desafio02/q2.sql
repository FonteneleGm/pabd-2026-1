-- Após o COMMIT, a tabela possui apenas o registro válido ou ambos? 
-- Qual é a vantagem de usar SAVEPOINT aqui em vez de desistir de todo o processo de atualização do estoque?

-- Resposta: a tabela fica com os dois registros válidos (filme 1 e filme 2).
-- O do filme 9999 nunca entra.
-- Sem o SAVEPOINT, depois do erro a transação fica abortada e só dá pra
-- fazer ROLLBACK de tudo, perdendo também a primeira inserção que estava certa.
-- Com o savepoint só o trecho com erro é desfeito e o resto do lote continua.


BEGIN;

INSERT INTO inventory (film_id, store_id) VALUES (1, 1) RETURNING inventory_id;

SAVEPOINT updated_inventory;

INSERT INTO inventory (film_id, store_id) VALUES (9999, 1);

ROLLBACK TO SAVEPOINT updated_inventory;

INSERT INTO inventory (film_id, store_id) VALUES (2, 1) RETURNING inventory_id;

COMMIT;

SELECT inventory_id, film_id, store_id
FROM inventory
WHERE inventory_id > 4581
ORDER BY inventory_id;

