/*
 * The tags table provides a set of tags which can be referenced by the tag 'id'
 * for efficiency while also allowing a unique set of tags which can be quickly
 * enumerated during analysis.
 */
DO
$$
    begin
        create table if not exists log.tags
        (
            id      serial      not null primary key,
            tag     varchar(64) not null unique,
            created timestamp   not null default now()
        );
        call toolkit.disable_updates('log.tags');
        call toolkit.create_index('log.tags', false, ARRAY ['tag']);
    end
$$ language plpgsql;
