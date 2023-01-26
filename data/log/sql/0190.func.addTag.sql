/*
 * log.addTag() - add new tag to tags table
 */
create or replace procedure log.addTag(tag varchar) as
$$
begin
    lock table log.tags in exclusive mode;
    set transaction isolation level read committed;
    call log.tagsReadWrite();
    insert into log.tags(tag) values (tag);
    call log.tagsReadOnly();
    commit;
end
$$ language plpgsql;
