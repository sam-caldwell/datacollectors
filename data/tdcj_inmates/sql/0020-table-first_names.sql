/*
  A dictionary of known first names.  This is
  done to (a) reduce storage in teh inmate roster table
  as well as to deduplicate sid collection and speed up
  our sid refreshes by only covering untouched areas.
 */
create or replace procedure create_0020_table_first_names() AS
$$
begin
    raise notice 'create_0020_table_first_names()';
    create table if not exists first_names
    (
        id           serial       not null primary key,
        first_name   varchar(255) not null unique,
        created      timestamp    not null default now(),
        last_scanned timestamp    null     default null
    );
    call disable_updates('first_names');
    call create_index('first_names', false, ARRAY['created']);
    call create_index('first_names', false, ARRAY['last_scanned']);
end
$$ language plpgsql;
