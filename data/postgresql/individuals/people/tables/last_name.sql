/*
  A dictionary of known first names.  This is
  done to (a) reduce storage in teh inmate roster table
  as well as to deduplicate sid collection and speed up
  our sid refreshes by only covering untouched areas.
 */
create table if not exists people.last_names
(
    id        serial       not null primary key,
    last_name varchar(255) not null unique,
    created   timestamp    not null default now()
        constraint valid_name check (last_name ~ '^[A-Z][a-zA-Z\`'']+')
);
call toolkit.disable_updates('people.last_names');
call toolkit.create_index('people.last_names', false, ARRAY ['created']);
