create or replace procedure create_0520_func_drop_note_by_title() as
$$
begin
   create or replace function drop_note_by_id(t integer) RETURNS boolean AS
    $_$
    begin
        delete from notes where id=t;
        return true;
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;
