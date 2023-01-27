create or replace procedure toolkit.delete_sequence(o varchar) as
$$
declare
    sql varchar := format('drop sequence if exists %s;', o);
begin
    execute sql;
end
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
/*
 * test the create_sequence() function works without errors.
 */
create or replace procedure toolkit.test_delete_sequence() as
$$
declare
    count         integer := 0;
    seq_name      varchar := 'test_sequence';
    seq_start     integer := 3;
    seq_increment integer := 13;
begin
    call toolkit.create_sequence(seq_name, seq_start, seq_increment);
    call toolkit.delete_sequence(seq_name);
    count := (select count(*) from information_schema.sequences where sequence_name = seq_name);
    if count > 0 then
        raise exception 'test_delete_sequence() failed.';
    end if;
    -- clean-up
    drop procedure toolkit.test_delete_sequence;
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
        raise notice 'test: toolkit.delete_sequence() starting';
        call toolkit.test_delete_sequence();
        rollback;
    end
$$ language plpgsql;
