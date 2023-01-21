DO
$$
    begin
        create table if not exists job.keys
        (
            id      serial    not null primary key,
            key     varchar   not null unique,
            created timestamp not null default now()
        );
    end
$$ language plpgsql;
