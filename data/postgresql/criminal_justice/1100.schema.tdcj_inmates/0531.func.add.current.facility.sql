create or replace procedure create_0531_func_add_current_facility() as
$$
begin
    create or replace function add_current_facility(s integer, f integer) RETURNS boolean AS
    $_$
    begin
        insert into current_facility(sid, facilityId) values (s, f);
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;