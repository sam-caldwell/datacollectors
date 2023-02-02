/*
    This table captures the raw data scraped by the stage1 screen scraper
    task.  This raw data is the HTML scraped as-is from the server.
 */
create or replace procedure create_0020_table_stage1_raw() as
$$
begin
    create table if not exists stage1_raw
    (
        id serial not null primary key,
        content text not null,
        created timestamp not null default now(),
        constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call disable_updates('stage1_raw');
    call create_index('stage1_raw',false, ARRAY['created']);
end;
$$ language plpgsql;