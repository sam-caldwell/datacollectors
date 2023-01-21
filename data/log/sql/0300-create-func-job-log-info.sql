create or replace procedure log.info(taskId integer, key varchar, value decimal, tags varchar[]) as
$$
begin
    call log.write(info, taskId, key, vvalue, tags);
end
$$ language plpgsql;
