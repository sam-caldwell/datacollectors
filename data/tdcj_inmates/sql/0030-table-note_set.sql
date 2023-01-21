/*
    A pair of tables which allow the system to track notes about
    an arbitrary entity in the database.  For example, an inmate
    record in the roster table may have a note-set containing one
    or more notes.
 */
create or replace procedure create_0030_table_note_set() AS
$$
begin
    raise notice 'create_0030_table_note_set()';
    create table if not exists note_set
    (
        id      uuid      not null primary key,
        created timestamp not null default now()
            constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call create_index('note_set', false, ARRAY ['id']);
    call create_index('note_set', false, ARRAY ['created']);
end
$$ language plpgsql;
