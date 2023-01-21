DO
$$
    begin
        create table if not exists job.tagSets
        (
            id             serial    not null primary key,
            created        timestamp not null default now()
        );
    end
$$ language plpgsql;
