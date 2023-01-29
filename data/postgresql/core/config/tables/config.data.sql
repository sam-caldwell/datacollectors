create table config.data
(
    key     varchar(255) not null primary key,
    value   text         not null default '',
    class   config.class not null default 'clear_text',
    created timestamp             default now(),
    updated timestamp    null     default null
);
call toolkit.disable_updates('config.data');
call toolkit.addCheckConstraint('config.data','future_update',
                                'toolkit.isUpdatedAfterCreated(''config.data'', ''updated'', created)');
call toolkit.addCheckConstraint('config.data','future_created',
                                'toolkit.isTimestampFuture(created, ''config.data'', ''created'')');
call toolkit.create_index('config.data', false, ARRAY ['key']);
call toolkit.create_index('config.data', false, ARRAY ['class']);
call toolkit.create_index('config.data', false, ARRAY ['created']);
call toolkit.create_index('config.data', false, ARRAY ['updated']);
