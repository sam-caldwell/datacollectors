/*
 * the keys table allows us to create a finite set of keys and reference them
 * multiple times with the key 'id' (integer).
 *
 * A 'key' in this context is the event name in log.events.
 */
DO
$$
    begin
        create table if not exists log.keys
        (
            id      serial    not null primary key,
            key     varchar(255)   not null unique,
            created timestamp not null default now()
        );
        call toolkit.disable_updates('log.keys');
    end
$$ language plpgsql;
