DO
$$
    begin
        create table if not exists job.tasks
        (
            id             serial    not null primary key,
            jobId          integer   not null references job.schedule(id),
            description    text      not null default '',
            runnerId       integer   not null references job.runners(id),
            arguments      json      not null,
            created        timestamp not null default now()
        );
    end
$$ language plpgsql;
