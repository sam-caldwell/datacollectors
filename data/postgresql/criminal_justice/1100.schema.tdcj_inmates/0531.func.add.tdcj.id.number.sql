create or replace procedure create_0531_add_tdcj_id_number() as
$$
begin
    create or replace function add_tdcj_id_number(sid integer, tdcj_id_number integer) RETURNS boolean AS
    $_$
    begin
        insert into tdcj_id_numbers(sid, tdcj_id)
        values (sid, tdcj_id_number);
        return true;
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;