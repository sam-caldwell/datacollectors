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