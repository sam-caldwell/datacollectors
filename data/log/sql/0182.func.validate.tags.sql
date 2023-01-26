/*
 * validateTags() is used to validate tags within a table as
 * the trigger function for that table.  Where new.tags is
 * an array of
 */
create or replace function log.validateTags() returns trigger as
$$
begin
    if not log.tagsValid(new.tags) then
        raise exception 'invalid tag';
    end if;
    return new;
end
$$ language plpgsql;
