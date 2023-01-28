/*
 * config.set with boolean
 */
create or replace procedure config.set(n varchar, v boolean) as
$$
declare
    textValue text := format('%s', v);
begin
    call config.set(n, textValue);
end
$$ language plpgsql;