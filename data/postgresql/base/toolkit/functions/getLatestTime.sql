create or replace function toolkit.getLatestTime(tbl varchar, col varchar) returns timestamp as
$$
    declare
        latest timestamp;
    begin
        execute(format('select max(%s) from %s', col, tbl)) into latest;
        return latest;
    end
$$ language plpgsql;