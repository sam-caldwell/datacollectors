/*
 * Here we can capture notes about people
 * in our system.  This is the list of semi-structured
 * metadata.  For each person
 */
create table if not exists people.notes
(
    id       serial  not null primary key,
    identity integer not null references people.identity (id),
    content  text    not null,
    created timestamp not null default now()
);
call toolkit.disable_update('people.notes');
call toolkit.create_index('people.notes', false, ARRAY ['created']);
