create table if not exists tdcj_inmates.current_facility
(
    id         serial    not null primary key,
    sid        integer   not null references roster (sid),
    facilityId integer   not null references facilities (id),
    created    timestamp not null default now(),
    constraint createdAfterProjectStart check (created > '01-01-2023')
);
call toolkit.create_index('tdcj_inmates.current_facility',true, ARRAY['facilityId','sid']);
