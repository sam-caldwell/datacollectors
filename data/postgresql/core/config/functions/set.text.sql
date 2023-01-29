create or replace procedure config.set(_key varchar,
                                       _value text,
                                       expires_in interval default null,
                                       encrypted boolean default false) as
$$
declare
    stored_class config.class;
    stored_value varchar;
begin
    if encrypted then
        stored_value := encrypt(_value);
        stored_class := 'encrypted';
    else
        stored_value := _value;
        stored_class := 'clear';
    end if;

    insert into config.data(key,
                            value,
                            updated,
                            class)
    values (_key,
            stored_value,
            now(),
            stored_class)
    on conflict (key)
        do update
        set value=stored_value,
            class=stored_class,
            updated=now();

    if expires_in is not null then
        call config.setExpiration(_key, expires_in);
    end if;
end
$$ language plpgsql;