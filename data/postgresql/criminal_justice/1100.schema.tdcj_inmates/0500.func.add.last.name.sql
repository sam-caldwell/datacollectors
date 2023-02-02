create or replace procedure create_0500_add_last_name() as
$$
begin
    create or replace function add_last_name(name varchar) RETURNS boolean AS
    $T$
    begin
        insert into last_names(last_name) values (name);
        return true;
    end
    $T$ LANGUAGE plpgsql;
end
$$ language plpgsql;
