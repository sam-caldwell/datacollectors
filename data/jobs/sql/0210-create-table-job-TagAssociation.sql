DO
$$
    begin
        create table if not exists job.tagAssociation
        (
            id       serial    not null primary key,
            tagId    integer   not null references job.tags (id),
            tagSetId integer   not null references job.tagSets (id),
            created  timestamp not null default now()
        );

    end
$$ language plpgsql;
