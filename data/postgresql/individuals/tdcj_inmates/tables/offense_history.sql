create table if not exists tdcj_inmates.offense_history
(
    id            serial        not null primary key,
    sid           integer       not null references people.tx_sid(id),
    offense_date  timestamp     not null,
    offense       varchar(1024) not null,
    sentence_date timestamp     null     default null,
    county        varchar(255)  not null,
    case_number   varchar(255)  not null,
    sentence      varchar(12)   not null,
    created       timestamp     not null default now(),
    updated       timestamp     null     default null,
    constraint createdAfterProjectStart check (created > '01-01-2023'),
    constraint updatedAfterCreated check (updated > created),
    constraint sentence_after_offense check (sentence_date > offense_date)
);
call toolkit.disable_updates('tdcj_inmates.offense_history');
call toolkit.create_index('tdcj_inmates.offense_history',  false, ARRAY[ 'offense_date']);
call toolkit.create_index('tdcj_inmates.offense_history',  false, ARRAY[ 'offense']);
call toolkit.create_index('tdcj_inmates.offense_history',  false, ARRAY[ 'sentence_date']);
call toolkit.create_index('tdcj_inmates.offense_history',  false, ARRAY[ 'county']);
call toolkit.create_index('tdcj_inmates.offense_history',   false, ARRAY['sentence']);
