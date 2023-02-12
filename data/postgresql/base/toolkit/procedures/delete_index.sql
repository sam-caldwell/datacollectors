/*
 * delete_index()
 */
create or replace procedure toolkit.delete_index(tbl varchar, cols varchar[]) as
$$
declare
    index_name varchar := format('ndx_%s_%s', replace(tbl, '.', '_'), array_to_string(cols, '_'));
    sql        varchar := format('drop index if exists %s', index_name);
begin
    execute sql;
end
$$ language plpgsql;
