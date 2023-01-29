/*
 * tagsReadWrite() - allow inserts to the log.tags table
 */
create or replace procedure log.tagsReadWrite() as
$$
begin
    call toolkit.allow_inserts('log.tags');
end
$$ language plpgsql;