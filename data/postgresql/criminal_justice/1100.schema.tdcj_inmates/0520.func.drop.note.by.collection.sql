create or replace procedure create_0520_func_drop_note_by_collection() as
$$
begin
    create or replace function drop_note_by_collection(c uuid) RETURNS boolean AS
    $_$
    begin
        delete from notes where collection = c;
        delete from note_set where id = c;
        return true;
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;
