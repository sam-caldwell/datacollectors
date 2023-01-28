/*
    Given a string containing a first_name,
        lookup the first_name numeric identifier and return the same.
            if first_name does not exist, insert it.
 */
create or replace procedure create_0530_func_lookup_first_name() as
$$
begin
    create or replace function lookup_first_name(input_string varchar(255)) RETURNS Genders AS
    $T$
    declare
        result integer := -1;
    begin
        select id into result from first_names where first_name = input_string;
        if result == -1 then
            insert into first_names (first_name) values (upper(input_string));
            select currval('last_names_id_seq') into result;
        end if;
        return result;
    end
    $T$ LANGUAGE plpgsql;
end
$$ language plpgsql;
