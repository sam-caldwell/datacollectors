/*
    Identifies the current facility where the inmate is located
    within the set of known facilities.
 */
create or replace procedure create_0110_table_current_facility() as
$$
begin
    create table if not exists current_facility
    (
        id         serial    not null primary key,
        sid        integer   not null references roster (sid),
        facilityId integer   not null references facilities (id),
        created    timestamp not null default now(),
        constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call create_index('current_facility',true, ARRAY['facilityId','sid']);
end
$$ language plpgsql;
