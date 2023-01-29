/*
 * event log table.  This is where event data is stored.
 * note that in this table we reference many of our string typed values by
 * integer (id) references to the appropriate string tables.
 */
create table log.events
(
    id       serial       not null primary key,
    key      integer      not null references log.keys (id),
    value    decimal      not null,
    tags     integer[]    not null,
    severity log.severity not null,
    created  timestamp default now()
);
call toolkit.disable_updates('log.events');
call toolkit.create_index('log.events', false, ARRAY ['key']);
call toolkit.create_index('log.events', false, ARRAY ['tags']);
call toolkit.create_index('log.events', false, ARRAY ['severity']);

call toolkit.create_trigger('log.events', 'insert', 'log.validateTags()');
