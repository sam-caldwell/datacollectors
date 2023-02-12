/*
 * persons with criminal records in texas have a state identifier (sid)
 * which is a unique identifier in the TDCJ inmate database, sex offender
 * registry and other systems managed by the state of Texas.
 */
create table if not exists people.tx_sid
(
    id      integer   not null primary key references people.identity (id),
    sid     integer   not null unique,
    created timestamp not null default now(),
    constraint positiveSidOnly check (sid > 0)
);
call toolkit.disable_updates('people.tx_sid');
call toolkit.create_index('people.tx_sid', true, ARRAY ['sid']);
call toolkit.create_index('people.tx_sid', false, ARRAY ['created'])
