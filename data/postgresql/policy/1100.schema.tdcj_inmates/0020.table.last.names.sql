/*
  A dictionary of known first names.  This is
  done to (a) reduce storage in teh inmate roster table
  as well as to deduplicate sid collection and speed up
  our sid refreshes by only covering untouched areas.
 */
create or replace procedure create_0020_table_last_names() AS
$$
begin
    raise notice 'create_0020_table_last_names()';
    create table if not exists last_names
    (
        id           serial       not null primary key,
        last_name    varchar(255) not null unique,
        created      timestamp    not null default now(),
        last_scanned timestamp    null     default null
    );
    call disable_updates('last_names');
    call create_index('last_names', false, ARRAY ['created']);
    call create_index('last_names', false, ARRAY ['last_scanned']);
end
$$ language plpgsql;
