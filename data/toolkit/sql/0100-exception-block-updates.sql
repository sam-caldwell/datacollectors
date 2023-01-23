/*
 * This function will throw an exception when executed by a trigger.
 * When updates are blocked on a table, this function is used to
 * enforce the block.
 */
create or replace function toolkit.exception_block_updates() RETURNS trigger AS
$$
begin
    raise exception 'update operation is blocked';
end
$$ language plpgsql;
