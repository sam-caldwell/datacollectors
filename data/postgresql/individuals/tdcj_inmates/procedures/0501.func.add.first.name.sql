create or replace procedure create_0501_add_first_name() as
$$
begin
    create or replace function add_first_name(name varchar) RETURNS boolean AS
    $T$
    begin
        insert into first_names(first_name) values (name);
        return true;
    end
    $T$ LANGUAGE plpgsql;
end
$$ language plpgsql;
