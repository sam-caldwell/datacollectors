/*
    identifies the facilities where an inmate could be located.
 */
create or replace procedure create_0020_table_facilities() AS
$$
begin
    raise notice 'create_0020_table_facilities()';
    create table if not exists facilities
    (
        id         serial        not null primary key,
        name       varchar(1024) not null,
        address    varchar(2048) null     default null,
        phone      varchar(255)  null     default null,
        note_setId uuid          null     default null references note_set (id),
        created    timestamp     not null default now()
            constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call create_index('facilities',  false, ARRAY['name']);
    call create_index('facilities', true, ARRAY['name','address','phone']);
end
$$ language plpgsql;