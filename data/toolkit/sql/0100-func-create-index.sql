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
    result text:='';
    tableName   varchar   := 'test_table';
    columns varchar[] := ARRAY ['foo'];
    index_name varchar := format('ndx_%s_%s', replace(tableName,'.','_'), array_to_string(columns, '_'));
begin
    create table test_table(
        foo text not null
    );
    call toolkit.create_index(tableName, false, columns);
    result=(select indexdef from pg_catalog.pg_indexes where indexname=index_name);
    if result <> 'CREATE INDEX ndx_test_table_foo ON public.test_table USING btree (foo)' then
        raise exception 'index not structured as expected: ''%''', result;
    end if;
    --clean-up
    execute format('drop index %s', index_name);
    drop table test_table;
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
    end
$$ language plpgsql;
