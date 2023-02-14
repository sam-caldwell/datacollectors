create table if not exists tdcj_inmates.facilities
(
    id      serial        not null primary key,
    name    varchar(1024) not null,
    address varchar(2048) null     default null,
    phone   varchar(255)  null     default null,
    created timestamp     not null default now()
        constraint createdAfterProjectStart check (created > '01-01-2023')
);
call toolkit.disable_updates('tdcj_inmates.facilities');
call toolkit.create_index('tdcj_inmates.facilities', false, ARRAY ['name']);
call toolkit.create_index('tdcj_inmates.facilities', true, ARRAY ['name','address','phone']);
