create table if not exists config.expiration
(
    key        varchar(255) not null primary key references config.data (key),
    expiration timestamp    not null,
    created    timestamp    not null default now()
);
/*
 * We will only insert or delete a record in config.expiration, but
 * we will never update a row.
 */
call toolkit.disable_updates('config.expiration');
/*
 * Each record with a created timestamp must be after the
 * other records in the table.
 */
call toolkit.addCheckConstraint('config.expiration',
                                'future_created',
                                toolkit.callCheckFunc('toolkit.isTimestampFuture',
                                                      'created',
                                                      'config.expiration',
                                                      'created'));
/*
 * Our expiration must always be at some point after the created timestamp.
 */
call toolkit.addCheckConstraint('config.data', 'updated_after_creation',
                                toolkit.callCheckFunc('toolkit.isUpdatedAfterCreated',
                                                      'config.data',
                                                      'expiration',
                                                      'created'));
