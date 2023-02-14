/*
 * bootstrap so we can version this file in the core database.
 */
create or replace function version.block_updates() RETURNS trigger AS
        $$
            begin
                raise exception using
                    errcode = 'UPDATE_BLOCKED',
                    message = 'the versioning table is write-once-read-many',
                    hint = 'update is blocked on versioning table.';
            end
                $$ language plpgsql;
/*
 *
 */
create table if not exists version.databases
(
    id      serial       not null primary key,
    name    varchar(255) not null unique,
    created timestamp    not null default now()
);
call toolkit.disable_updates('version.databases');
/*
 *
 */
drop table if exists version.filenames;
create table if not exists version.filenames
(
    id      serial       not null primary key,
    name    varchar(255) not null unique,
    created timestamp    not null default now()
        constraint file_name_pattern_check check (name ~ '^[a-zA-Z0-9()\.\-\_\+\/]+\.sql$')
);
call toolkit.disable_updates('version.filenames');
/*
 * create the version.data table.
 *     The versioning table is used by sql/versions to track
 *     objects created by schema within a database server.
 *     this can then be used to manage post-installation
 *     database/schema changes.
 */
drop table if exists version.data;
create table if not exists version.data
(
    file_hash     char(65)  not null primary key,
    file_name     integer   not null references version.filenames (id),
    database_name integer   not null references version.databases (id),
    install_date  timestamp not null default now(),
    description   text      not null default '',
    constraint file_hash_length check (length(file_hash) = 64),
    constraint file_hash_pattern_check check (file_hash ~ '^[0-9a-f]{64}')
);
call toolkit.disable_updates('version.data');
call toolkit.create_index('version.data', true, ARRAY['file_name','database_name']);

/*
 * version.register(file_name, file_hash, schema_name, database_name, description)
 *      registers a new version and optional description.
 */
create or replace procedure version.register(
    _file_name varchar, _database_name varchar,
    _file_hash varchar, _description text) as
$$
declare
    fn varchar      := (select trim(both from _file_name));
    fh varchar(255) := (select trim(both from _file_hash));
    db varchar(255) := (select trim(both from _database_name));
begin
    insert into version.databases(name) values (db) on conflict do nothing;
    insert into version.filenames(name) values (fn) on conflict do nothing;
    insert into version.data (file_hash, file_name, database_name, description)
    values (fh,
            (select id from version.filenames where name = fn),
            (select id from version.databases where name = db),
            (select trim(both from _description)));
end
$$ language plpgsql;
-- /*
--  *  ------------------------------------------------------------------------------
--  *  Unit Tests
--  *  ------------------------------------------------------------------------------
--  */
-- create or replace procedure version.test1() as
-- $$
-- begin
-- --     call version.register(
-- --             '0001.create.test1.sql', 'test_schema', 'test_db',
-- --             '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b',
-- --             'test');
--     drop procedure version.test1;
-- end
-- $$ language plpgsql;
-- create or replace procedure version.test2() as
-- $$
-- begin
--     call version.register(
--             '0001.create.schema.sql', 'test_schema', 'test_db',
--             '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b',
--             'test');
--     call version.register(
--             '0005.create.table.versioning.sql', 'test_schema', 'test_db',
--             'e422cc96979b088dc88238c15bff1572cfbeb953f0e6e1f447c5be76a5dd1a0c',
--             'this is a descriptor');
--     drop procedure version.test2;
-- end
-- $$ language plpgsql;
-- create or replace procedure version.test3() as
-- $$
-- begin
--     call version.register(
--             '0001.create.schema.sql', 'test_schema', 'test_db',
--             '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b',
--             'test');
--     call version.register(
--             '0005.create.table.versioning.sql', 'test_schema', 'test_db',
--             'e422cc96979b088dc88238c15bff1572cfbeb953f0e6e1f447c5be76a5dd1a0c',
--             'this is a descriptor');
--     begin
--         --duplicate hash
--         call version.register(
--                 '0001.create.schema2.sql', 'test_schema', 'test_db',
--                 '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b',
--                 'test');
--         raise exception 'test3: failed';
--     exception
--         when others then
--             raise notice 'ok';
--     end;
--     drop procedure version.test3;
-- end
-- $$ language plpgsql;
-- create or replace procedure version.test4() as
-- $$
-- begin
--     call version.register(
--             '0001.create.schema.sql', 'test_schema', 'test_db',
--             '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b',
--             'test');
--     call version.register(
--             '0005.create.table.versioning.sql', 'test_schema', 'test_db',
--             'e422cc96979b088dc88238c15bff1572cfbeb953f0e6e1f447c5be76a5dd1a0c',
--             'this is a descriptor');
--     begin
--         --duplicate name
--         call version.register(
--                 '0001.create.schema.sql', 'test_schema', 'test_db',
--                 '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7de42481a7871ad1b',
--                 'test');
--         raise exception 'test3: failed';
--     exception
--         when others then
--             raise notice 'ok';
--     end;
--     drop procedure version.test4;
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
--         call version.test1();
-- --         rollback;
-- --         call version.test2();
-- --         rollback;
-- --         call version.test3();
-- --         rollback;
-- --         call version.test4();
-- --         rollback;
--     end
-- $$ language plpgsql;