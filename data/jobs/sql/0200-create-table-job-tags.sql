DO
$$
    begin
        create table if not exists job.tags
        (
            id      serial    not null primary key,
            tag     varchar   not null unique,
            created timestamp not null default now()
        );
        call toolkit.create_index('job.tags', false, ARRAY ['tag']);
    end
$$ language plpgsql;
