-- verified the CBRD-27633
--+ server-message on

evaluate 'index hints listing several indexes in subqueries under HAVING / ORDER BY of general SQLs and static SQLs (each index name must keep its own hint kind)';
create table t1 (c int, d int);
create index ia on t1 (c);
create index ib on t1 (c, d);
create index ic on t1 (d);
insert into t1 values (1, 10), (2, 20), (2, 21), (3, 30);
update statistics on t1 with fullscan;

-- the subqueries return 1 (min (c) where c > 0 and d > 0). the index names have no digits, since CTP masks digits in query plans
-- USING INDEX ia(-), ib, ic(+) mixes the three hint kinds of a name. USING INDEX ALL EXCEPT ia, ib leaves only ic:
-- the plan of its subquery scans ic, which shows that both names keep the ALL EXCEPT kind

-- general SQL
evaluate 'general SQL: HAVING with a subquery of USING INDEX ia(-), ib, ic(+): 2:2, 3:1';
--@queryplan
select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 where c > 0 and d > 0 using index ia(-), ib, ic(+)) order by 1;
evaluate 'general SQL: HAVING with a subquery of USING INDEX ALL EXCEPT ia, ib: 2:2, 3:1 (the subquery scans ic)';
--@queryplan
select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 where c > 0 and d > 0 using index all except ia, ib) order by 1;

evaluate 'general SQL: HAVING of a derived table with a subquery of USING INDEX ia(-), ib, ic(+) / ALL EXCEPT ia, ib: 3, 3';
select sum(m) from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > 0 and d > 0 using index ia(-), ib, ic(+))) d;
select sum(m) from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > 0 and d > 0 using index all except ia, ib)) d;

evaluate 'general SQL: HAVING of a CTE with a subquery of USING INDEX ia(-), ib, ic(+) / ALL EXCEPT ia, ib: 3, 3';
with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > 0 and d > 0 using index ia(-), ib, ic(+))) select sum(m) from cte;
with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > 0 and d > 0 using index all except ia, ib)) select sum(m) from cte;

evaluate 'general SQL: ORDER BY of a derived table with a subquery of USING INDEX ia(-), ib, ic(+) / ALL EXCEPT ia, ib: 4, 4';
select sum(m) from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 where c > 0 and d > 0 using index ia(-), ib, ic(+)), 1) d;
select sum(m) from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 where c > 0 and d > 0 using index all except ia, ib), 1) d;

evaluate 'general SQL: ORDER BY with a subquery of USING INDEX ia(-), ib, ic(+) / ALL EXCEPT ia, ib: 3 rows each';
select c as k, count(*) from t1 group by k order by (select min(c) from t1 where c > 0 and d > 0 using index ia(-), ib, ic(+)), 1;
select c as k, count(*) from t1 group by k order by (select min(c) from t1 where c > 0 and d > 0 using index all except ia, ib), 1;

-- static SQL (v = 0)
evaluate 'static SQL: HAVING with a subquery of USING INDEX ia(-), ib, ic(+) / ALL EXCEPT ia, ib and a PL/CSQL variable: 2:2, 3:1 / 2:2, 3:1';
create or replace procedure p_having as
    sr sys_refcursor;
    v int := 0;
    a int;
    b int;
begin
    open sr for select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 where c > v and d > v using index ia(-), ib, ic(+)) order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
    open sr for select c as k, count(*) cnt from t1 group by k having k > (select min(c) from t1 where c > v and d > v using index all except ia, ib) order by 1;
    loop
        fetch sr into a, b;
        exit when sr%notfound;
        dbms_output.put_line(a || ':' || b);
    end loop;
    close sr;
end;

call p_having();

evaluate 'static SQL: HAVING of a derived table and of a CTE, ORDER BY of a derived table with a subquery of USING INDEX ia(-), ib, ic(+) / ALL EXCEPT ia, ib and a PL/CSQL variable: 3, 3, 3, 3, 4, 4';
create or replace procedure p_dt_cte as
    v int := 0;
    n int;
begin
    select sum(m) into n from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > v and d > v using index ia(-), ib, ic(+))) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > v and d > v using index all except ia, ib)) d;
    dbms_output.put_line(n);
    with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > v and d > v using index ia(-), ib, ic(+)))
    select sum(m) into n from cte;
    dbms_output.put_line(n);
    with cte as (select c as k, count(*) m from t1 group by k having k > (select min(c) from t1 where c > v and d > v using index all except ia, ib))
    select sum(m) into n from cte;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 where c > v and d > v using index ia(-), ib, ic(+)), 1) d;
    dbms_output.put_line(n);
    select sum(m) into n from (select c as k, count(*) m from t1 group by k order by (select min(c) from t1 where c > v and d > v using index all except ia, ib), 1) d;
    dbms_output.put_line(n);
end;

call p_dt_cte();


drop procedure p_having;
drop procedure p_dt_cte;

drop table t1;

--+ server-message off
