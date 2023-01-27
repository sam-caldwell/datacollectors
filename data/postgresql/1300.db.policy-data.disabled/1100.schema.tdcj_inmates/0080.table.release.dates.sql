/*
    release dates table (metadata)
 */
create or replace procedure create_0080_table_release_dates() AS
$$
begin
    create table if not exists release_dates
    (
        id       serial           not null primary key,
        sid      integer          not null references roster (sid),
        dateType ReleaseDateTypes not null,
        date     timestamp        not null,
        created  timestamp        not null default now()
            constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call create_index('release_dates',   false, ARRAY['dateType']);
    call create_index('release_dates',   false, ARRAY['date']);
end
$$ language plpgsql;