/*
 * create_enum() will create an enumerated data type.
 */
create or replace procedure toolkit.create_enum(name text, elements text[]) as
$$
declare
--     e1 varchar[]:=ARRAY[(select concat('''',n,'''') from unnest(elements) as n)];
    e2  varchar := '''' || array_to_string(elements, ''',''') || '''';
    sql varchar := format('create type %s as enum (%s);', name, e2);
begin
    if (select 1 from pg_type where typname = name) then
        raise notice 'type: %...exists', name;
    else
        execute sql;
    end if;
end
$$ language plpgsql;
