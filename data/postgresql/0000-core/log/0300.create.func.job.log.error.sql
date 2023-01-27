create or replace procedure log.error(taskId integer, key varchar, value decimal, tags varchar[]) as
$$
begin
    call log.write(error, taskId, key, vvalue, tags);
end
$$ language plpgsql;
