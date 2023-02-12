create table if not exists people.identity
(
    id         serial         not null primary key,
    first_name integer        not null references people.first_name (id),
    last_name  integer        not null references people.last_name (id),
    gender     people.Genders not null default 'Unknown',
    races      people.Races   not null default 'U',
    created    timestamp      not null default now()
);

call toolkit.disable_update('people.identity');
call toolkit.create_index('people.identity', true, ARRAY ['first_name','last_name']);
call toolkit.create_index('people.identity', false, ARRAY['gender']);
call toolkit.create_index('people.identity', false, ARRAY['races']);
call toolkit.create_index('people.identity', false, ARRAY ['created']);
