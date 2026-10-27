-- O cliente cadastrado no passo 1 ainda existe na tabela? 
-- Por que o banco de dados deve "esquecer" todo o processo se um detalhe do cadastro falhar?

-- Resposta: Não, o cliente não existe mais. Dentro da transação ele aparecia,
-- mas depois do ROLLBACK a consulta retorna 0 linhas (o endereço também sumiu).
-- O banco desfaz tudo por causa da atomicidade: o cadastro é uma operação só,
-- ou fica completo ou não fica. Se guardasse só uma parte ia sobrar dado
-- solto, tipo endereço sem cliente ou cliente incompleto.

BEGIN;

INSERT INTO address (address, district, city_id, postal_code, phone)
VALUES ('Rua Escalada do Morro, 6742', 'Ponta Negra', 300, '59090567', '84999990002')
RETURNING address_id;

INSERT INTO customer (store_id, first_name, last_name, email, address_id, activebool, active)
VALUES (1, 'Guilherme', 'Leal', 'gui.leals@e.com', currval('address_address_id_seq'), TRUE, 1);

SELECT customer_id, first_name, last_name, address_id
FROM customer
WHERE email = 'gui.leals@e.com';

INSERT INTO customer (store_id, first_name, last_name, email, address_id, activebool, active)
VALUES (1, NULL, 'Teste', 'teste@email.com', currval('address_address_id_seq'), TRUE, 1);

ROLLBACK;

SELECT count(*) FROM customer WHERE email = 'gui.leals@e.com';
SELECT count(*) FROM address WHERE address_id > 605;

