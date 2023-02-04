create or replace function toolkit.isTimestampFuture(this_time timestamp,
                                                     tbl varchar,
                                                     col varchar) returns boolean as
$$
begin
    return toolkit.getLatestTime(tbl, col) >= this_time;
end
$$ language plpgsql;