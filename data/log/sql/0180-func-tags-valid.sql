/*
 * log.tagsValid() takes an array of tags as input and validates that all elements
 * in the array are in the log.tags table.
 */
create or replace function log.tagsValid(tags integer[]) returns boolean as
$$
declare
    tagSet integer[] := (select id from log.tags);
begin
    return (select count(lhs.*) = 0
            from unnest(tags) lhs
            where (select array_position(tagSet, lhs) is null));
end
$$ language plpgsql;

