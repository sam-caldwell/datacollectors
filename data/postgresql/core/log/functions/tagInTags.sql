/*
 * tagInTags() determines if a given tag (integer) is in the set of tags (table)
 */
DO
$$
    begin
        create or replace function log.tagInTags(t integer[]) returns boolean as
        $F$
        begin
            select t from unnest(t) where t in (select id from log.tags);
        end
        $F$ language plpgsql;
    end
$$ language plpgsql;