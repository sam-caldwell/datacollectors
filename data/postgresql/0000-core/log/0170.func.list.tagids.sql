/*
 * log.listTagIds() will return an array of tagIds (integers)
 */
create or replace function log.listTagIds(_cnt integer, _start integer) returns integer[] as
$$
declare
    resultStart bigint = 0;
begin
    if _start > 0 then
        resultStart = _start;
    end if;
    if _cnt <= 0 then
        return array(select id from log.tags limit all offset resultStart);
    else
        return array(select id from log.tags limit _cnt offset resultStart);
    end if;
end
$$ language plpgsql;