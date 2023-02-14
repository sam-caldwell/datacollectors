create or replace procedure create_0531_func_add_release_dates() as
$$
begin
    create or replace function add_release_dates(sid integer, dtype ReleaseDateTypes, d timestamp) RETURNS boolean AS
    $_$
    begin
        insert into release_dates (sid, dateType, date) values (sid, dtype, d);
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;