/*
 * The job.status enum identifies the current state of a job.
 */
call toolkit.create_enum('job.status',ARRAY['not_started','in_progress','disabled']);