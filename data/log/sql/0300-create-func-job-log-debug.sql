create or replace procedure log.debug(taskId integer, key varchar, value decimal, tags varchar[]) as
$$
begin
    call log.write(debug, taskId, key, vvalue, tags);
end
$$ language plpgsql;
