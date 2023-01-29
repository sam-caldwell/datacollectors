create or replace procedure toolkit.deleteCheckConstraint(tbl varchar, checkName varchar) as
$$
declare
    constraintName varchar := format('checkConstraint%s', toolkit.hash(concat(tbl, '_', checkName)));
begin
    execute (format('alter table %s drop constraint %s;', tbl, constraintName));
end;
$$ language plpgsql;
