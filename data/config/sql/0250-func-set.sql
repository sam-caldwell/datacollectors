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