create or replace procedure create_0531_func_add_facility() as
$$
begin
    create or replace function add_facility(n varchar(1024), a varchar(2048), p varchar(255),
                                            note_text text) RETURNS boolean AS
    $_$
    declare
        collectionId uuid := add_note_set();
        noteId       integer;
    begin
        noteId := add_note(collectionId, 'facility (' + n + ') note', note_text);
        insert into facilities(note_setId, name, address, phone)
        values (collectionId, n, a, p);
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;
