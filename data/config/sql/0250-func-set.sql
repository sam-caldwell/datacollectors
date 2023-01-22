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
    insert into config.data(key, value)
    values (n, textValue)
    on conflict (key)
        do update set value=textValue;
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
    insert into config.data(key, value)
    values (n, textValue)
    on conflict (key)
        do update set value=textValue;
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
    insert into config.data(key, value)
    values (n, textValue)
    on conflict (key)
        do update set value=textValue;
end
$$ language plpgsql;
/*
 * config.set with decimal
 */
create or replace procedure config.set(n varchar, v boolean) as
$$
declare
    textValue text;
begin
    if v then
        textValue='true';
    else
        textValue='false';
    end if;
    insert into config.data(key, value)
    values (n, textValue)
    on conflict (key)
        do update set value=textValue;
end
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
create or replace procedure config.test_set_required() as
$$
declare
    ok boolean;
begin
    raise notice 'test: config.test_set_required() starting';
    begin
        select config.get('testC',true); --get non-existing required param.
        ok=false;                        --expected error didn't happen
    exception when others then
        ok=true;                         --expected error encountered
    end;
    --evaluate test results and throw exception
    if ok then
        raise notice '...passed';
    else
        raise exception '...failed';
    end if;
    --clean-up after test.
    drop procedure config.test_set_required();
end
$$ language plpgsql;
/*
 *
 */
create or replace procedure config.test_set_text() as
$$
begin
    raise notice 'test: config.test_set_text() starting';
    --create test data
    insert into config.data(key, value) values ('test_set_text', 'valueA');
    --test that config.get() works as expected.
    if (select config.get('test_set_text',false)) <> 'valueA' then
        raise exception 'get() test failed (A:false)';
    end if;
    if (select config.get('test_set_text',true)) <> 'valueA' then
        raise exception 'get() test failed (A:true)';
    end if;
    --clean-up after test.
    delete from config.data where key in ('test_set_text');
    drop procedure config.test_set_text();
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
        call config.test_set_required();
    end
$$ language plpgsql;