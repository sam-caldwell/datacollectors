/*
 * disable_updates()
 */
create or replace procedure toolkit.disable_updates(tbl_name varchar) as
$$
begin
    call toolkit.create_trigger(tbl_name,'update','exception.block_updates');
end
$$ language plpgsql;
