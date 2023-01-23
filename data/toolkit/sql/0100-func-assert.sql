/*
 * toolkit.assert(condition, exception_string);
 *   If an assertion is made and the condition is false,
 *   and exception will be thrown using the exception_string
 */
create or replace procedure toolkit.assert(condition boolean, exception_string varchar) as
$$
    begin
        if not condition then
            raise exception '%', exception_string;
        end if;
    end
$$ language plpgsql;