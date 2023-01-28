/*
 * the keys table allows us to create a finite set of keys and reference them
 * multiple times with the key 'id' (integer).
 *
 * A 'key' in this context is the event name in log.events.
 */
DO
$$
    begin
        create table if not exists log.keys
        (
            id      serial    not null primary key,
            key     varchar(255)   not null unique,
            created timestamp not null default now()
        );
        call toolkit.disable_updates('log.keys');
    end
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
-- /*
--  * test that we can set a value to the configuration table.
--  */
-- create or replace procedure log.test_log_keys_table() as
-- $$
-- declare
--     c integer := 0;
-- begin
--     c = (select count(*)
--          from information_schema.columns
--          where (
--                      table_schema = 'log' and table_name = 'keys'
--              )
--            and (
--                  (
--                          (column_name = 'id')
--                          and (data_type = 'integer')
--                          and (column_default = 'nextval(''log.keys_id_seq''::regclass)')
--                          and (udt_name = 'int4')
--                      ) OR (
--                          (column_name = 'key')
--                          and (data_type = 'character varying')
--                          and (column_default is null)
--                          and (udt_name = 'varchar')
--                      ) OR (
--                          (column_name = 'created')
--                          and (data_type = 'timestamp without time zone')
--                          and (column_default = 'now()')
--                          and (udt_name = 'timestamp')
--                      )
--              ));
--     if c < 3 then
--         raise exception 'missing or misconfigured tags table/columns: %', c;
--     end if;
--     drop procedure log.test_log_keys_table;
-- end
-- $$ language plpgsql;
-- /*
--  * verify that we block updates.
--  */
-- create or replace procedure log.test_block_log_keys_updates() as
-- $$
-- declare
--     ok boolean = false;
-- begin
--     -- create the first three tags
--     insert into log.keys (key) values ('key:a'), ('key:b'), ('key:c');
--     -- create a duplicate and expect an exception
--     begin
--         insert into log.keys(key) values ('key:a');
--         raise exception 'duplicates should have been blocked';
--     exception
--         when others then
--             raise notice 'duplicates blocked as expected';
--     end;
--     begin
--         update log.keys set key='key:bad' where key = 'key:a';
--         raise exception  'update should have been blocked';
--     exception
--         when others then
--             raise notice 'updates blocked as expected';
--     end;
--     drop procedure log.test_block_log_keys_updates;
-- end
-- $$ language plpgsql;
-- /*
--  *  ------------------------------------------------------------------------------
--  *  Running tests
--  *     All unit tests should be above this section
--  *  ------------------------------------------------------------------------------
--  */
-- do
-- $$
--     begin
--         raise notice 'test: log.key table';
--         call log.test_log_keys_table();
--         rollback;
--         call log.test_block_log_keys_updates();
--         rollback;
--     end
-- $$ language plpgsql;
