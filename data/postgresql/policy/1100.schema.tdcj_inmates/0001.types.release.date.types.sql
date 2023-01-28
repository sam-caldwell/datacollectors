/*
    Various types of release dates TDCJ reports
 */
create or replace procedure create_0001_types_date_types() AS
$$
begin
    if (select 1 from pg_type where typname = 'ReleaseDateTypes') then
        raise notice 'type: ReleaseDateTypes...created';
    else
        call create_type('ReleaseDateTypes',
            ARRAY[
                'ParoleEligibility',
                'ProjectedRelease',
                'MaximumSentenceDate']);
    end if;
end
$$ language plpgsql;
