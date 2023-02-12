create or replace function toolkit.isUpdatedAfterCreated(created_time timestamp,
                                                         tbl varchar,
                                                         updated_col varchar) returns boolean as
$$
begin
    return created_time >= toolkit.getLatestTime(tbl, updated_col);
end
$$ language plpgsql;
