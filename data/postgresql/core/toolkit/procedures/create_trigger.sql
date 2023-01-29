create or replace procedure toolkit.create_trigger(table_name varchar, operation varchar, action varchar) AS
$$
declare
    action_func  varchar := replace(replace(action, '(', ''), ')', '');
    trigger_name varchar := format('trigger_%s_%s_%s', replace(table_name, '.', '_'), operation,
                                   replace(action_func, '.', '_'));
    sql          varchar := format('create or replace trigger %s before %s on %s for each row execute function %s()',
                                   trigger_name, operation, table_name, action_func);
begin
    if (select count(*) where upper(operation) in ('INSERT', 'UPDATE', 'DELETE')) then
        execute sql;
    else
        raise exception using
            errcode = 'INVALID_INPUT',
            message = format('toolkit.create_trigger() only supports INSERT, UPDATE, DELETE operations. got: %s',operation),
            hint = 'Check the operation value passed as input to toolkit.create_trigger()';
    end if;
end
$$ language plpgsql;
