create or replace procedure create_0000_create_extension_uuid() as
$$
begin
    raise notice 'create_0000_create_extension_uuid() starting';
    create extension if not exists "uuid-ossp";
end
$$ language plpgsql;
