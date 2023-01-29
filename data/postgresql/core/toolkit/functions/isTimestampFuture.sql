create or replace function toolkit.isTimestampFuture(thisTime timestamp, tbl varchar, col varchar) returns boolean as
$$
declare
    latestTime timestamp;
begin
    execute (format('select max(%s) from %s;', col, tbl)) into latestTime;
    return latestTime >= thisTime;
end
$$ language plpgsql;