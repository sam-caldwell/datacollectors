/*
 * config.set() will set a given key-value pair on the config table.
 */
create or replace procedure config.set(n varchar, v text) as
$$
begin
    insert into config.data(key, value)
    values (n, v)
    on conflict (key)
        do update set value=v;
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
begin
    raise notice 'test: % starting', n;
    --use .set() method
    call config.set(n, v);
--verify the table has the expected data.
    if (select config.get(n, false))::boolean then
        raise exception 'set() test failed on %',n;
    end if;
--clean-up after test.
    delete from config.data where key in (n);
    drop procedure config.test_set_boolean_false();
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
        raise notice 'test: config.get() starting';
        call config.test_set_text();
        call config.test_set_timestamp();
        call config.test_set_integer();
        call config.test_set_decimal();
        call config.test_set_boolean_true();
        call config.test_set_boolean_false();
    end
$$ language plpgsql;
