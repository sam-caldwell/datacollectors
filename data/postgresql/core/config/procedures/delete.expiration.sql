create or replace procedure config.deleteExpiration(_key varchar) as
$$
begin
    delete from config.expiration where key=key;
end
$$ language plpgsql;