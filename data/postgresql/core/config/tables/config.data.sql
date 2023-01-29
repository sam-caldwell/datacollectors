create table config.data
(
    key     varchar(255) not null primary key,
    value   text         not null default '',
    class   config.class not null default 'clear',
    created timestamp             default now(),
    updated timestamp    null     default null
        constraint check_key_pattern check (key ~ '[a-zA-Z_]([\.\-\_]{0,1}[a-zA-Z0-9]+)+')
);
/*
 * We will only insert or delete a record in config.data, but
 * we will never update a row.
 */
call toolkit.disable_updates('config.data');
/*
 * each row must have a created timestamp after the other created
 * timestamps in the table.
 */
call toolkit.addCheckConstraint('config.data', 'future_created',
                                toolkit.callCheckFunc('toolkit.isTimestampFuture',
                                                      'created',
                                                      'config.data',
                                                      'created'));
/*
 * our updated timestamps must be after the associated created time.
 */
call toolkit.addCheckConstraint('config.data', 'updated_after_creation',
                                toolkit.callCheckFunc('toolkit.isUpdatedAfterCreated',
                                                      'config.data',
                                                      'updated',
                                                      'created'));
/*
 * index on our storage class.
 */
call toolkit.create_index('config.data', false, ARRAY ['class']);
/*
 * index the created timestamps
 */
call toolkit.create_index('config.data', false, ARRAY ['created']);
/*
 * index the updated timestamps
 */
call toolkit.create_index('config.data', false, ARRAY ['updated']);
