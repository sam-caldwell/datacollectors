create or replace procedure toolkit.disable_updates(tbl_name varchar) as
$$
declare
    trigger_name varchar:=format ('trigger_%s',replace(tbl_name,'.','_'));
    sql varchar := format ('create or replace trigger trigger_%s ' ||
        'before update on %s ' ||
        'for each row ' ||
        'execute function toolkit.exception_block_updates();',
        trigger_name, tbl_name);
begin
    execute sql;
end
$$ language plpgsql;
