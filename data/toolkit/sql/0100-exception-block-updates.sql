create or replace function toolkit.exception_block_updates() RETURNS trigger AS
$$
begin
    raise exception 'update operation is blocked';
end
$$ language plpgsql;
