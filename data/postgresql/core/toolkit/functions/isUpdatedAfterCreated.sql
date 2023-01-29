create or replace function toolkit.isUpdatedAfterCreated(tbl varchar,
                                                         updated_col varchar,
                                                         created_time timestamp) returns boolean as
$$
declare
    latestTime timestamp;
begin
    execute (format('select max(%s) from %s;', updated_col, tbl)) into latestTime;
    return created_time >= latestTime;
end
$$ language plpgsql;