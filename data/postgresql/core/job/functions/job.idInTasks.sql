create or replace function job.idInTasks(this_id integer) returns boolean as
$$
begin
    return (select count(jobId) from job.tasks where jobId = this_id) > 0;
end;
$$ language plpgsql;