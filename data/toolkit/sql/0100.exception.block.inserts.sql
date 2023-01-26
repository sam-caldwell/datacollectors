/*
 * This function will throw an exception when executed by a trigger.
 * When inserts are blocked on a table, this function is used to
 * enforce the block.
 */
create or replace function toolkit.exception_block_inserts() RETURNS trigger AS
$$
begin
    raise exception using
        errcode = 'INSERT_BLOCKED',
        message = 'insert operation is blocked',
        hint = 'insert is blocked on table';
end
$$ language plpgsql;
