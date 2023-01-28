/*
    Given a string containing a race identifier
        sanitize the input to ensure the value is a recognized value
            then convert to the Races enumerated type
                return the outcome.
 */
create or replace procedure create_0530_func_lookup_race() as
$$
begin
    create or replace function lookup_race(race_string varchar(255)) RETURNS Races AS
    $_$
    declare
        r_string varchar(255) := upper(race_string);
    begin
        if r_string == 'ASIAN OR PACIFIC ISLANDER' then
            return 'A';
        elseif r_string == 'BLACK' then
            return 'B';
        elseif r_string == 'HISPANIC' then
            return 'H';
        elseif r_string == 'AMERICAN INDIANS' then
            return 'I';
        elseif r_string == 'UNKNOWN' then
            return 'U';
        elseif r_string == 'WHITE' then
            return 'W';
        else
            raise exception 'Invalid race string encountered: %', race_string;
        end if;
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;
