/*
    Given a string containing a last_name,
        lookup the last_name numeric identifier and return the same.
            if last_name does not exist, insert it.
 */
create or replace procedure create_0530_func_lookup_last_name() as
$$
begin
    create or replace function lookup_last_name(input_string varchar(255)) RETURNS Genders AS
    $_$
    declare
        result integer := -1;
    begin
        select id into result from first_names where last_name = input_string;
        if result == -1 then
            insert into last_names (last_name) values (upper(input_string));
            select currval('first_names_id_seq') into result;
        end if;
        return result;
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;
