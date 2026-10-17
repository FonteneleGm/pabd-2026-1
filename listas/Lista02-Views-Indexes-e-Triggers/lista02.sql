/*
-- LISTA DE EXERCÍCIOS 2 - Views, Indexes e Triggers
Mais detalhes em: "/listas/Lista02-Views-Indexes-e-Triggers"
*/

-- 1 Questão 01 - View de Performance da Equipe

drop view if exists v_staff_performance;
CREATE VIEW v_staff_performance AS
SELECT 
    s.staff_id,
    s.first_name || ' ' || s.last_name AS nome_completo,
    ci.city || ', '|| co.country AS endereco_loja,
    COALESCE(r_tot.total_locacoes, 0) AS total_locacoes,
    COALESCE(p_tot.valor_total_arrecadado, 0) AS valor_total_arrecadado
FROM staff s
JOIN store st ON s.store_id = st.store_id
JOIN address a ON st.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
LEFT JOIN (
    SELECT staff_id, COUNT(rental_id) AS total_locacoes
    FROM rental
    GROUP BY staff_id
) r_tot ON s.staff_id = r_tot.staff_id

LEFT JOIN (
    SELECT staff_id, SUM(amount) AS valor_total_arrecadado
    FROM payment
    GROUP BY staff_id
) p_tot ON s.staff_id = p_tot.staff_id;

select * from v_staff_performance;

-- 2
drop materialized view if exists mv_category_total_sales;
create materialized view mv_category_total_sales as
select 
    c.name as category_name,
    coalesce(sum(p.amount), 0) as total_revenue
from category c
join film_category fc on c.category_id = fc.category_id
join inventory i on fc.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by c.name;

-- Cria um índice ÚNICO obrigatório baseado no nome da categoria para permitir o REFRESH CONCURRENTLY
drop index if exists idx_mv_category_total_sales_name;
create unique index idx_mv_category_total_sales_name 
on mv_category_total_sales (category_name);

explain analyze
select * from mv_category_total_sales;

-- 3 
drop index if exists idx_rental_pending;
create index idx_rental_pending 
on rental (rental_id) 
where return_date is null;

explain analyze 
select rental_id, rental_date, customer_id, inventory_id 
from rental 
where return_date is null;

-- 4 
drop index if exists idx_film_description_fts;
create index idx_film_description_fts 
on film using gin (to_tsvector('english', description));

explain analyze 
select film_id, title, description 
from film 
where to_tsvector('english', description) @@ to_tsquery('english', 'documentary & drama');

--5
drop index if exists idx_payment_customer_date;
create index idx_payment_customer_date 
on payment (customer_id, payment_date desc);

explain analyze
SELECT * FROM payment 
WHERE customer_id = 1
ORDER BY payment_date DESC;
--6
drop index if exists idx_payment_customer_date;
create index idx_customer_email_lower 
on customer (lower(email));

explain analyze 
select customer_id, first_name, last_name, email 
from customer 
where lower(email) = lower('mary.smith@sakilacustomer.org');

--7
create or replace function validate_rental_dates()
    returns trigger 
    language plpgsql
as $$
begin
    
    if new.return_date is not null and new.return_date < new.rental_date then
        raise exception 'erro de validação: a data de devolução (%) não pode ser anterior à data de locação (%).', 
            new.return_date, new.rental_date;
    end if;
    
    return new;
end
$$;

drop trigger if exists trg_validate_rental_dates on rental;

create trigger trg_validate_rental_dates
before insert or update on rental
for each row
execute function validate_rental_dates();

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES ('2026-06-10 14:00:00', 1, 1, '2026-06-05 14:00:00', 1);

INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES ('2026-06-10 14:00:00', 1, 1, '2026-06-15 14:00:00', 1);
--7     