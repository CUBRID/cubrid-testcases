-- verified the CBRD-27556
--+ server-message on

evaluate 'aliases and PL/CSQL variables in GROUP BY / HAVING / ORDER BY of derived tables and CTEs of a static SQL';
create table t1 (c int, d int);
insert into t1 values (1, 10), (2, 20), (2, 21), (3, 30);

evaluate 'a PL/CSQL variable as an operand or a non-aggregate function argument in HAVING of a derived table: 4, 4, 4, 4';
create or replace procedure p_dt_having as
    v int := 1;
    n int;
begin
    select m into n from (select count(*) m from t1 having v > 0) d;
    dbms_output.put_line(n);
    select m into n from (select count(*) m from t1 having abs(v) > 0) d;
    dbms_output.put_line(n);
    select m into n from (select count(*) m from t1 having v + 1 > 0) d;
    dbms_output.put_line(n);
    select m into n from (select count(*) m from t1 having avg(v) > 0) d;
    dbms_output.put_line(n);
end;

call p_dt_having();

evaluate 'GROUP BY with a PL/CSQL variable in HAVING of a derived table: 2 (the count of the group c = 2)';
create or replace procedure p_dt_group as
    v int := 1;
    n int;
begin
    select sum(m) into n from (select c, count(*) m from t1 group by c having count(*) > v) d;
    dbms_output.put_line(n);
end;

call p_dt_group();

evaluate 'an alias in GROUP BY / HAVING of a derived table with a PL/CSQL variable: 3 (groups k = 2, 3), 71 (groups of sum 41, 30)';
create or replace procedure p_dt_alias as
    v int := 1;
    n int;
begin
    select sum(m) into n from (select c as k, count(*) m from t1 group by k having k > v) d;
    dbms_output.put_line(n);
    select sum(s) into n from (select c as k, sum(d) s from t1 group by k having s > v * 20) d;
    dbms_output.put_line(n);
end;

call p_dt_alias();

evaluate 'a nested derived table: 4 (all groups)';
create or replace procedure p_dt_nested as
    v int := 1;
    n int;
begin
    select sum(m) into n from (select * from (select c as k, count(*) m from t1 group by k having v > 0) d1) d2;
    dbms_output.put_line(n);
end;

call p_dt_nested();

evaluate 'a PL/CSQL variable in ORDER BY of a derived table: 8 (all rows)';
create or replace procedure p_dt_order as
    v int := 1;
    n int;
begin
    select sum(c) into n from (select c from t1 order by abs(c - v)) d;
    dbms_output.put_line(n);
end;

call p_dt_order();

evaluate 'a PL/CSQL variable and an alias in HAVING of a CTE: 4, 3 (groups k = 2, 3)';
create or replace procedure p_cte as
    v int := 1;
    n int;
begin
    with w as (select count(*) m from t1 having v > 0) select m into n from w;
    dbms_output.put_line(n);
    with w as (select c as k, count(*) m from t1 group by k having k > v) select sum(m) into n from w;
    dbms_output.put_line(n);
end;

call p_cte();

evaluate 'a PL/CSQL variable in HAVING of the non-recursive part of a recursive CTE: 3 rows (3, 2, 1)';
create or replace procedure p_cte_recursive as
    v int := 1;
    n int;
begin
    with recursive w (x) as (select max(c) from t1 having v > 0 union all select x - 1 from w where x > v)
        select count(*) into n from w;
    dbms_output.put_line(n);
end;

call p_cte_recursive();

evaluate 'the same queries out of PL/CSQL';
select m from (select count(*) m from t1 having 1 > 0) d;
select m from (select count(*) m from t1 having abs(1) > 0) d;
select sum(m) from (select c, count(*) m from t1 group by c having count(*) > 1) d;
select sum(c) from (select c from t1 order by abs(c - 1)) d;
with w as (select count(*) m from t1 having 1 > 0) select m from w;


drop procedure p_dt_having;
drop procedure p_dt_group;
drop procedure p_dt_alias;
drop procedure p_dt_nested;
drop procedure p_dt_order;
drop procedure p_cte;
drop procedure p_cte_recursive;

drop table t1;

--+ server-message off
