create table if not exists tdcj_inmates.release_information
(
    id      serial       not null primary key,
    sid     integer      not null references people.tx_sid (sid),
    title   varchar(255) not null,
    body    text         not null,
    created timestamp    not null default now(),
    constraint createdAfterProjectStart check (created > '01-01-2023')
);
call disable_updates('tdcj_inmates.release_information');
call create_index('tdcj_inmates.release_information', false, ARRAY ['title']);
call create_index('tdcj_inmates.release_information', false, ARRAY [ 'created']);
