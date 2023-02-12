/*
    Given a string (e.g. male, female, etc)--
        sanitize the input to ensure the value is either male or female
            then convert to M or F (using Genders enum type)
                return M or F.
 */
create or replace procedure create_0530_lookup_gender() as
$$
begin
    create or replace function lookup_gender(gender_string varchar(255)) RETURNS Genders AS
    $_$
    declare
        g_string char(1) = upper(substr(gender_string, 0, 1));
    begin

        if g_string == 'M' then
            return 'M';
        elseif g_string == 'F' then
            return 'F';
        else
            raise exception 'invalid gender %', gender_string;
        end if;
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;
