/*
    Races:
        A - Asian or Pacific Islander
        B - Black
        H - Hispanic
        I - American Indian
        U - Unknown
        W - White
 */
create or replace procedure create_0001_types_races() AS
$$
begin
    call create_type('Races',ARRAY['A','B','H','I','U','W']);
end
$$ language plpgsql;
