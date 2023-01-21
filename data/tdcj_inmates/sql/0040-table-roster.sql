/**
        The master table for identifying an inmate within TDCJ.
        This provides the high-level demographics.
 */
create or replace procedure create_0040_table_roster() AS
$$
begin
    raise notice 'create_0040_table_roster()';
    create table if not exists roster
    (
        sid        integer   not null primary key references identity(sid),
        last_name  integer   not null references last_names (id),
        first_name integer   not null references first_names (id),
        gender     Genders   not null,
        race       Races     not null,
        collection uuid      null     default null references note_set (id),
        created    timestamp not null default now(),
        constraint positiveSidOnly check (sid > 0),
        constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call disable_updates('roster');
    call create_index('roster', false, ARRAY ['last_name']);
    call create_index('roster', false, ARRAY ['first_name']);
    call create_index('roster', false, ARRAY ['gender']);
    call create_index('roster', false, ARRAY ['race']);
    call create_index('roster', false, ARRAY ['created']);
end
$$ LANGUAGE plpgsql;