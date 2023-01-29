create or replace function toolkit.isTimestampFuture(thisTime timestamp,
                                                     tbl varchar,
                                                     col varchar) returns boolean as
$$
begin
    return toolkit.getLatestTime(tbl, col) >= thisTime;
end
$$ language plpgsql;