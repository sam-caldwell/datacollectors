create or replace procedure toolkit.create_sequence(o varchar, a integer, i integer) as
$$
declare
    sql varchar := format('create sequence if not exists %s start %s increment %s;', o, a, i);
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
create or replace procedure toolkit.test_create_sequence() as
$$
declare
--     result text:='';
    seq_name    varchar := 'sequence';
    seq_start        integer := 3;
    seq_increment    integer := 13;
    actual_start     integer;
    actual_increment integer;
begin
    call toolkit.create_sequence(seq_name, seq_start, seq_increment);
    actual_start := (select start_value from information_schema.sequences where sequence_name = seq_name);
    actual_increment := (select increment from information_schema.sequences where sequence_name = seq_name);
    if actual_start <> seq_start then
        raise exception 'seq_start mismatch on sequence';
    end if;
    if actual_increment <> seq_increment then
        raise exception 'seq_increment mismatch on sequence';
    end if;
    -- clean-up
    execute format('drop sequence %s', seq_name);
    drop procedure toolkit.test_create_sequence;
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
        raise notice 'test: toolkit.create_enum() starting';
        call toolkit.test_create_sequence();
    end
$$ language plpgsql;
