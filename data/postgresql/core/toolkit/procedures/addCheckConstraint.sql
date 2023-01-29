create or replace procedure toolkit.addCheckConstraint(tbl varchar, checkName varchar, checkFuncCall varchar) as
$$
declare
    constraintName varchar := format('checkConstraint%s', toolkit.hash(concat(tbl, '_', checkName)));
begin
    execute (
            format('alter table %s ', tbl) ||
            format('add constraint %s check( %s );', constraintName, checkFuncCall)
        );
end ;
$$ language plpgsql;
