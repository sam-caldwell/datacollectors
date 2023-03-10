/*
 * test the create_enum() function works without errors.
 */
create or replace procedure toolkit.test_create_enum() as
$$
declare
    c       integer   := 0;
    eName   varchar   := 'test_enum';
    eValues varchar[] := ARRAY ['te1','te2','te3'];
begin
    call toolkit.create_enum(eName, eValues);
    c := (select count(*) from pg_catalog.pg_type where typname like eName);
    raise notice 'count: %',c;
    if c <= 0 then
        raise exception 'create_enum() did not create the enum type';
    end if;
    --clean-up
--     drop procedure toolkit.test_create_enum;
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
    if v1 <> format('{%s}',array_to_string(eValues,',')) then
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
        raise notice 'test: toolkit.create_enum() starting';
        call toolkit.test_create_enum();
        rollback;
        call toolkit.test_create_enum_values();
        rollback;
    end
$$ language plpgsql;
