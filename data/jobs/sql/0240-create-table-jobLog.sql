DO
$$
    begin
        create table job.log
        (
            id        serial       not null primary key,
            taskId    integer      not null references job.tasks(id),
            key       integer      not null references job.keys(id),
            value     decimal      not null,
            tagSetId  integer      not null references job.tagSets(id),
            created   timestamp             default now()
        );
        call toolkit.disable_updates('job.log');
        call toolkit.create_index('job.log', false, ARRAY ['taskId']);
        call toolkit.create_index('job.log', false, ARRAY ['key']);
        call toolkit.create_index('job.log', false, ARRAY ['tagSetId']);
    end
$$ language plpgsql;