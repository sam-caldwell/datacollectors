/*
 * Test config.set()
 */
do
$$
    declare
        ts timestamp:=now();
    begin
        raise notice 'test: config.get() starting';
        call config.set('testConfigSetA','valueA');
        call config.set('testConfigSetB','valueB');
        call config.set('testConfigSetC',ts);
        call config.set('testConfigSetD',1048576);
        call config.set('testConfigSetE',3.141529);
        call config.set('testConfigSetF',true);
        call config.set('testConfigSetG',false);


        if (select value from config.data where key='testConfigSetA')<>'valueA' then
            raise exception 'set() failed to set valueA';
        end if;

        if (select value from config.data where key='testConfigSetB')<>'valueB' then
            raise exception 'set() failed to set valueB';
        end if;

        if (select value from config.data where key='testConfigSetC')<>format('%s',ts) then
            raise exception 'set() failed to set time value';
        end if;

        if (select value from config.data where key='testConfigSetD')<>format('%s',1048576) then
            raise exception 'set() failed to set integer value';
        end if;

        if (select value from config.data where key='testConfigSetE')<>format('%s',3.141529) then
            raise exception 'set() failed to set decimal value';
        end if;

        if (select value from config.data where key='testConfigSetF')<>'true' then
            raise exception 'set() failed to set boolean (true) value';
        end if;

        if (select value from config.data where key='testConfigSetG')<>'false' then
            raise exception 'set() failed to set boolean (false) value';
        end if;

        raise notice 'test: config.set() passed';
    end
$$ language plpgsql;
