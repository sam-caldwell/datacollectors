create or replace procedure create_0531_func_add_release_information() as
$$
begin
    create or replace function add_release_information(s integer, t varchar(255), b text) RETURNS boolean AS
    $_$
    begin
        insert into release_information(sid, title, body) values (s, t, b);
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;
