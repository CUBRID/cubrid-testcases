-- verified the CBRD-27633
--+ server-message on

evaluate 'aliases in ORDER BY of derived tables and CTEs, and in GROUP BY / HAVING of each branch of a UNION derived table';
create table t1 (c int, d int);
insert into t1 values (1, 10), (2, 20), (2, 21), (3, 30);

-- c + d: 11, 22, 23, 33
evaluate 'an alias in ORDER BY of a derived table: 56 (33 + 23)';
select sum(s) from (select c + d as s from t1 order by s desc limit 2) z;

evaluate 'an alias in an expression of ORDER BY of a derived table: 56 (33 + 23)';
select sum(s) from (select c + d as s from t1 order by s * -1 limit 2) z;

-- groups of c: (1, 1), (2, 2), (3, 1)
evaluate 'aliases of a column and of an aggregate in GROUP BY / ORDER BY of a derived table: (2, 2)';
select k, m from (select c as k, count(*) m from t1 group by k order by m desc, k limit 1) z;

evaluate 'an alias in ORDER BY of a CTE: 33 (11 + 22)';
with w as (select c + d as s from t1 order by s limit 2) select sum(s) from w;

-- the first branch: k = 2 (2 rows), k = 3 (1 row). the second branch: k = 21 (1 row), k = 30 (1 row)
evaluate 'aliases in GROUP BY / HAVING of each branch of a UNION ALL derived table: 5';
select sum(m) from (select c as k, count(*) m from t1 group by k having k > 1
                    union all
                    select d as k, count(*) m from t1 group by k having k > 20) z;

-- the first branch: 1, 2, 3. the second branch (d - 18 > 0): 2, 3, 12
evaluate 'aliases in GROUP BY / HAVING of each branch of a UNION derived table: (4, 18) for 1, 2, 3, 12';
select count(*), sum(k) from (select c as k from t1 group by k
                              union
                              select d - 18 as k from t1 group by k having k > 0) z;

evaluate 'aliases in GROUP BY / HAVING of each branch of a UNION ALL CTE: 5';
with w as (select c as k, count(*) m from t1 group by k having k > 1
           union all
           select d as k, count(*) m from t1 group by k having k > 20)
select sum(m) from w;

-- c > 1: 22, 23, 33
evaluate 'Static SQL: an alias and a PL/CSQL variable in ORDER BY of a derived table: 56 (33 + 23)';
create or replace procedure p_order_by as
    v_lo int := 1;
    v_sign int := -1;
    n int;
begin
    select sum(s) into n from (select c + d as s from t1 where c > v_lo order by s * v_sign limit 2) z;
    dbms_output.put_line(n);
end;

call p_order_by();

evaluate 'Static SQL: the same with a CTE: 56 (33 + 23)';
create or replace procedure p_order_by_cte as
    v_lo int := 1;
    v_sign int := -1;
    n int;
begin
    with w as (select c + d as s from t1 where c > v_lo order by s * v_sign limit 2)
    select sum(s) into n from w;
    dbms_output.put_line(n);
end;

call p_order_by_cte();

evaluate 'Static SQL: aliases and PL/CSQL variables in GROUP BY / HAVING of each branch of a UNION ALL derived table: 5';
create or replace procedure p_union as
    v_lo int := 1;
    v_hi int := 20;
    n int;
begin
    select sum(m) into n from (select c as k, count(*) m from t1 group by k having k > v_lo
                               union all
                               select d as k, count(*) m from t1 group by k having k > v_hi) z;
    dbms_output.put_line(n);
end;

call p_union();

evaluate 'Static SQL: the same with a UNION CTE: (4, 18) for 1, 2, 3, 12';
create or replace procedure p_union_cte as
    v_lo int := 0;
    v_sub int := 18;
    a int;
    b int;
begin
    with w as (select c as k from t1 group by k having k > v_lo
               union
               select d - v_sub as k from t1 group by k having k > v_lo)
    select count(*), sum(k) into a, b from w;
    dbms_output.put_line(a || ', ' || b);
end;

call p_union_cte();

drop procedure p_order_by;
drop procedure p_order_by_cte;
drop procedure p_union;
drop procedure p_union_cte;
drop table t1;

--+ server-message off
