create or replace procedure toolkit.allow_inserts(tbl_name varchar) as
$$
begin
    call toolkit.delete_trigger(tbl_name,'insert','toolkit.exception_block_inserts');
end
$$ language plpgsql;
