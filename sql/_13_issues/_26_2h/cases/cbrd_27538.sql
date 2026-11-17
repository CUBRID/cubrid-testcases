-- CBRD-27538: CREATE VIEW / ALTER VIEW with a WITH clause (CTE) failed with Unknown class
drop view if exists v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, cte;
drop table if exists t, tx;

create table t (c int, d varchar(10));
insert into t values (1, 'a'), (2, 'b'), (3, 'c');

-- top-level WITH
create view v1 as with cte as (select c from t) select c from cte;
select * from v1 order by 1;

-- WITH RECURSIVE with a column list
create view v2 as with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 3) select n from cte;
select * from v2 order by 1;

-- WITH in a derived table, IN subquery and scalar subquery
create view v3 as select * from (with cte as (select c from t) select c from cte) x;
select * from v3 order by 1;
create view v4 as select c from t where c in (with cte as (select c from t where c > 1) select c from cte);
select * from v4 order by 1;
create view v5 as select c, (with cte as (select max(c) m from t) select m from cte) mx from t;
select * from v5 order by 1;

-- ORDER BY and LIMIT
create view v6 as with cte as (select c, d from t) select c, d from cte order by c desc limit 2;
select * from v6;

-- UNION ALL with a WITH clause is kept as one query spec
create view v7 as with cte as (select c from t) select c from cte where c = 1 union all select c from cte where c = 3;
select * from v7 order by 1;
select * from (select * from v7 where c > 1) x;

-- materialized CTE, several CTEs, view attributes
create view v8 as with cte as (select /*+ materialize */ c from t) select a.c from cte a, cte b where a.c = b.c;
select * from v8 order by 1;
create view v9 (x, y) as with c1 as (select c, d from t), c2 as (select c + 10 c, d from c1) select c, d from c2;
select * from v9 order by 1;
select * from v9 a, v2 b where a.x - 10 = b.n order by 1;

-- a view whose WITH clause remains (materialized, recursive) referenced twice, and a view on CTE views
select * from v8 a, v8 b where a.c = b.c order by 1;
select * from v2 a, v2 b where a.n = b.n order by 1;
create view v10 as select a.c, b.n from v1 a, v2 b where a.c = b.n;
select * from v10 order by 1;

-- a view with a WITH clause is not updatable
update v1 set c = 0;
delete from v1 where c = 1;
insert into v1 values (4);
select * from t order by 1;

-- a view having the same name as its CTE
create view cte as with cte as (select c from t) select c from cte;
select * from cte order by 1;

-- ALTER VIEW, CREATE OR REPLACE VIEW, ADD QUERY, CHANGE QUERY
alter view v1 as with cte as (select c + 10 c from t) select c from cte;
select * from v1 order by 1;
create or replace view v1 as with cte as (select c + 100 c from t) select c from cte;
select * from v1 order by 1;
alter view v1 add query with cte as (select c + 1000 c from t) select c from cte;
select * from v1 order by 1;
alter view v1 change query 2 with cte as (select c + 10000 c from t) select c from cte;
select * from v1 order by 1;

-- CREATE TABLE ... AS WITH (already worked)
create table tx as with cte as (select c from t) select c from cte;
select * from tx order by 1;

-- errors are still reported
create view verr as with cte as (select c from t), cte as (select c from t) select c from cte;
create view verr as with cte as (select c from no_such_table) select c from cte;

drop view v10, v1, v2, v3, v4, v5, v6, v7, v8, v9, cte;
drop table t, tx;
