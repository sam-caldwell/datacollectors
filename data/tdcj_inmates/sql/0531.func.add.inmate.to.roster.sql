create or replace procedure create_0531_func_add_inmate_to_roster() as
$$
begin
    create or replace function add_inmate_to_roster(sid integer, last_name varchar(255), first_name varchar(255),
                                                    gender varchar(255), race varchar(255)) RETURNS boolean AS
    $_$
    begin
        insert into roster(sid, first_name, last_name, gender, race)
        values (sid, -- Should throw exception if we change it.
                lookup_first_name(first_name), --lookup/upsert firstname and return numeric value.
                lookup_last_name(last_name), --lookup/upsert firstname and return numeric value.
                lookup_gender(gender), --sanitize gender
                lookup_race(race)); --sanitize race
        return true;
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;
