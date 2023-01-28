/*
 * The tags table provides a set of tags which can be referenced by the tag 'id'
 * for efficiency while also allowing a unique set of tags which can be quickly
 * enumerated during analysis.
 */
DO
$$
    begin
        create table if not exists log.tags
        (
            id      serial      not null primary key,
            tag     varchar(64) not null unique,
            created timestamp   not null default now()
        );
        call toolkit.disable_updates('log.tags');
        call toolkit.create_index('log.tags', false, ARRAY ['tag']);
    end
$$ language plpgsql;
-- /*
--  *  ------------------------------------------------------------------------------
--  *  Unit Tests
--  *  ------------------------------------------------------------------------------
--  */
-- /*
--  * test that we can set a value to the configuration table.
--  */
-- create or replace procedure log.test_log_tags_table() as
-- $$
-- declare
--     c integer := 0;
-- begin
--     c = (select count(*)
--          from information_schema.columns
--          where (
--              table_schema = 'log' and table_name = 'tags'
--              )
--            and (
--                  (
--                          (column_name = 'id')
--                          and (data_type = 'integer')
--                          and (column_default = 'nextval(''log.tags_id_seq''::regclass)')
--                          and (udt_name = 'int4')
--                      ) OR (
--                          (column_name = 'tag')
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
--     call toolkit.assert((c = 3), 'missing or misconfigured tags table/columns');
--     drop procedure log.test_log_tags_table;
-- end
-- $$ language plpgsql;
-- /*
--  * verify that we block updates.
--  */
-- create or replace procedure log.test_block_log_tags_updates() as
-- $$
-- declare
--     ok boolean = false;
-- begin
--     -- create the first three tags
--     insert into log.tags (tag) values ('tag:a'), ('tag:b'), ('tag:c');
--     -- create a duplicate and expect an exception
--     begin
--         insert into log.tags(tag) values ('tag:a');
--         raise exception 'duplicates should have been blocked';
--     exception
--         when others then
--             raise notice 'duplicates blocked as expected';
--     end;
--     begin
--         update log.tags set tag='tag:bad' where tag = 'tag:a';
--         raise exception 'update should have been blocked';
--     exception
--         when others then
--             raise notice 'updates blocked as expected';
--     end;
--     drop procedure log.test_block_log_tags_updates;
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
--         raise notice 'test: log.tags table';
--         call log.test_log_tags_table();
--         rollback;
--         call log.test_block_log_tags_updates();
--         rollback;
--     end
-- $$ language plpgsql;