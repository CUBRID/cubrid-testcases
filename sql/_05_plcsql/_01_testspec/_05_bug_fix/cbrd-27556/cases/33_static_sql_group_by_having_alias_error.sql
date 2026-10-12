-- verified the CBRD-27556
-- a name in GROUP BY / HAVING of a static SQL which is neither a column, an alias nor a PL/CSQL variable.

--+ server-message on

drop table if exists t1;
create table t1 (c int, d int);
insert into t1 values (1, 10), (2, 20), (2, 21), (3, 30);

-- error: undeclared id ZZ
create or replace procedure p_unknown_name_in_having as
    sr sys_refcursor;
begin
    open sr for select c as k, count(*) from t1 group by k having zz > 1;
    close sr;
end;

-- error: ... can not be a GROUP BY column
-- (a name which is neither a column nor an alias is taken as a PL/CSQL variable, and a host variable can not be a GROUP BY column)
create or replace procedure p_unknown_name_in_group_by as
    sr sys_refcursor;
begin
    open sr for select c as k, count(*) from t1 group by zz;
    close sr;
end;

-- the same SQLs out of PL/CSQL
select c as k, count(*) from t1 group by k having zz > 1;
select c as k, count(*) from t1 group by zz;

drop table t1;

--+ server-message off
