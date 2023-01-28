/*
 * create_sequence()
 *    This function will create a sequence (o) with a start value (a) and
 *    and increment (i).
 */
create or replace procedure toolkit.create_sequence(o varchar, a integer, i integer) as
$$
declare
    sql varchar := format('create sequence if not exists %s start %s increment %s;', o, a, i);
begin
    execute sql;
end
$$ language plpgsql;
