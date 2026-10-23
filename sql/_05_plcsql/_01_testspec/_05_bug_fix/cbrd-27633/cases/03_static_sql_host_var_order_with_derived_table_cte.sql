-- verified the CBRD-27633
--+ server-message on

evaluate 'PL/CSQL variables converted to host variables in a derived table / a CTE before the ones of the outer query';
create table t1 (c int, d int);
insert into t1 values (1, 10), (2, 20), (2, 21), (3, 30);

-- v_lo = 2, v_cnt = 1, v_add = 100. swapping any two of them gives a different result
evaluate 'a variable in the select list, HAVING of a derived table and WHERE of the outer query: 103';
create or replace procedure p_dt as
    v_lo int := 2;
    v_cnt int := 1;
    v_add int := 100;
    n int;
begin
    select sum(m) + v_add into n
        from (select c as k, count(*) m from t1 group by k having k >= v_lo) d
        where d.m >= v_cnt;
    dbms_output.put_line(n);
end;

call p_dt();

evaluate 'the same with a CTE: 103';
create or replace procedure p_cte as
    v_lo int := 2;
    v_cnt int := 1;
    v_add int := 100;
    n int;
begin
    with cte as (select c as k, count(*) m from t1 group by k having k >= v_lo)
    select sum(m) + v_add into n from cte where m >= v_cnt;
    dbms_output.put_line(n);
end;

call p_cte();

evaluate 'variables in WHERE and HAVING of a derived table, and WHERE of the outer query: 2:2';
create or replace procedure p_dt_both as
    sr sys_refcursor;
    v_c int := 1;
    v_lo int := 2;
    v_cnt int := 1;
    v_max int := 3;
    a int;
    b int;
begin
    open sr for select k, sum(m) s from (select c as k, count(*) m from t1 where c >= v_c group by k having k >= v_lo) d
        where d.m >= v_cnt and d.k < v_max group by k;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_dt_both();


drop procedure p_dt;
drop procedure p_cte;
drop procedure p_dt_both;

drop table t1;

--+ server-message off
