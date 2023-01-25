/*
 * toolkit.ensureFutureTimestamp()
 *     creates a trigger to enforce that inserted timestamps are in the future.
 */
create or replace procedure toolkit.ensureFutureTimestamp(table_name varchar, column_name varchar) as
$$
declare
    sql varchar := E'create or replace function toolkit.exceptionFutureTimestamps() returns trigger as\n' ||
                   E'$F$\n' ||
                   E'\tbegin\n' ||
                   format(E'\t\tif NEW.%s > (SELECT max(%s) FROM %s) then\n', column_name, column_name, table_name) ||
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
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
create or replace procedure toolkit.test1() as
$$
begin
    create table test_table
    (
        t timestamp not null default now()
    );
    call toolkit.ensureFutureTimestamp('test_table', 't');
    insert into test_table (t) values (now()), (now()), (now()), (now());
    drop procedure toolkit.test1();
end
$$ language plpgsql;
/*
 */
create or replace procedure toolkit.test2() as
$$
declare
    t0 timestamp;
    t1 timestamp;
    t2 timestamp;
begin
    t0 := now();
    perform pg_sleep(1);
    t1 := t0 - interval '1:25';
    perform pg_sleep(1);
    t2 := t1 - interval '1:25';
    create table test_table
    (
        t timestamp not null default now()
    );
    call toolkit.ensureFutureTimestamp('test_table', 't');
    begin
        insert into test_table (t) values (t0), (t1), (t2);
        raise exception 'ensureFutureTimestamp() failed';
    exception
        when others then
            raise notice 'ensureFutureTimestamp() is ok';
    end;
    drop procedure toolkit.test2();
end
$$ language plpgsql;

/*
 *  ------------------------------------------------------------------------------
 *  Running tests
 *     All unit tests should be above this section
 *  ------------------------------------------------------------------------------
 */
do
$$
    begin
        call toolkit.test1();
        rollback;
        call toolkit.test2();
        rollback;
    end
$$ language plpgsql;