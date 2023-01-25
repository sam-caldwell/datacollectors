/*
 * Event severity helps segment the important errors from more informative events.
 * We could have used tags here, but a tag would be available to all areas of the
 * environment and we are only concerned with severity of the events.
 */
call toolkit.create_enum('log.severity', ARRAY ['critical','error','info', 'debug']);
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
create or replace procedure log.test_enum_severity() as
$$
declare
    raw varchar;
    severities varchar[];
begin
    select enum_range(NULL::log.severity) into raw;
    raw = replace(replace(raw,'{',''),'}','');
    call toolkit.assert(enum_first('critical'::log.severity)='critical'::log.severity,'Expect critical to be position 0');
    call toolkit.assert(enum_last('debug'::log.severity)='debug'::log.severity,'Expect debug to be position 3');
    call toolkit.assert((enum_range(NULL::log.severity)::text = '{critical,error,info,debug}')::boolean, 'log severity order mismatch');
    --clean-up
    drop procedure log.test_enum_severity;
end;
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
        raise notice 'test: log.test_enum_severity() starting';
        call log.test_enum_severity();
    end
$$ language plpgsql;
