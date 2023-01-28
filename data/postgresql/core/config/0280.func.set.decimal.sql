/*
 * config.set with decimal
 */
create or replace procedure config.set(n varchar, v decimal) as
$$
declare
    textValue text := format('%s', v);
begin
    call config.set(n, textValue);
end
$$ language plpgsql;