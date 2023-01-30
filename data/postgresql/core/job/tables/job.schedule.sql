create table job.schedule
(
    id        serial       not null primary key,
    name      varchar(255) not null unique,
    status    job.status   not null default 'disabled',
    frequency integer      not null,
    tags      integer[]    not null,
    created   timestamp    not null default now(),
    updated   timestamp    null     default null,
    constraint frequencyPosInteger check (frequency >= 0)
);

/*
 * Our default behavior is read-only.  Direct table edits is discouraged.
 */
call toolkit.disable_updates('job.schedule');
call toolkit.block_inserts('job.schedule');
/*
 * indexes
 */
call toolkit.create_index('job.schedule', false, ARRAY ['name','status']);

call toolkit.create_index('job.schedule', false, ARRAY ['frequency']);
/*
 * Tag validation
 */
call toolkit.create_trigger('job.schedule', 'insert', 'job.validateTags()');
/*
 * timestamp validation
 */
--Todo: add this
