create table if not exists people.date
(
    month   integer   not null,
    year    integer   not null,
    day     integer   not null,
    type    date_type not null,
    created timestamp not null default now(),
    constraint valid_month check ((month > 0) and (month < 13)),
    constraint valid_year check ((month > 0) and (month < 9999))
);
call toolkit.disable_updates('identity');
call toolkit.create_index('identity', false, ARRAY ['rawId']);
call toolkit.create_index('identity', false, ARRAY ['created']);
