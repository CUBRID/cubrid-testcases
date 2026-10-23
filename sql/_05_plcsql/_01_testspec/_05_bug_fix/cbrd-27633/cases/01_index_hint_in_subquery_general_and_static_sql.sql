-- verified the CBRD-27633
--+ server-message on

evaluate 'index hints in subqueries under HAVING / ORDER BY of general SQLs and static SQLs (the index names must keep their hint kinds)';
create table t1 (c int, d int);
create index i1 on t1 (c);
insert into t1 values (1, 10), (2, 20), (2, 21), (3, 30);

-- the subqueries return 1 (min (c) where c > 0). a subquery is not allowed in GROUP BY

-- general SQL
evaluate 'general SQL: HAVING with a subquery of USING INDEX i1(+): 2:2, 3:1';
select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 where c > 0 using index i1(+)) order by 1;
evaluate 'general SQL: HAVING with a subquery of USING INDEX i1(-): 2:2, 3:1';
select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 where c > 0 using index i1(-)) order by 1;
evaluate 'general SQL: HAVING with a subquery of USING INDEX i1: 2:2, 3:1';
select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 where c > 0 using index i1) order by 1;
evaluate 'general SQL: HAVING with a subquery of USE INDEX: 2:2, 3:1';
select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 use index (i1) where c > 0) order by 1;
evaluate 'general SQL: HAVING with a subquery of FORCE INDEX: 2:2, 3:1';
select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 force index (i1) where c > 0) order by 1;
evaluate 'general SQL: HAVING with a subquery of IGNORE INDEX: 2:2, 3:1';
select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 ignore index (i1) where c > 0) order by 1;

evaluate 'general SQL: HAVING of a derived table with a subquery of USING INDEX i1(+): 3';
select sum(m) from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > 0 using index i1(+))) d;
evaluate 'general SQL: HAVING of a derived table with a subquery of USING INDEX i1(-): 3';
select sum(m) from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > 0 using index i1(-))) d;
evaluate 'general SQL: HAVING of a derived table with a subquery of USING INDEX i1: 3';
select sum(m) from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > 0 using index i1)) d;
evaluate 'general SQL: HAVING of a derived table with a subquery of USE INDEX: 3';
select sum(m) from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 use index (i1) where c > 0)) d;
evaluate 'general SQL: HAVING of a derived table with a subquery of FORCE INDEX: 3';
select sum(m) from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 force index (i1) where c > 0)) d;
evaluate 'general SQL: HAVING of a derived table with a subquery of IGNORE INDEX: 3';
select sum(m) from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 ignore index (i1) where c > 0)) d;

evaluate 'general SQL: HAVING of a CTE with a subquery of USING INDEX i1(+): 3';
with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > 0 using index i1(+))) select sum(m) from cte;
evaluate 'general SQL: HAVING of a CTE with a subquery of USING INDEX i1(-): 3';
with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > 0 using index i1(-))) select sum(m) from cte;
evaluate 'general SQL: HAVING of a CTE with a subquery of USING INDEX i1: 3';
with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > 0 using index i1)) select sum(m) from cte;
evaluate 'general SQL: HAVING of a CTE with a subquery of USE INDEX: 3';
with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 use index (i1) where c > 0)) select sum(m) from cte;
evaluate 'general SQL: HAVING of a CTE with a subquery of FORCE INDEX: 3';
with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 force index (i1) where c > 0)) select sum(m) from cte;
evaluate 'general SQL: HAVING of a CTE with a subquery of IGNORE INDEX: 3';
with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 ignore index (i1) where c > 0)) select sum(m) from cte;

evaluate 'general SQL: ORDER BY of a derived table with a subquery of USING INDEX i1(+): 4';
select sum(m) from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 where c > 0 using index i1(+)), 1) d;
evaluate 'general SQL: ORDER BY of a derived table with a subquery of USING INDEX i1(-): 4';
select sum(m) from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 where c > 0 using index i1(-)), 1) d;
evaluate 'general SQL: ORDER BY of a derived table with a subquery of USING INDEX i1: 4';
select sum(m) from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 where c > 0 using index i1), 1) d;
evaluate 'general SQL: ORDER BY of a derived table with a subquery of USE INDEX: 4';
select sum(m) from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 use index (i1) where c > 0), 1) d;
evaluate 'general SQL: ORDER BY of a derived table with a subquery of FORCE INDEX: 4';
select sum(m) from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 force index (i1) where c > 0), 1) d;
evaluate 'general SQL: ORDER BY of a derived table with a subquery of IGNORE INDEX: 4';
select sum(m) from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 ignore index (i1) where c > 0), 1) d;

