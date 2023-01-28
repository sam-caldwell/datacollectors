/*

 */
create or replace procedure create_0030_table_notes() AS
$$
begin
    raise notice 'create_0030_table_notes';
    create table if not exists notes
    (
        id         serial        not null primary key,
        collection uuid          not null references note_set (id),
        title      varchar(2048) not null,
        body       text          not null,
        created    timestamp     not null default now(),
        constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call create_index('notes', false, ARRAY ['title']);
    call create_index('notes', false, ARRAY ['created']);
end
$$ language plpgsql;