create or replace procedure toolkit.addCheckConstraint(tbl varchar, checkName varchar, checkFuncCall varchar) as
$$
declare
    constraintName varchar := format('checkConstraint%s', toolkit.hash(concat(tbl, '_', checkName)));
begin
    execute (format('alter table %s add constraint %s check( %s );', tbl, constraintName, checkFuncCall));
end ;
$$ language plpgsql;
