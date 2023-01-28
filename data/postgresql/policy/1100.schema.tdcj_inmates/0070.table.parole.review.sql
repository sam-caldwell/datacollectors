/*
    Parole and mandatory supervision review records
 */
create or replace procedure create_0070_table_parole_review() AS
$$
begin
    create table if not exists parole_review
    (
        id         serial    not null primary key,
        sid        integer   not null references roster (sid),
        created    timestamp not null default now(),
        note_setId uuid      null     default null references note_set (id),
        constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call create_index('parole_review',   false, ARRAY['created']);
end
$$ language plpgsql;