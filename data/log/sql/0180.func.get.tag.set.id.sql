/*
 * Given a list of tag names (varchar), return the list of associated
 * tagId (integer) values.
 */
create or replace function log.getTagSetId(_tags varchar[]) returns integer[] as
$$
declare
    result integer[] := (select array_agg(id)
                         from log.tags
                         where tag in (select * from unnest(_tags)));
begin
    return result;
end;
$$ language plpgsql;
/*
 *  ------------------------------------------------------------------------------
 *  Unit Tests
 *  ------------------------------------------------------------------------------
 */
/*
 * Given a set of tags inserted into the tags table,
 *   test to verify that calling getTagSetId() will return the array of tagIds.
 */
create or replace procedure log.test_get_tag_set_id() as
$$
declare
    expected_ids  integer[];
    expected_tags varchar[];
    actual_ids    integer[];
begin
    insert into log.tags (tag) values ('tag:a'),('tag:b'),('tag:c'),('tag:d');
    expected_ids = (select array_agg(id) from log.tags where tag in ('tag:a', 'tag:b', 'tag:c', 'tag:d'));
    expected_tags = (select array_agg(tag) from log.tags where tag in ('tag:a', 'tag:b', 'tag:c', 'tag:d'));
    actual_ids = log.getTagSetId(expected_tags);

    call toolkit.assert((actual_ids[0] = expected_ids[0]), 'tag[0] mismatch');
    call toolkit.assert((actual_ids[1] = expected_ids[1]), 'tag[1] mismatch');
    call toolkit.assert((actual_ids[2] = expected_ids[2]), 'tag[2] mismatch');
    call toolkit.assert((actual_ids[3] = expected_ids[3]), 'tag[3] mismatch');

    --clean-up
    drop procedure log.test_get_tag_set_id;
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
        raise notice 'test: log.test_get_tag_set_id() starting';
        call log.test_get_tag_set_id();
        rollback;
    end
$$ language plpgsql;