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
    if (select count(*) where upper(operation) in ('INSERT', 'UPDATE', 'DELETE')) then
        execute sql;
    else
        raise exception using
            errcode = 'INVALID_INPUT',
            message = format('toolkit.delete_trigger() only supports INSERT, UPDATE, DELETE operations. got: %s',
                             operation),
            hint = 'Check the operation value passed as input to toolkit.delete_trigger()';
    end if;
end
$$ language plpgsql;
