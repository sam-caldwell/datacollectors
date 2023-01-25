/*
 * Bootstrap the essentials
 */
/*
 * The sql/toolkit project aims to create common easy-to-use
 * sql functions/procedures and other objects which can
 * be used by other databases which use toolkit db as a template.
 */
create schema if not exists toolkit;
/*
 * create the toolkit.versioning table.
 *     The versioning table is used by sql/toolkit to track
 *     objects created by schema within a database server.
 *     this can then be used to manage post-installation
 *     database/schema changes.
 */
create table toolkit.versioning
(
    file_hash    char(65)      not null primary key,
    file_name    varchar(1024) not null unique,
    description  text          not null default '',
    install_date timestamp     not null default now()
        constraint file_name_pattern_check check (file_name ~ '^[0-9]{4}-[a-zA-Z0-9\-_]*\.sql$')
        constraint file_hash_length check(length(file_hash) = 64)
        constraint file_hash_pattern_check check (file_hash ~ '^[0-9a-f]{64}')
);
/*
 * ensure the table can only be WORM
 */
create or replace function toolkit.read_only_versioning() RETURNS trigger AS
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
create or replace trigger trigger_versioning_insert_read_only
    before update
    on toolkit.versioning
execute function toolkit.read_only_versioning();
/*
 * toolkit.register_version(file_name, file_hash, description)
 *      registers a new version and optional description.
 */
create or replace procedure toolkit.register_version(_file_name varchar,
                                                     _file_hash varchar,
                                                     _description text) as
$$
declare
    fn varchar := (select trim(both from _file_name));
    fh varchar(64) := (select trim(both from _file_hash));
begin
    insert into toolkit.versioning (file_name, file_hash, description)
    values (fn, fh, _description);
    perform pg_sleep(0.1);
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
    call toolkit.register_version(
            '0001-create-test1.sql',
            '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b',
            'test');
    drop procedure toolkit.test1;
end
$$ language plpgsql;
create or replace procedure toolkit.test2() as
$$
begin
    call toolkit.register_version(
            '0001-create-schema.sql',
            '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b',
            'test');
    call toolkit.register_version(
            '0005-create-table-versioning.sql',
            'e422cc96979b088dc88238c15bff1572cfbeb953f0e6e1f447c5be76a5dd1a0c',
            'this is a descriptor');
    drop procedure toolkit.test2;
end
$$ language plpgsql;
create or replace procedure toolkit.test3() as
$$
begin
    call toolkit.register_version(
            '0001-create-schema.sql',
            '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b',
            'test');
    call toolkit.register_version(
            '0005-create-table-versioning.sql',
            'e422cc96979b088dc88238c15bff1572cfbeb953f0e6e1f447c5be76a5dd1a0c',
            'this is a descriptor');
    begin
        --duplicate hash
        call toolkit.register_version(
                '0001-create-schema2.sql',
                '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b',
                'test');
        raise exception 'test3: failed';
    exception
        when others then
            raise notice 'ok';
    end;
    drop procedure toolkit.test3;
end
$$ language plpgsql;
create or replace procedure toolkit.test4() as
$$
begin
    call toolkit.register_version(
            '0001-create-schema.sql',
            '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b',
            'test');
    call toolkit.register_version(
            '0005-create-table-versioning.sql',
            'e422cc96979b088dc88238c15bff1572cfbeb953f0e6e1f447c5be76a5dd1a0c',
            'this is a descriptor');
    begin
        --duplicate name
        call toolkit.register_version(
                '0001-create-schema.sql',
                '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7de42481a7871ad1b',
                'test');
        raise exception 'test3: failed';
    exception
        when others then
            raise notice 'ok';
    end;
    drop procedure toolkit.test4;
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
        call toolkit.test3();
        rollback;
        call toolkit.test4();
        rollback;
    end
$$ language plpgsql;