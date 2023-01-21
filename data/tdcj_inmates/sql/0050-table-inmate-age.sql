/*
    Age-tracking table.  Used to eventually determine
    date of birth from the table's updates over time.
 */
create or replace procedure create_0050_table_inmate_age() AS
$$
begin
    create table if not exists inmate_age
    (
        id      serial    not null primary key,
        sid     integer   not null references roster (sid),
        age     integer   not null,
        created timestamp not null default now()
            constraint ageIsAdultOrNull check (age >= 16),
        constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call create_index('inmate_age',   false, ARRAY['age']);
    call create_index('inmate_age',  false, ARRAY[ 'created']);
    call disable_updates('inmate_age');
/*
    toDo: add an update trigger which will ensure age always increases.
 */
end
$$ language plpgsql;