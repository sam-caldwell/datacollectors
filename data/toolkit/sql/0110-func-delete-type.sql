create or replace procedure toolkit.delete_type(name varchar) as
$$
declare
    sql varchar := format('drop type %s', name);
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
 * test the create_sequence() function works without errors.
 */
create or replace procedure toolkit.test_delete_type() as
$$
declare
    c             integer := 0;
begin
    call toolkit.create_enum('test_enum', ARRAY ['a','b','c']);
    call toolkit.delete_type('test_enum');
    c := (select count(*) from pg_catalog.pg_type where typname like 'test_enum');
    if c > 0 then
        raise exception 'test_delete_sequence() failed.';
    end if;
    -- clean-up
    drop procedure toolkit.test_delete_type;
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
        raise notice 'test: toolkit.delete_sequence() starting';
        call toolkit.test_delete_type();
        rollback;
    end
$$ language plpgsql;

