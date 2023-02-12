/*
    Indicates times when inmate was eligible for visitation
 */
create or replace procedure create_0090_table_visitation_eligibility() AS
$$
begin
    create table if not exists visitation_eligibility
    (
        id         serial    not null primary key,
        sid        integer   not null references roster (sid),
        eligible   varchar(255),
        note_setId uuid      null     default null references note_set (id),
        created    timestamp not null default now(),
        constraint createdAfterProjectStart check (created > '01-01-2023')
    );
    call create_index('visitation_eligibility', false, ARRAY['eligible']);
    call create_index('visitation_eligibility', false, ARRAY['created']);
end
$$ language plpgsql;
