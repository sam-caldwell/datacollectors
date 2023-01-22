/*
 * Test config.get()
 */
do
$$
    declare
        ok boolean;
    begin
        raise notice 'test: config.get() starting';

        insert into config.data(key, value) values ('testA', 'valueA');
        insert into config.data(key, value) values ('testB', 'valueB');
        commit;

        if (select config.get('testA',false)) <> 'valueA' then
            raise exception 'get() test failed (A)';
        end if;

        if (select config.get('testB',false)) <> 'valueB' then
            raise exception 'get() test failed (B)';
        end if;

        if (select config.get('testC',false)) <> '' then
            raise exception 'get() not required should return nothing if not required.';
        end if;

        begin
            select config.get('testC',true);
            ok=false;
        exception when others then
            ok=true;
        end;
        if ok then
            raise notice '...passed';
        else
            raise exception '...failed';
        end if;

        /*
         * Clean up the test data
         */
        delete from config.data where key in ('testA', 'testB');

    end
$$ language plpgsql;
