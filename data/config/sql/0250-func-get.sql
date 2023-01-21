/*
 * config.get()
 *      return the value for a given key.
 *      throw an exception if required key not found.
 */
create or replace function config.get(name varchar, required boolean) returns varchar as
$$
begin
    if required then
        if (select count(value) from config.data where key=name) <=0 then
            raise exception 'missing required configuration %', name;
        end if;
    end if;
    return (select value from config.data where key = name);
end;
$$ language plpgsql;
