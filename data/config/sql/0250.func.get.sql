/*
 * config.get() -> varchar
 *      return the value for a given key.
 *      throw an exception if required key not found.
 */
create or replace function config.get(name varchar, required boolean) returns varchar as
$$
begin
    if required then
        if (select count(value) from config.data where key = name) <= 0 then
            raise exception 'missing required configuration %', name;
        end if;
    end if;
    return (select value from config.data where key = name);
end;
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
create or replace procedure config.test_get_required() as
$$
declare
    ok boolean;
begin
    raise notice 'test: config.test_get_required() starting';
    begin
        --get non-existing required param.
        select config.get('test_get_required', true);
        ok = false; --expected error didn't happen
    exception
        when others then
            ok = true; --expected error encountered
    end;
    --evaluate test results and throw exception
    if ok then
        raise notice '...passed';
    else
        raise exception '...failed';
    end if;
    --clean-up after test.
    drop procedure config.test_get_required();
end
$$ language plpgsql;
/*
 * We expect that text stored should be retrieved
 */
create or replace procedure config.test_get_text() as
$$
begin
    raise notice 'test: config.test_get_text() starting';
    --create test data
    insert into config.data(key, value) values ('test_get_text', 'valueA');
    --test that config.get() works as expected.
    if (select config.get('test_get_text', false)) <> 'valueA' then
        raise exception 'get() test failed (A:false)';
    end if;
    if (select config.get('test_get_text', true)) <> 'valueA' then
        raise exception 'get() test failed (A:true)';
    end if;
    --clean-up after test.
    delete from config.data where key in ('test_get_text');
    drop procedure config.test_get_text();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_get_timestamp() as
$$
declare
    v timestamp:=now();
    expected varchar = format('%s',v);
begin
    raise notice 'test: config.test_get_timestamp() starting';
    --create test data
    insert into config.data(key, value) values ('test_get_timestamp',expected);
    --test that config.get() works as expected.
    if (select config.get('test_get_timestamp',false))<>expected then
        raise exception 'get() failed to get time value';
    end if;
    --clean-up after test.
    delete from config.data where key in ('test_get_timestamp');
    drop procedure config.test_get_timestamp();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_get_integer() as
$$
declare
    v integer:=1048576;
    expected varchar = format('%s',v);
begin
    raise notice 'test: config.test_get_integer() starting';
    --create test data
    insert into config.data(key, value) values ('test_get_integer', format('%s',v));
    --test that config.get() works as expected.
    if (select config.get('test_get_integer',false))<>expected then
        raise exception 'get() failed to set integer value';
    end if;
    --clean-up after test.
    delete from config.data where key in ('test_get_integer');
    drop procedure config.test_get_integer();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_get_decimal() as
$$
declare
    v integer:=3.141529;
    expected varchar = format('%s',v);
begin
    raise notice 'test: config.test_get_decimal() starting';
    --create test data
    insert into config.data(key, value) values ('test_get_decimal', format('%s',v));
    --test that config.get() works as expected.
    if (select config.get('test_get_decimal',false))<>expected then
        raise exception 'get() failed to set decimal value';
    end if;
    --clean-up after test.
    delete from config.data where key in ('test_get_decimal');
    drop procedure config.test_get_decimal();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_get_boolean_true() as
$$
declare
    v boolean = true;
    expected varchar = format('%s',v);
begin
    raise notice 'test: config.test_get_boolean_true() starting';
    --create test data
    insert into config.data(key, value) values ('test_get_boolean_true', format('%s',v));
    --test that config.get() works as expected.
    if (select config.get('test_get_boolean_true',false))<>expected then
        raise exception 'get() failed to set boolean value (true)';
    end if;
    --clean-up after test.
    delete from config.data where key in ('test_get_boolean_true');
    drop procedure config.test_get_boolean_true();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_get_boolean_false() as
$$
declare
    v boolean = false;
    expected varchar = format('%s',v);
begin
    raise notice 'test: config.test_get_boolean_false() starting';
    --create test data
    insert into config.data(key, value) values ('test_get_boolean_false', format('%s',v));
    --test that config.get() works as expected.
    if (select config.get('test_get_boolean_false',false))<>expected then
        raise exception 'get() failed to set boolean value (false)';
    end if;
    --clean-up after test.
    delete from config.data where key in ('test_get_boolean_false');
    drop procedure config.test_get_boolean_false();
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
        call config.test_get_required();
        rollback;
        call config.test_get_text();
        rollback;
        call config.test_get_timestamp();
        rollback;
        call config.test_get_integer();
        rollback;
        call config.test_get_decimal();
        rollback;
        call config.test_get_boolean_true();
        rollback;
        call config.test_get_boolean_false();
        rollback;
    end
$$ language plpgsql;