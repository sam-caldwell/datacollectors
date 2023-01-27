create or replace procedure toolkit.block_inserts(tbl_name varchar) as
$$
begin
    call toolkit.create_trigger(tbl_name,'insert','toolkit.exception_block_inserts');
end
$$ language plpgsql;
