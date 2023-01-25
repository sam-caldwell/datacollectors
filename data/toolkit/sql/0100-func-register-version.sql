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
