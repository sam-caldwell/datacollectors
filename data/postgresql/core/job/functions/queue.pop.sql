create or replace function job.pop() returns integer as
$$
declare
    this_id integer;
begin
    set transaction isolation level serializable;
    this_id := (select id from job.queue where expiration is not null order by id desc limit 1);
    update job.queue set expiration=now() + '1 hour'::interval where (id = this_id);
    return this_id;
end
$$ language plpgsql