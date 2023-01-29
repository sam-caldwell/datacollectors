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