/*
    Given an existing record in the roster table,
        update the record to add the collection identifier.
 */
create or replace procedure create_0531_add_inmate_roster_note() as
$$
begin
    create or replace function add_inmate_roster_note(this_sid integer, this_collection integer) RETURNS boolean AS
    $_$
    declare
        c integer := 0;
    begin
        if (select count(sid) from roster where sid = this_sid) == 1 then
            update roster
            set collection=this_collection
            where sid = this_sid;
        else
            raise exception 'A node set id cannot be added unless the record exists';
        end if;
        return true;
    end
    $_$ LANGUAGE plpgsql;
end
$$ language plpgsql;
