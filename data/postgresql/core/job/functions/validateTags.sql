/*
 * validateTags() is used to validate tags within a table as
 * the trigger function for that table.  Where new.tags is
 * an array of
 */
create or replace function job.validateTags() returns trigger as
$$
begin
    if not log.tagsValid(new.tags) then
        raise exception using
            errcode = 'INVALID_TAG',
            message = 'invalid tag',
            hint = 'The given tag was not previously registered with the tag table';
    end if;
    return new;
end
$$ language plpgsql;
