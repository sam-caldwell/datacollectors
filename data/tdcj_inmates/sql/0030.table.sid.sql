create or replace procedure create_0030_table_identity() as
$$
begin
    raise notice 'create_0030_table_identity()';
    create table if not exists identity
    (
        sid     integer   not null primary key,
        rawId   integer   not null references stage1_raw (id),
        created timestamp not null default now(),
        constraint positiveSidOnly check (sid > 0),
        constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call disable_updates('identity');
    call create_index('identity', false, ARRAY['rawId']);
    call create_index('identity', false, ARRAY ['created']);
end
$$ language plpgsql;
