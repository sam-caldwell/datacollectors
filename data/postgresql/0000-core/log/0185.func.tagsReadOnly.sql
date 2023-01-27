/*
 * tagsReadOnly() - disallow inserts to the log.tags table
 */
create or replace procedure log.tagsReadOnly() as
$$
begin
    call toolkit.block_inserts('log.tags');
end
$$ language plpgsql;
