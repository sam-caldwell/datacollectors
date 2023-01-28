
/*
 * get_details job controller tables
 */

-- create table if not exists get_details_job
-- (
--     jobId   serial     not null primary key,
--     status  job_status not null,
--     created timestamp  not null default now(),
--     updated timestamp  null     default null
-- );
--
-- create table if not exists get_details_job_manifest
-- (
--     taskid    serial    not null primary key,
--     jobId   integer   not null references get_details_job (jobId),
--     sid     integer   not null references roster (sid),
--     created timestamp not null default now(),
--     updated timestamp null     default null
-- );
--
-- create table if not exists get_details_job_activity
-- (
--     id serial not null primary key,
--     taskId integer not null references get_details_job_manifest(taskid),
--     status job_status not null,
--     eventTime timestamp not null default now()
-- );
-- create index ndx_get_details_job_activity_status on get_details_job_activity(status);
-- create index ndx_get_details_job_activity_event_time on get_details_job_activity(eventTime);
