create or replace procedure log.critical(taskId integer, key varchar, value decimal, tags varchar[]) as
$$
begin
    call log.write(critical, taskId, key, vvalue, tags);
end
$$ language plpgsql;
