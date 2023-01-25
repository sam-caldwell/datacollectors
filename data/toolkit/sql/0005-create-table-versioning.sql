/*
 * create the toolkit.versioning table.
 *     The versioning table is used by sql/toolkit to track
 *     objects created by schema within a database server.
 *     this can then be used to manage post-installation
 *     database/schema changes.
 */
create table toolkit.versioning
(
    file_hash    char(64)      not null primary key,
    file_name    varchar(1024) not null unique,
    description  text          not null default '',
    install_date timestamp     not null default now()
        constraint file_name_pattern_check check (file_name ~ '^[0-9]{4}-[a-zA-Z0-9\-_]*\.sql$')
        constraint file_hash_pattern_check check (file_hash ~ '^[A-F0-9a-f]{64}$')
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
