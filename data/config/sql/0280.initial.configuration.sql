/*
 * Seed the key-value store with some basic data.
 */
DO
$$
    begin
        call config.set('db.log.severity', 'info');
        call config.set('db.config.initialized', format('%s', now()));
--         add more default config records.
    end;
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
/*
 * Verify the initial config state exists as expected.
 */
create or replace procedure config.test_default_log_severity() as
$$
declare
    n varchar := 'db.log.severity';
    v varchar := 'info';
begin
    raise notice 'test: starting config.test_default_log_severity';
    --verify the table has the expected data.
    if (select config.get(n, true)) <> v then
        raise exception 'test_default_log_severity failed (actual: %)',v;
    end if;
    --clean-up after test.
    drop procedure config.test_default_log_severity();
end
$$ language plpgsql;
/*
 * Verify the initial config state exists as expected.
 */
create or replace procedure config.test_db_config_initialized() as
$$
declare
    n varchar   := 'db.config.initialized';
begin
    raise notice 'test: % starting', n;
    --verify the table has the expected data.
    if not ((select config.get(n, true))::timestamp is not NULL) then
        raise exception 'test_db_config_initialized failed (actual: %)',config.get(n, true);
    end if;
    --clean-up after test.
    drop procedure config.test_db_config_initialized();
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
        raise notice 'test: config.get() starting';
        call config.test_default_log_severity();
        rollback;
        call config.test_db_config_initialized();
        rollback;
    end
$$ language plpgsql;
