create or replace procedure create_0531_func_add_inmate_age() as
$$
begin
    create or replace function add_inmate_age(sid integer, new_age integer) RETURNS boolean AS
    $_$
    declare
        min_age integer := (select age
                            from age_tracker
                            where age > 16);
    begin
        if min_age < 16 then
            min_age := 16;
        end if;
        if new_age < min_age then
            raise exception 'inmate age (%) must be >= %', new_age, min_age;
        end if;
        insert into age_tracker(sid, age) values (sid, new_age);
        return true;
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;
