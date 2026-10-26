-- verified the CBRD-27742
evaluate 'when no column of a derived table is referenced (e.g. count(*)), its select list is reduced to a constant.';
evaluate 'the attribute list of the derived table must still be names, so that the printed tree can be parsed again.';

--+ server-message on

drop view if exists v2;
drop table if exists t2;
create table t2 (c int);
insert into t2 select rownum from db_class limit 10;
create view v2 as select c, max (c) as y from t2 group by c;

evaluate 'static SQL: a PL/CSQL variable in a derived column the outer query never references';
create or replace function f1 (v int) return int as
    n int;
begin
    select count (*) into n from (select c, max (c) + v as y from t2 group by c) z;
    return n;
end;
select f1 (1) from db_root;

evaluate 'static SQL: a derived table with no referenced column';
create or replace function f2 return int as
    n int;
begin
    select count (*) into n from (select c as x from t2 where c > 0 group by c) z;
    return n;
end;
select f2 () from db_root;

evaluate 'static SQL: a view with no referenced column';
create or replace function f3 return int as
    n int;
begin
    select count (*) into n from v2;
    return n;
end;
select f3 () from db_root;

evaluate 'static SQL: the generated name must not be the name of a column kept by ORDER BY (a_1)';
create or replace function f4 (v int) return int as
    n int;
begin
    select count (*) into n from (select c as a_1, c + v as y from t2 group by c order by a_1) z;
    return n;
end;
select f4 (1) from db_root;

evaluate 'the printed tree of an inline view and a view with no referenced column';
set trace on;
select /*+ recompile */ count (*) from (select c, max (c) as y from t2 group by c) z;
show trace;
select /*+ recompile */ count (*) from v2;
show trace;
select /*+ recompile */ count (*) from (select c as a_1 from t2 group by c order by a_1) z;
show trace;
set trace off;

drop function f1;
drop function f2;
drop function f3;
drop function f4;
drop view v2;
drop table t2;

--+ server-message off
