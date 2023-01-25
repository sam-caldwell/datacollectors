/*
 * toolkit.register_version(file_name, file_hash [, description])
 *      registers a new version and optional description.
 */
create or replace procedure toolkit.register_version(file_name varchar, file_hash varchar, description text) as
$$
begin
    insert into toolkit.versioning (file_name, file_hash, description)
    values (file_name, file_hash, description);
end
$$ language plpgsql;

create or replace procedure toolkit.register_version(file_name varchar, file_hash varchar) as
$$
begin
    insert into toolkit.versioning (file_name, file_hash)
    values (file_name, file_hash);
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
            '0000-create-schema.sql',
            '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b');
    drop procedure toolkit.test1;
end
$$ language plpgsql;
create or replace procedure toolkit.test2() as
$$
begin
    call toolkit.register_version(
            '0000-create-schema.sql',
            '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b');
    call toolkit.register_version(
            '0005-create-table-versioning.sql',
            'e422cc96979b088dc88238c15bff1572cfbeb953f0e6e1f447c5be76a5dd1a0c', 'this is a descriptor');
    drop procedure toolkit.test2;
end
$$ language plpgsql;
create or replace procedure toolkit.test3() as
$$
begin
    call toolkit.register_version(
            '0000-create-schema.sql',
            '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b');
    call toolkit.register_version(
            '0005-create-table-versioning.sql',
            'e422cc96979b088dc88238c15bff1572cfbeb953f0e6e1f447c5be76a5dd1a0c', 'this is a descriptor');
    begin
        --duplicate hash
        call toolkit.register_version(
                '0001-create-schema2.sql',
                '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b');
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
            '0000-create-schema.sql',
            '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7def2481a7871ad1b');
    call toolkit.register_version(
            '0005-create-table-versioning.sql',
            'e422cc96979b088dc88238c15bff1572cfbeb953f0e6e1f447c5be76a5dd1a0c', 'this is a descriptor');
    begin
        --duplicate name
        call toolkit.register_version(
                '0000-create-schema.sql',
                '986c1b76ae8dd69207134eae8e3640017fab5150f4d164e7de42481a7871ad1b');
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