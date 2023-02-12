create table if not exists scraped.content_type
(
    id      serial       not null primary key,
    name    varchar(255) not null unique,
    created timestamp    not null default now()
);