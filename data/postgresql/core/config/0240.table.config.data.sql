/*
 * config.data is a table of key-value pairs
 *
 * Todo: add encrypted values
 * Todo: add expiring rows.
 */
DO
$$
    begin
        create table config.data
        (
            key     varchar(255) not null primary key,
            value   text         not null default '',
            created timestamp             default now(),
            updated timestamp    null     default null
        );
--         call toolkit.ensureFutureTimestamp('config.data', 'created');
--         call toolkit.ensureFutureTimestamp('config.data', 'updated');
        call toolkit.create_index('config.data', false, ARRAY ['key']);
        call toolkit.create_index('config.data', false, ARRAY ['created']);
        call toolkit.create_index('config.data', false, ARRAY ['updated']);
    end
$$ language plpgsql;