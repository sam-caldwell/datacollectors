create or replace procedure create_0531_func_add_offense_history() as
$$
begin
    create or replace function add_offense_history(sid integer, offense_date timestamp, offense varchar(1024),
                                                   sentence_date timestamp, county varchar(255),
                                                   case_number varchar(255),
                                                   sentence varchar(12)) returns boolean AS
    $_$
    begin
        insert into offense_history (sid, offense_date, offense, sentence_date, county, case_number, sentence)
        values (sid, offense_date, offense, sentence_date, county, case_number, sentence)
        on conflict do nothing;
    end
    $_$ language plpgsql;
end
$$ language plpgsql;