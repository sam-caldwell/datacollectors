create or replace function exception.block_inserts() RETURNS trigger AS
$$
begin
    raise exception using
        errcode = 'INSERT_BLOCKED',
        message = 'insert operation is blocked',
        hint = 'insert is blocked on table';
end
$$ language plpgsql;
