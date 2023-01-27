DO
$$
    begin
        create table if not exists job.queue
        (
            id      serial    not null primary key,
            jobId   integer   not null references job.schedule (id),
            created timestamp not null default now()
        );
        call toolkit.disable_updates('job.queue');
        call toolkit.create_index('job.queue', false, ARRAY ['created']);
    end
$$ language plpgsql;
