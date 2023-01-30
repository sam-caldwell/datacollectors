create table if not exists job.queue
(
    id         serial    not null primary key,
    jobId      integer   not null,
    taskId     integer   null references job.tasks (id),
    created    timestamp not null default now(),
    expiration timestamp null     default null,
    constraint ensure_jobId_in_job_tasks check (job.idInTasks(jobId)),
    constraint ensure_expires_after_created check ((expiration is null) or (expiration >= created)),
    constraint ensure_expires_after_now check (expiration > now())
);
/*
 * This table should be worm
 */
call toolkit.disable_updates('job.queue');
/*
 * indexes
 */
call toolkit.create_index('job.queue', false, ARRAY ['created']);
