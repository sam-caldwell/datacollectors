create or replace procedure create_0531_func_add_visitation_eligibility() as
$$
begin
    create or replace function add_visitation_eligibility(sid integer, e varchar(255), note_text text) RETURNS boolean AS
    $_$
    declare
        collectionId uuid := add_note_set();
        noteId       integer;
    begin
        noteId := add_note(collectionId, 'visitation_eligibility for (sid=' + sid + ')', note_text);
        insert into visitation_eligibility(sid, note_setId, eligible) values (sid, collectionId, e);
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;