create or replace procedure toolkit.create_index(tbl varchar, u boolean, cols varchar[]) as
$$
declare
    index_name varchar := format('ndx_%s_%s', replace(tbl,'.','_'), array_to_string(cols, '_'));
    col        varchar := array_to_string(cols, ',');
    unq        varchar := case when u then 'unique' else '' end;
    sql        varchar := format('create %s index if not exists %s on %s (%s)', unq, index_name, tbl, col);
begin
    execute sql;
end
$$ language plpgsql;