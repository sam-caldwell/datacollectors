/*
    job_status is a generic status tracker for workflow automation
    when controlling the jobs that collect data in the system.
 */
create or replace procedure create_0001_types_job_status() as
$$
begin
    call create_type('job_status',ARRAY['not started','in progress','completed']);
end
$$ language plpgsql;
