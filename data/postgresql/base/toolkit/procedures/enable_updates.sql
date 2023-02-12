/*
 * enable_updates()
 */
create or replace procedure toolkit.enable_updates(tbl_name varchar) as
$$
begin
    call toolkit.delete_trigger(tbl_name,'update','exception.block_updates');
end
$$ language plpgsql;
