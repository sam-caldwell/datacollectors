/*
 * log.tagsValid() takes an array of tags as input and validates that all elements
 * in the array are in the log.tags table.
 *
 * return 0 if tags are valid
 * return a count of deviating (invalid) tags.
 */
create or replace function log.tagsValid(tags integer[]) returns boolean as
$$
declare
    expectedTags integer[] := (select log.listTagIds(-1, 0));
    deviations   boolean   := (select count(*) = 0
                               from unnest(tags) lhs
                               where (select array_position(expectedTags, lhs) is null));
begin
    return deviations;
end
$$ language plpgsql;
-- /*
--  *  ------------------------------------------------------------------------------
--  *  Unit Tests
--  *  ------------------------------------------------------------------------------
--  */
-- /*
--  * create a set of tags in the log.tags table.
--  * then call tagsValid(integer) with a set of tagIds that are in the set.
--  * expect that tagsValid returns true.
--  */
-- create or replace procedure log.test_tags_are_valid() as
-- $$
-- declare
--     tagList integer[];
-- begin
--     insert into log.tags(tag) values ('test_tag:a'), ('test_tag:b'), ('test_tag:c'), ('test_tag:d');
--     select array(select id from log.tags) into tagList;
--     if not log.tagsValid(tagList) then
--         raise exception 'tags should be valid %', tagList;
--     end if;
--     -- clean-up
--     drop procedure log.test_tags_are_valid();
-- end
-- $$ language plpgsql;
--
-- /*
--  * create a set of tags in the log.tags table.
--  * then call tagsValid(integer) with a set of tagIds that are NOT in the set.
--  * expect that tagsValid returns false.
--  */
-- create or replace procedure log.test_tags_are_not_valid() as
-- $$
-- declare
--     tagList integer[];
-- begin
--     insert into log.tags(tag) values ('test_tag:a'), ('test_tag:b'), ('test_tag:c'), ('test_tag:d');
--     tagList = (select id from log.tags);
--     tagList = array_append(tagList, 1337);
--     if log.tagsvalid(tagList) then
--         raise exception 'invalid tags should have been detected';
--     end if;
--     -- clean-up
--     drop procedure log.test_tags_are_not_valid();
-- end
-- $$ language plpgsql;
-- /*
--  *  ------------------------------------------------------------------------------
--  *  Running tests
--  *     All unit tests should be above this section
--  *  ------------------------------------------------------------------------------
--  */
-- do
-- $$
--     begin
--         call log.test_tags_are_valid();
--         rollback;
--         --         call log.test_tags_are_not_valid();
-- --         rollback;
--     end
-- $$ language plpgsql;
