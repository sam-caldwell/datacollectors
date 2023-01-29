/*
 * Seed the key-value store with some basic data.
 */
call config.set('db.log.severity', 'info');
call config.set('db.config.initialized', format('%s', now()));
-- add more default config records.