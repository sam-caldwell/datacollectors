create or replace procedure toolkit.delete_sequence(o varchar) as
$$
declare
    sql varchar := format('drop sequence if exists %s;', o);
begin
    execute sql;
end
$$ language plpgsql;
