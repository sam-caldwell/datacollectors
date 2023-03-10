/*
 * config.get() -> varchar
 *      return the value for a given key.
 *      throw an exception if required key not found.
 */
create or replace function config.get(name varchar, required boolean) returns varchar as
$$
begin
    if required then
        if (select count(value) from config.data where (key = name) and class = 'clear_text') <= 0 then
            raise exception using
                errcode='MISSING_CONFIG_KEY',
                message=format('missing required configuration %s', name),
                hint='The config.data key may not exist or may have expired.';
        end if;
    end if;
    return (select value from config.data where key = name);
end;
$$ language plpgsql;