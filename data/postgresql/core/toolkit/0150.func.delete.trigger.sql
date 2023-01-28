/*
 * delete_trigger(table_name, operation, action)
 *   given a table_name, operation and action, delete the associated trigger.
 */
create or replace procedure toolkit.delete_trigger(table_name varchar, operation varchar, action varchar) AS
$$
declare
    action_func  varchar := replace(replace(action, '(', ''), ')', '');
    trigger_name varchar := format('trigger_%s_%s_%s', replace(table_name, '.', '_'), operation,
                                   replace(action_func, '.', '_'));
    sql          varchar := format('drop trigger if exists %s on %s;', trigger_name, table_name);
begin
    raise notice 'deleting trigger %s', trigger_name;
    execute sql;
end
$$ language plpgsql;
