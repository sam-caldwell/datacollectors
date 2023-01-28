/*
 * This function will throw an exception when executed by a trigger.
 * When updates are blocked on a table, this function is used to
 * enforce the block.
 */
create or replace function exception.block_updates() RETURNS trigger AS
$$
begin
    raise exception using
        errcode = 'UPDATE_BLOCKED',
        message = 'update operation is blocked',
        hint = 'update is blocked on table';
end
$$ language plpgsql;
