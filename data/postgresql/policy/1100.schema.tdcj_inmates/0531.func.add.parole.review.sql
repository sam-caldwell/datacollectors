create or replace procedure create_0531_func_add_parole_review() as
$$
begin
    create or replace function add_parole_review(sid integer, detail text) RETURNS boolean AS
    $_$
    declare
        collectionId uuid := add_note_set();
        noteId       integer;
    begin
        noteId := add_note(collectionId, 'Parole Decision (sid=' + sid + ')', detail);
        insert into parole_review (sid, note_setId) values (sid, collectionId);
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;
