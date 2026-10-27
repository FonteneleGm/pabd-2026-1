create or replace function verifica_piloto()
    returns trigger
    language plpgsql
as
$$
 begin
     if exists(select 1 from race_data RD where OLD.id = RD.driver_id) then
        raise expection 'Nao e possivel excluir dados desse piloto % ', OLD.name;
    end if;

    return OLD;
 end;
$$;


create trigger driver_nao_pode
    before delete
    on driver
    for each row
    execute procedure verifica_piloto();

    delete from driver
    where id = 'ayrton-senna';