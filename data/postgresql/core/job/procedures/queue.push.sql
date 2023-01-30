create or replace procedure job.push(job_name varchar) as
$$
declare
    c     integer;
    jobId integer;
begin
    set transaction isolation level serializable;
    c := (select count(id) from job.schedule where name = job_name);
    if c <= 0 then
        raise exception using
            errcode = 'MISSING_JOB',
            message = format('Job (%s) not found in job.schedules', job_name),
            hint = 'verify the job has been created first.';
    end if;

    select t.jobId as jobId,
           t.id    as taskId
    into job.queue
    from job.tasks t
    where t.jobId in (select id from job.schedule where name = job_name)
    order by id;

end
$$ language plpgsql;
