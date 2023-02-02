/**
  Index inmate to all corresponding assigned tdcjId numbers
  assigned on or after data collections start.  It is unlikely
  we can capture historical data.
 */
create or replace procedure create_0045_table_tdcj_id_numbers() AS
$$
begin
    raise notice 'create_0045_table_tdcj_id_numbers()';
    create table if not exists tdcj_id_numbers
    (
        sid     integer   not null primary key references roster (sid),
        tdcj_id integer   not null unique,
        created timestamp not null default now(),
        constraint createdAfterProjectStart check (created > '01-01-2023'),
        constraint tdcjIdNumberOver10k check (tdcj_id > 10000)
    );
    call create_index('tdcj_id_numbers',   false, ARRAY['created']);
end
$$ language plpgsql;