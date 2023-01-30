create table if not exists job.history
(
    id            serial    not null primary key,
    jobId         integer   not null references job.schedule (id),
    success       boolean   not null,
    executionTime timestamp not null,
    created       timestamp not null default now()
);
/*
 * This table should be worm
 */
call toolkit.disable_updates('job.history');
/*
 * indexes
 */
call toolkit.create_index('job.history', false, ARRAY ['created']);

call toolkit.create_index('job.history', false, ARRAY ['success']);
/*
 * toDo: ensure times are consistent...  historical times should be after an job's creation.
 */