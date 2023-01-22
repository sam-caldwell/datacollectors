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
