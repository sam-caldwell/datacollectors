
create or replace function toolkit.callCheckFunc(func varchar, timeCol varchar, tbl varchar, col varchar) returns text as
$$
begin
    return format('%s(%s, ''%s'', ''%s'')', func, timeCol, tbl, col);
end
$$ language plpgsql;