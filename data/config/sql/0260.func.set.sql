/*
 * config.set() will set a given key-value pair on the config table.
 */
create or replace procedure config.set(n varchar, v text) as
$$
begin
    insert into config.data(key, value, updated)
    values (n, v, now())
    on conflict (key)
        do update
        set value=v,
            updated=now();
end
$$ language plpgsql;
/*
 * config.set() with timestamp
 */
create or replace procedure config.set(n varchar, v timestamp) as
$$
declare
    textValue text := format('%s', v);
begin
    call config.set(n, textValue);
end
$$ language plpgsql;
/*
 * config.set with integer
 */
create or replace procedure config.set(n varchar, v integer) as
$$
declare
    textValue text := format('%s', v);
begin
    call config.set(n, textValue);
end
$$ language plpgsql;
/*
 * config.set with decimal
 */
create or replace procedure config.set(n varchar, v decimal) as
$$
declare
    textValue text := format('%s', v);
begin
    call config.set(n, textValue);
end
$$ language plpgsql;
/*
 * config.set with decimal
 */
create or replace procedure config.set(n varchar, v boolean) as
$$
declare
    textValue text := format('%s', v);
begin
    call config.set(n, textValue);
end
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
/*
 * test that we can set a value to the configuration table.
 */
create or replace procedure config.test_set_text() as
$$
declare
    n varchar := 'config.test_set_text';
    v varchar := 'config.test_set_text_value';
begin
    raise notice 'test: % starting', n;
    --use .set() method
    call config.set(n, v);
    --verify the table has the expected data.
    if (select config.get(n, false)) <> v then
        raise exception 'set() test failed on %',n;
    end if;
    --clean-up after test.
    delete from config.data where key in (n);
    drop procedure config.test_set_text();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_set_timestamp() as
$$
declare
    n varchar   := 'config.test_set_timestamp';
    v timestamp := now();
begin
    raise notice 'test: % starting', n;
    --use .set() method
    call config.set(n, v);
    --verify the table has the expected data.
    if (select config.get(n, false))::timestamp <> v then
        raise exception 'set() test failed on %',n;
    end if;
    --clean-up after test.
    delete from config.data where key in (n);
    drop procedure config.test_set_timestamp();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_set_integer() as
$$
declare
    n varchar := 'config.test_set_integer';
    v integer := 1048576;
begin
    raise notice 'test: % starting', n;
    --use .set() method
    call config.set(n, v);
--verify the table has the expected data.
    if (select config.get(n, false))::integer <> v then
        raise exception 'set() test failed on %',n;
    end if;
--clean-up after test.
    delete from config.data where key in (n);
    drop procedure config.test_set_integer();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_set_decimal() as
$$
declare
    n varchar := 'config.test_set_decimal';
    v decimal := 3.141529;
begin
    raise notice 'test: % starting', n;
    --use .set() method
    call config.set(n, v);
    --verify the table has the expected data.
    if (select config.get(n, false))::decimal <> v then
        raise exception 'set() test failed on %',n;
    end if;
    --clean-up after test.
    delete from config.data where key in (n);
    drop procedure config.test_set_decimal();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_set_boolean_true() as
$$
declare
    n varchar := 'config.test_set_boolean_true';
    v boolean := true;
begin
    raise notice 'test: % starting', n;
    --use .set() method
    call config.set(n, v);
    --verify the table has the expected data.
    if not ((select config.get(n, false))::boolean) then
        raise exception 'set() test failed on %',n;
    end if;
    --clean-up after test.
    delete from config.data where key in (n);
    drop procedure config.test_set_boolean_true();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_set_boolean_false() as
$$
declare
    n varchar := 'config.test_set_boolean_false';
    v boolean := false;
    f boolean;
begin
    raise notice 'test: % starting', n;
    --use .set() method
    call config.set(n, v);
--verify the table has the expected data.
    f = (select config.get(n, false))::boolean;
    call toolkit.assert(not (f), 'set() test failed');
--clean-up after test.
    delete from config.data where key in (n);
    drop procedure config.test_set_boolean_false();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_set_update() as
$$
declare
    n varchar := 'config.test_set_text';
    v1 varchar := 'config.test_set_text_value1';
    v2 varchar := 'config.test_set_text_value2';
    v3 varchar := 'config.test_set_text_value3';
    c1 timestamp;
    c2 timestamp;
    u1 timestamp;
    u2 timestamp;
begin
    raise notice 'test: % starting', n;
    --use .set() method
    call config.set(n, v1);
    c1 = (select created from config.data where key=n limit 1);
    u1 = (select updated from config.data where key=n limit 1);
    --verify the table has the expected data.
    if (select config.get(n, false)) <> v1 then
        raise exception 'set() test failed on %',n;
    end if;
    if c1 is null then
        raise exception 'set()[insert] did not set created time';
    end if;
    if c1 < now() then
        raise exception 'set()[insert] set created in the past';
    end if;
    if u1 is null then
        raise exception 'set()[insert] altered updated.  expected time but got null';
    end if;

    call config.set(n,v2);
    c2 = (select created from config.data where key=n limit 1);
    u2 = (select updated from config.data where key=n limit 1);
    --verify the table has the expected data.
    if (select config.get(n, false)) <> v2 then
        raise exception 'set() test failed on %',n;
    end if;
    if c2 is null then
        raise exception 'set()[update] did not set created time';
    end if;
    if c2 <> c1 then
        raise exception 'set()[update] altered created time';
    end if;
    if u2 is null then
        raise exception 'set()[update] failed to update the updated time';
    end if;
    if u2 < u1 then
        raise exception 'set()[update] updated timestamp earlier than last update.';
    end if;

    call config.set(n,v3);
    c2 = (select created from config.data where key=n limit 1);
    u2 = (select updated from config.data where key=n limit 1);
    --verify the table has the expected data.
    if (select config.get(n, false)) <> v3 then
        raise exception 'set() test failed on %',n;
    end if;
    if c2 is null then
        raise exception 'set()[update] did not set created time';
    end if;
    if c2 <> c1 then
        raise exception 'set()[update] altered created time';
    end if;
    if u2 is null then
        raise exception 'set()[update] failed to update the updated time';
    end if;
    if u2 < u1 then
        raise exception 'set()[update] updated timestamp earlier than last update.';
    end if;

    --clean-up after test.
    delete from config.data where key in (n);
    drop procedure config.test_set_update();
end
$$ language plpgsql;/*
 *  ------------------------------------------------------------------------------
 *  Running tests
 *     All unit tests should be above this section
 *  ------------------------------------------------------------------------------
 */
do
$$
    begin
        raise notice 'test: config.get() starting';
        call config.test_set_text();
        rollback;
        call config.test_set_timestamp();
        rollback;
        call config.test_set_integer();
        rollback;
        call config.test_set_decimal();
        rollback;
        call config.test_set_boolean_true();
        rollback;
        call config.test_set_boolean_false();
        rollback;
        call config.test_set_update();
        rollback;
    end
$$ language plpgsql;
