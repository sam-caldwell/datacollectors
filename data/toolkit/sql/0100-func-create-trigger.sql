/*
 * create_trigger(table_name, operation, action)
 *   given a table name and a database operation (update, insert, delete) execute the action function.
 */
create or replace procedure toolkit.create_trigger(table_name varchar, operation varchar, action varchar) AS
$$
declare
    action_func varchar := replace(replace(action, '(', ''), ')', '');
    trigger_name varchar := format('trigger_%s_%s_%s', replace(table_name, '.', '_'), operation,
                                  replace(action_func, '.', '_'));
    sql         varchar := format('create or replace trigger %s before %s on %s for each row execute function %s()',
                                  trigger_name, operation, table_name, action_func);
begin
    raise notice 'creating trigger %s', trigger_name;
    execute sql;
end
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
/*
 * test the create_trigger() function works without errors.
 */
create or replace procedure toolkit.test_create_trigger() as
$$
declare
    c        integer := 0;
    tbl_name varchar := 'test_table';
    op       varchar := 'insert';
    action_func varchar:='noop_func';
    tgr_name varchar := format('trigger_%s_%s_%s', replace(tbl_name, '.', '_'), op,'noop_func');

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
    c := (select count(*) from information_schema.triggers where trigger_name = tgr_name);
    raise notice 'count: %',c;
    if c <= 0 then
        raise exception 'create_trigger() did not create the trigger';
    end if;
    --clean-up
    drop procedure toolkit.test_create_trigger;
end
$$ language plpgsql;
/*
 * verify the enum has expected elements
 */
create or replace procedure toolkit.test_create_enum_values() as
$$
declare
    v1      text      := '';
    eName   varchar   := 'test_enum';
    eValues varchar[] := ARRAY ['te1','te2','te3','te4'];
begin
    call toolkit.create_enum(eName, eValues);
    execute format('select enum_range(NULL::%s);', eName) into v1;
    if v1 <> format('{%s}', array_to_string(eValues, ',')) then
        raise exception 'error: enum values do not match specification: %', v1;
    end if;
    --clean-up
    drop procedure toolkit.test_create_enum_values;
end;
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
