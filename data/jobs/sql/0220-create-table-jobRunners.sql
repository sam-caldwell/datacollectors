DO
$$
    begin
        create table if not exists job.runners
        (
            id             serial    not null primary key,
            name           varchar   not null unique,
            argumentSchema json      not null,
            description    text      not null default '',
            tagSetId       integer   not null references job.tagSets (id),
            created        timestamp not null default now()
        );
        call toolkit.create_index('job.runners', false, ARRAY ['tagSetId']);
        call toolkit.create_index('job.runners', false, ARRAY ['created']);
    end
$$ language plpgsql;
