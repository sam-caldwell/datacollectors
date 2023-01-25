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
    tagSet integer[] := (select id
                         from log.tags);
begin
    return (select count(lhs.*) = 0
            from unnest(tags) lhs
            where (select array_position(tagSet, lhs) is null));
end
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
/*
 * create a set of tags in the log.tags table.
 * then call tagsValid(integer) with a set of tagIds that are in the set.
 * expect that tagsValid returns true.
 */
create or replace procedure log.test_tags_are_valid() as
$$
declare

begin
    --insert into log.tags(tag) values("test_tag:a","test_tag:b","test_tag:c","test_tag:d");
    drop procedure log.test_tags_are_valid();
end
$$ language plpgsql;

/*
 * create a set of tags in the log.tags table.
 * then call tagsValid(integer) with a set of tagIds that are NOT in the set.
 * expect that tagsValid returns false.
 */
create or replace procedure log.test_tags_are_not_valid() as
$$
declare

begin
    -- todo: finish test.
    drop procedure log.test_tags_are_not_valid();
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
        call log.test_tags_are_valid();
        call log.test_tags_are_not_valid();
    end
$$ language plpgsql;
