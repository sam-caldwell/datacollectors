create or replace procedure config.setExpiration(_key varchar, expires interval) as
$$
declare
    expires_in timestamp := now() + expires;
begin
    insert into config.expiration (key, expiration)
    values (_key, expires_in);
end
$$ language plpgsql;