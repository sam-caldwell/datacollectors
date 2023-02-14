/*
    Age-tracking table.  Used to eventually determine
    date of birth from the table's updates over time.
 */
create table if not exists tdcj_inmates.inmate_age
(
    id      serial    not null primary key,
    sid     integer   not null references people.tx_sid (sid),
    age     integer   not null,
    created timestamp not null default now(),
    constraint ageIsAdultOrNull check (age >= 16),
    constraint createdAfterProjectStart check (created > '01-01-2023')
);
call toolkit.disable_updates('tdcj_inmates.inmate_age');
call toolkit.create_index('tdcj_inmates.inmate_age', false, ARRAY ['age']);
call toolkit.create_index('tdcj_inmates.inmate_age', false, ARRAY [ 'created']);

