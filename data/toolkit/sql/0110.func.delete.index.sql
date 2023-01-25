create or replace procedure toolkit.delete_index(tbl varchar, cols varchar[]) as
$$
declare
    index_name varchar := format('ndx_%s_%s', replace(tbl, '.', '_'), array_to_string(cols, '_'));
    sql        varchar := format('drop index if exists %s', index_name);
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
 * test the delete_index() function works without errors.
 */
create or replace procedure toolkit.test_delete_index() as
$$
declare
    c          integer := 0;
    tbl_name   varchar := 'test_table';
    cols       varchar[] := ARRAY ['foo'];
    index_name varchar := format('ndx_%s_%s', replace(tbl_name, '.', '_'), array_to_string(cols, '_'));
begin
    execute format('create table %s (%s varchar not null);', tbl_name, array_to_string(cols, '_'));
    call toolkit.create_index(tbl_name, false, cols);
    call toolkit.delete_index(tbl_name, cols);
    c := (select count(*) from pg_indexes where indexname = index_name);
    if c > 0 then
        raise exception 'index failed to delete. count: %', c;
    end if;
    drop procedure toolkit.test_delete_index;
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
        raise notice 'test: delete_index() starting';
        call toolkit.test_delete_index();
        rollback;
    end
$$ language plpgsql;