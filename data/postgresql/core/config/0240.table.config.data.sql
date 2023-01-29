/*
 * config.data is a table of key-value pairs
 *
 * Todo: add encrypted values
 * Todo: add expiring rows.
 */
call toolkit.create_enum('config.class', ARRAY ['clear_text','expiring','encrypted']);
create table config.data
(
    key      varchar(255) not null primary key,
    value    text         not null default '',
    class     config.class        not null default 'clear_text',
    created  timestamp             default now(),
    updated  timestamp    null     default null
);
-- call toolkit.ensureFutureTimestamp('config.data', 'created');
-- call toolkit.ensureFutureTimestamp('config.data', 'updated');
call toolkit.create_index('config.data', false, ARRAY ['key']);
call toolkit.create_index('config.data', false, ARRAY ['class']);
call toolkit.create_index('config.data', false, ARRAY ['created']);
call toolkit.create_index('config.data', false, ARRAY ['updated']);
