create or replace procedure create_0520_add_note() as
$$
begin
    create or replace function add_note(collection uuid, title varchar(2048), body text) RETURNS boolean AS
    $T$
    begin
        insert into notes(collection,title,body) values(collection,title,body);
        return true;
    end
    $T$ LANGUAGE plpgsql;
end
$$ language plpgsql;