evaluate 'general SQL: ORDER BY with a subquery of an index hint: 3 rows each';
select c as k, count(*) from t1 group by k order by (select min(c) from t1 where c > 0 using index i1(+)), 1;
select c as k, count(*) from t1 group by k order by (select min(c) from t1 where c > 0 using index i1(-)), 1;
select c as k, count(*) from t1 group by k order by (select min(c) from t1 where c > 0 using index i1), 1;
select c as k, count(*) from t1 group by k order by (select min(c) from t1 use index (i1) where c > 0), 1;
select c as k, count(*) from t1 group by k order by (select min(c) from t1 force index (i1) where c > 0), 1;
select c as k, count(*) from t1 group by k order by (select min(c) from t1 ignore index (i1) where c > 0), 1;

-- static SQL (v = 0)
evaluate 'static SQL: HAVING with a subquery of USING INDEX i1(+), USING INDEX i1(-), USING INDEX i1, USE INDEX, FORCE INDEX, IGNORE INDEX and a PL/CSQL variable: 2:2, 3:1 / 2:2, 3:1 / 2:2, 3:1 / 2:2, 3:1 / 2:2, 3:1 / 2:2, 3:1';
create or replace procedure p_having as
    sr sys_refcursor;
    v int := 0;
    a int;
    b int;
begin
    open sr for select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 where c > v using index i1(+));
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
    open sr for select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 where c > v using index i1(-));
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
    open sr for select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 where c > v using index i1);
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
    open sr for select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 use index (i1) where c > v);
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
    open sr for select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 force index (i1) where c > v);
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
    open sr for select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 ignore index (i1) where c > v);
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_having();

evaluate 'static SQL: HAVING of a derived table with a subquery of USING INDEX i1(+), USING INDEX i1(-), USING INDEX i1, USE INDEX, FORCE INDEX, IGNORE INDEX and a PL/CSQL variable: 3, 3, 3, 3, 3, 3';
create or replace procedure p_dt_having as
    v int := 0;
    n int;
begin
    select sum(m) into n from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > v using index i1(+))) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > v using index i1(-))) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > v using index i1)) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 use index (i1) where c > v)) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 force index (i1) where c > v)) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 ignore index (i1) where c > v)) d;
    dbms_output.put_line(n);
end;

call p_dt_having();

evaluate 'static SQL: HAVING of a CTE with a subquery of USING INDEX i1(+), USING INDEX i1(-), USING INDEX i1, USE INDEX, FORCE INDEX, IGNORE INDEX and a PL/CSQL variable: 3, 3, 3, 3, 3, 3';
create or replace procedure p_cte_having as
    v int := 0;
    n int;
begin
    with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > v using index i1(+)))
    select sum(m) into n from cte;
    dbms_output.put_line(n);
    with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > v using index i1(-)))
    select sum(m) into n from cte;
    dbms_output.put_line(n);
    with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > v using index i1))
    select sum(m) into n from cte;
    dbms_output.put_line(n);
    with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 use index (i1) where c > v))
    select sum(m) into n from cte;
    dbms_output.put_line(n);
    with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 force index (i1) where c > v))
    select sum(m) into n from cte;
    dbms_output.put_line(n);
    with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 ignore index (i1) where c > v))
    select sum(m) into n from cte;
    dbms_output.put_line(n);
end;

call p_cte_having();

evaluate 'static SQL: ORDER BY of a derived table with a subquery of USING INDEX i1(+), USING INDEX i1(-), USING INDEX i1, USE INDEX, FORCE INDEX, IGNORE INDEX and a PL/CSQL variable: 4, 4, 4, 4, 4, 4';
create or replace procedure p_dt_order_by as
    v int := 0;
    n int;
begin
    select sum(m) into n from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 where c > v using index i1(+)), 1) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 where c > v using index i1(-)), 1) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 where c > v using index i1), 1) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 use index (i1) where c > v), 1) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 force index (i1) where c > v), 1) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 ignore index (i1) where c > v), 1) d;
    dbms_output.put_line(n);
end;

call p_dt_order_by();


drop procedure p_having;
drop procedure p_dt_having;
drop procedure p_cte_having;
drop procedure p_dt_order_by;

drop table t1;

--+ server-message off
