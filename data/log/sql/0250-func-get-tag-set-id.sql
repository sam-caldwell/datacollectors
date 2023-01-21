create or replace function log.getTagSetId(_tags varchar[]) returns integer[] as
$$
declare
    result integer[] := (select id
                         from log.tags
                         where tags in (select * from unnest(_tags)));
begin
    return result;
end;
$$ language plpgsql;
