create or replace procedure create_0001_types_genders() AS
$$
begin
    DO
    $T$
        begin

            call create_type('Genders', ARRAY ['M','F']);
        end
    $T$;
end
$$ language plpgsql;
