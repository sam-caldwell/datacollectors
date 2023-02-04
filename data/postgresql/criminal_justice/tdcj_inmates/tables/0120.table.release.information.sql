/*
    identifies any qualitative release data.
 */
create or replace procedure create_0120_table_release_information() as
$$
begin
    create table if not exists release_information
    (
        id      serial       not null primary key,
        sid     integer      not null references roster (sid),
        title   varchar(255) not null,
        body    text         not null,
        created timestamp    not null default now(),
        constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call disable_updates('release_information');
    call create_index('release_information',   false, ARRAY['title']);
    call create_index('release_information',  false, ARRAY[ 'created']);
end
$$ language plpgsql;
