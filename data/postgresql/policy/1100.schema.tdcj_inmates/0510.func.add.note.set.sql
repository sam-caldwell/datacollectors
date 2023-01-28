
create or replace function add_note_set() RETURNS uuid AS
$$
declare
    new_id uuid := uuid_generate_v4();
begin
    insert into note_set(id) values (new_id);
    return new_id;
end
$$ LANGUAGE plpgsql;