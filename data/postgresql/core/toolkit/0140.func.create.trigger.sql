/*
 * create_trigger(table_name, operation, action)
 *   given a table name and a database operation (update, insert, delete) execute the action function.
 */
create or replace procedure toolkit.create_trigger(table_name varchar, operation varchar, action varchar) AS
$$
declare
    action_func varchar := replace(replace(action, '(', ''), ')', '');
    trigger_name varchar := format('trigger_%s_%s_%s', replace(table_name, '.', '_'), operation,
                                  replace(action_func, '.', '_'));
    sql         varchar := format('create or replace trigger %s before %s on %s for each row execute function %s()',
                                  trigger_name, operation, table_name, action_func);
begin
    raise notice 'creating trigger %s', trigger_name;
    execute sql;
end
$$ language plpgsql;
