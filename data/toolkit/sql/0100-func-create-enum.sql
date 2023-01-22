create or replace procedure toolkit.create_enum(name text, elements text[]) as
$$
declare
--     e1 varchar[]:=ARRAY[(select concat('''',n,'''') from unnest(elements) as n)];
    e2  varchar := '''' || array_to_string(elements, ''',''') || '''';
    sql varchar := format('create type %s as enum (%s);', name, e2);
begin
    if (select 1 from pg_type where typname = name) then
        raise notice 'type: %...exists', name;
    else
        raise notice 'type: create %', name;
        execute sql;
        raise notice 'type: % created', name;
    end if;
end
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
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
    drop procedure toolkit.test_create_enum;
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
        raise notice 'test: toolkit.create_enum() starting';
        call toolkit.test_create_enum();
--         call toolkit.test_create_enum_values();
    end
$$ language plpgsql;

