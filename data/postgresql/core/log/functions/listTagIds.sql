/*
 * log.listTagIds() will return an array of tagIds (integers)
 */
create or replace function log.listTagIds(_cnt integer default 0, _start integer default 0) returns integer[] as
$$
declare
    resultStart bigint = 0;
begin
    if _cnt <= 0 then
        return array(select id from log.tags limit all offset _start);
    else
        return array(select id from log.tags limit _cnt offset _start);
    end if;
end
$$ language plpgsql;