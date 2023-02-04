/*
 * block_inserts()
 */
create or replace procedure toolkit.block_inserts(table_name varchar) as
$$
begin
    call toolkit.create_trigger(table_name,'insert','exception.block_inserts');
end
$$ language plpgsql;
