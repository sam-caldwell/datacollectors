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

call toolkit.create_trigger('job.runners','insert','job.validateTags');
