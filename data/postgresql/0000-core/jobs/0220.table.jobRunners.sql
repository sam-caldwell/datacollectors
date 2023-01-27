DO
$$
    begin
        create table if not exists job.runners
        (
            id             serial    not null primary key,
            name           varchar   not null unique,
            argumentSchema json      not null,
            description    text      not null default '',
            tags           integer   not null,
            created        timestamp not null default now()
        );
        call toolkit.create_index('job.runners', false, ARRAY ['tags']);
        call toolkit.create_index('job.runners', false, ARRAY ['created']);

        create or replace trigger trigger_insert_runners_tags before insert
            on job.schedule
        execute function job.validateTags();

    end
$$ language plpgsql;
