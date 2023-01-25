/*
 * create_index()
 *    for a given table (tbl) this function will create an index on the specified columns (cols)
 *    and if the uniqueness flag (u) is enabled, this will create a unique index.
 */
create or replace procedure toolkit.create_index(tbl varchar, u boolean, cols varchar[]) as
$$
declare
    index_name varchar := format('ndx_%s_%s', replace(tbl, '.', '_'), array_to_string(cols, '_'));
    col        varchar := array_to_string(cols, ',');
    unq        varchar := case when u then 'unique' else '' end;
    sql        varchar := format('create %s index if not exists %s on %s (%s)', unq, index_name, tbl, col);
begin
    execute sql;
end
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
/*
 * test the test_create_index() function works without errors.
 */
create or replace procedure toolkit.test_create_index() as
$$
declare
    result     text      := '';
    tbl_name   varchar   := 'test_table';
    cols       varchar[] := ARRAY ['foo'];
    index_name varchar   := format('ndx_%s_%s', replace(tbl_name, '.', '_'), array_to_string(cols, '_'));
begin
    execute format('create table %s (%s varchar not null);', tbl_name, array_to_string(cols, '_'));
    call toolkit.create_index(tbl_name, false, cols);
    result = (select indexdef from pg_catalog.pg_indexes where indexname = index_name);
    if result <> 'CREATE INDEX ndx_test_table_foo ON public.test_table USING btree (foo)' then
        raise exception 'index not structured as expected: ''%''', result;
    end if;
    --clean-up
    drop procedure toolkit.test_create_index;
end
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Running tests
 *     All unit tests should be above this section
 *  ------------------------------------------------------------------------------
 */
do
$$
    begin
        raise notice 'test: toolkit.create_index() starting';
        call toolkit.test_create_index();
        rollback;
    end
$$ language plpgsql;
