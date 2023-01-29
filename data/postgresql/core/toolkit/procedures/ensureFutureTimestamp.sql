/*
 * toolkit.ensureFutureTimestamp()
 *     creates a trigger to enforce that inserted timestamps are in the future.
 */
create or replace procedure toolkit.ensureFutureTimestamp(table_name varchar, column_name varchar) as
$$
declare
    sql varchar := E'create or replace function toolkit.exceptionFutureTimestamps() returns trigger as\n' ||
                   E'$F$\n' ||
                   E'declare\n'||
                   format(E'mt timestamp:=(SELECT max(%s) FROM %s);\n', column_name, table_name) ||
                   E'\tbegin\n' ||
                   format(E'\t\tif NEW.%s < mt then\n', column_name, column_name, table_name) ||
                   format(E'\t\t\traise exception ''timestamp (%s) cannot be backdated'';\n', column_name) ||
                   E'\t\tend if;\n' ||
                   E'return new;\n' ||
                   E'\tend\n' ||
                   E'$F$ language plpgsql\n';
begin
    execute sql;
    call toolkit.create_trigger(table_name, 'insert', 'toolkit.exceptionFutureTimestamps');
end
$$ language plpgsql;