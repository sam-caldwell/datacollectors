create or replace procedure toolkit.enable_updates(tbl_name varchar) as
$$
declare
    trigger_name varchar:=format ('trigger_%s',replace(tbl_name,'.','_'));
    sql varchar:=format('drop trigger if exists %s on %s',trigger_name,tbl_name);
begin
    execute sql;
end
$$ language plpgsql;
