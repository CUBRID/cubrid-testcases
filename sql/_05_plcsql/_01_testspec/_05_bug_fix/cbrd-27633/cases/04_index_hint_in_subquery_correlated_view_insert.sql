-- verified the CBRD-27633
--+ server-message on

evaluate 'index hints in subqueries under HAVING: correlated subqueries, views, INSERT ... SELECT and nested subqueries';
create table t1 (c int, d int);
create index i1 on t1 (c);
insert into t1 values (1, 10), (2, 20), (2, 21), (3, 30);
create table t2 (c int, n int);

evaluate 'a correlated subquery with FORCE INDEX in HAVING (o.c refers to the outer query): 1:1, 2:2, 3:1';
select o.c, count(*) from t1 o group by o.c
    having count(*) >= (select count(*) from t1 i force index (i1) where i.c = o.c and i.c > 0) order by 1;

evaluate 'the same without the index hint: 1:1, 2:2, 3:1';
select o.c, count(*) from t1 o group by o.c
    having count(*) >= (select count(*) from t1 i where i.c = o.c) order by 1;

evaluate 'static SQL: a correlated subquery with FORCE INDEX and a PL/CSQL variable in HAVING: 6 (1 + 2 + 3)';
create or replace procedure p_corr as
    v int := 0;
    n int;
begin
    select sum(k) into n from (select o.c k from t1 o group by o.c
        having count(*) >= (select count(*) from t1 i force index (i1) where i.c = o.c and i.c > v)) z;
    dbms_output.put_line(n);
end;

call p_corr();

evaluate 'a view with a subquery of USING INDEX i1(+) in HAVING: 2:2, 3:1';
create view v1 as select c as k, count(*) m from t1 group by c
    having c > (select min(c) from t1 where c > 0 using index i1(+));
select * from v1 order by 1;

evaluate 'INSERT ... SELECT with a subquery of IGNORE INDEX in HAVING: 2 rows inserted (2:2, 3:1)';
insert into t2 select c, count(*) from t1 group by c
    having c > (select min(c) from t1 ignore index (i1) where c > 0);
select * from t2 order by 1;
delete from t2;

evaluate 'static SQL: INSERT ... SELECT with a subquery of USE INDEX and a PL/CSQL variable in HAVING: 2 rows inserted (2:2, 3:1)';
create or replace procedure p_ins as
    v int := 0;
begin
    insert into t2 select c, count(*) from t1 group by c
        having c > (select min(c) from t1 use index (i1) where c > v);
    dbms_output.put_line(sql%rowcount);
end;

call p_ins();
select * from t2 order by 1;

evaluate 'a subquery with USING INDEX i1(+) in HAVING of a derived table in a subquery in HAVING: 2:2, 3:1';
select c, count(*) from t1 group by c
    having c > (select min(x) from (select c as x from t1 group by c
                                    having count(*) >= (select count(*) from t1 where c > 5 using index i1(+))) y)
    order by 1;


drop procedure p_corr;
drop procedure p_ins;
drop view v1;

drop table t1;
drop table t2;

--+ server-message off
