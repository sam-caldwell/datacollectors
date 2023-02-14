create table if not exists scraped.content
(
    id               serial    not null primary key,
    content_type     integer   not null references scraped.content_type (id),
    url              text      not null,
    request_headers  text      not null,
    response_headers text      not null,
    response_body    text      not null,
    created          timestamp not null default now(),
    processed        timestamp null
);

call toolkit.disable_update('scraped.content');
call toolkit.create_index('scraped.content', false, ARRAY ['url']);
call toolkit.create_index('scraped.content', false, ARRAY ['created']);
call toolkit.create_index('scraped.content', false, ARRAY ['processed']);
