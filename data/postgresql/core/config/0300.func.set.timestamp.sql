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