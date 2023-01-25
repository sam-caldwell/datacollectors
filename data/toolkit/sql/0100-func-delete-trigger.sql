/*
 * delete_trigger(table_name, operation, action)
 *   given a table_name, operation and action, delete the associated trigger.
 */
create or replace procedure toolkit.delete_trigger(table_name varchar, operation varchar, action varchar) AS
$$
declare
    action_func  varchar := replace(replace(action, '(', ''), ')', '');
    trigger_name varchar := format('trigger_%s_%s_%s', replace(table_name, '.', '_'), operation,
                                   replace(action_func, '.', '_'));
    sql          varchar := format('drop trigger %s on %s;', trigger_name, table_name);
begin
    raise notice 'deleting trigger %s', trigger_name;
    execute sql;
end
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
/*
 * test the delete_trigger() function works without errors.
 */
create or replace procedure toolkit.test_create_trigger() as
$$
declare
    c           integer := 0;
    tbl_name    varchar := 'test_table';
    op          varchar := 'insert';
    action_func varchar := 'noop_func';
    tgr_name    varchar := format('trigger_%s_%s_%s', replace(tbl_name, '.', '_'), op, 'noop_func');

begin
    create table if not exists test_table
    (
        a varchar not null
    );
    create or replace function noop_func() returns trigger as
    $F$
    begin
        return new;
    end
    $F$ language plpgsql;

    call toolkit.create_trigger(tbl_name, op, action_func);
    call toolkit.delete_trigger(tbl_name, op, action_func);
    c := (select count(*) from information_schema.triggers where trigger_name = tgr_name);
    raise notice 'count: %',c;
    if c <> 0 then
        raise exception 'delete_trigger() did not delete the trigger';
    end if;
    --clean-up
    drop table if exists test_table;
    drop procedure toolkit.test_create_trigger;
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
        raise notice 'test: test_create_trigger() starting';
        call toolkit.test_create_trigger();
        rollback;
    end
$$ language plpgsql;
