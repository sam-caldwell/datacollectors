/**
  Identify the offense history of an associated offender.
 */
create or replace procedure create_0060_table_offense_history() AS
$$
begin
    create table if not exists offense_history
    (
        id            serial        not null primary key,
        sid           integer       not null references roster (sid),
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
    call create_index('offense_history',  false, ARRAY[ 'offense_date']);
    call create_index('offense_history',  false, ARRAY[ 'offense']);
    call create_index('offense_history',  false, ARRAY[ 'sentence_date']);
    call create_index('offense_history',  false, ARRAY[ 'county']);
    call create_index('offense_history',   false, ARRAY['sentence']);
end
$$ language plpgsql;
