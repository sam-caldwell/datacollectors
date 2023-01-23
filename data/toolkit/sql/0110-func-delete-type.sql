create or replace procedure toolkit.delete_type(name varchar) as
$$
declare
    sql varchar:=format('drop type %s', name);
begin
    execute sql;
end
$$ language plpgsql;
