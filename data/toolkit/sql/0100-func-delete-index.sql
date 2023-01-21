create or replace procedure toolkit.delete_index(tbl varchar, col varchar) AS
$$
declare
    index_name varchar := format('ndx_%s_%s', tbl, col);
    sql        varchar := format('drop index if exists %s', index_name);
begin
    execute sql;
end
$$ language plpgsql;