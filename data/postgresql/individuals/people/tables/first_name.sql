/*
  A dictionary of known first names.  This is
  done to (a) reduce storage in teh inmate roster table
  as well as to deduplicate sid collection and speed up
  our sid refreshes by only covering untouched areas.
 */
create table if not exists people.first_name
(
    id         serial       not null primary key,
    first_name varchar(255) not null unique,
    created    timestamp    not null default now()
        constraint valid_name check (first_name ~ '^[A-Z][a-zA-Z\`'']+')
);
call toolkit.disable_updates('people.first_names');
call toolkit.create_index('people.first_names', false, ARRAY ['created']);
