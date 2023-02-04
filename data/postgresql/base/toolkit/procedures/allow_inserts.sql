/*
 * allow_inserts()
 */
create or replace procedure toolkit.allow_inserts(tbl_name varchar) as
$$
begin
    call toolkit.delete_trigger(tbl_name,'insert','exception.block_inserts');
end
$$ language plpgsql;
