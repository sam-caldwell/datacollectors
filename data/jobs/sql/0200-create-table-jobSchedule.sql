DO
$$
    begin
        create table job.schedule
        (
            id        serial       not null primary key,
            name      varchar(255) not null unique,
            status    job.status   not null default 'disabled',
            frequency integer      not null,
            tags      integer[]    not null,
            created   timestamp             default now(),
            constraint frequencyPosInteger check (frequency >= 0)
        );
        call toolkit.create_index('job.schedule', false, ARRAY ['name','status']);
        call toolkit.create_index('job.schedule', false, ARRAY ['frequency']);

        create or replace trigger trigger_insert_schedule_tags before insert
            on job.schedule
            execute function log.validateTags();


    end
$$ language plpgsql;