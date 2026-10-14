-- verified the CBRD-27556

evaluate 'aliases of the select list in GROUP BY / HAVING of derived tables and CTEs (not a static SQL)';
create table t1 (c int, d int);
insert into t1 values (1, 10), (2, 20), (2, 21), (3, 30);
create table t2 (c int);
insert into t2 values (1), (2);

evaluate 'an alias of a column and of an aggregate in HAVING of a derived table: 3 (groups k = 2, 3), 2 (the group c = 2)';
select sum(m) from (select c as k, count(*) m from t1 group by k having k > 1) d;
select sum(m) from (select c as k, count(*) m from t1 group by c having m > 1) d;

evaluate 'an alias in HAVING of a nested derived table: 3';
select sum(m) from (select * from (select c as k, count(*) m from t1 group by k having k > 1) d1) d2;

evaluate 'an alias in HAVING of a correlated derived table: (1, 3), (2, 1)';
select c, (select sum(m) from (select c as k, count(*) m from t1 group by k having k > t2.c) d) from t2 order by 1;

evaluate 'an alias in HAVING of a CTE: 3';
with w as (select c as k, count(*) m from t1 group by k having k > 1) select sum(m) from w;

evaluate 'an alias in HAVING of the non-recursive part of a recursive CTE: 3 rows';
with recursive w (x) as (select max(c) as mx from t1 having mx > 0 union all select x - 1 from w where x > 1)
select count(*) from w;

evaluate 'an alias in GROUP BY / HAVING of the recursive part of a recursive CTE: (1, 1), (2, 1)';
with recursive w (x, y) as (
    select c, count(*) from t1 group by c having c = 1
    union all
    select x + 1 as nx, y from w where x < 3 group by nx, y having nx < 3)
select * from w order by 1;

evaluate 'a column with the same name as an alias wins in a derived table: 4 (grouped by t1.c)';
select sum(m) from (select d as c, count(*) m from t1 group by c) d;

evaluate 'a view with an alias in HAVING of a derived table: 3';
create view v1 as select sum(m) s from (select c as k, count(*) m from t1 group by k having k > 1) d;
select * from v1;
drop view v1;

evaluate 'a name which is neither a column nor an alias in HAVING of a derived table: zz is not defined';
select sum(m) from (select c as k, count(*) m from t1 group by k having zz > 1) d;


drop table t1;
drop table t2;
