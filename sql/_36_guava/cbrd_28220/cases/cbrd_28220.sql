-- CBRD-28220: CREATE OR REPLACE VIEW over an existing view must not crash the client
-- when the new query has a NULL-typed column (a NULL literal or a scalar subquery folded to empty)

drop view if exists v1, v2, v3, v4, v5, v6, v7;
drop table if exists t1;

create table t1 (a int, s varchar(10));
insert into t1 values (1, 'a'), (2, 'b');

-- NULL literal over a view that had the same column
create view v1 as select null m from db_root;
create or replace view v1 as select null m from db_root;
select * from v1;

-- scalar subquery folded to empty, the old column was an integer
create view v2 as select 1 m from db_root;
create or replace view v2 as select (select a from t1 where 1 = 0) m from db_root;
select count(*) from v2;

-- the old column was a string
create view v3 as select 'abc' m from db_root;
create or replace view v3 as select null m from db_root;
select * from v3;

-- explicit column list
create view v4 (m, n) as select 1, 2 from db_root;
create or replace view v4 (m, n) as select null, 'x' from db_root;
select * from v4;

-- UNION ALL of NULL literals
create view v5 as select null m from db_root;
create or replace view v5 as select null m from db_root union all select null from db_root;
select * from v5;

-- view over a table, replacing a column with NULL
create view v6 as select a, s from t1;
create or replace view v6 as select a, null s from t1;
select * from v6 order by a;

-- replaced twice, and a collated column replaced with NULL
create view v7 as select 'x' collate utf8_bin m from db_root;
create or replace view v7 as select null m from db_root;
create or replace view v7 as select null m, null n from db_root;
select * from v7;

-- the replaced columns get the same domain as a newly created view
select class_name, attr_name, data_type, prec, charset, collation from db_attribute
where class_name in ('v1', 'v2', 'v3', 'v4', 'v5', 'v6', 'v7') order by class_name, def_order;

drop view v1, v2, v3, v4, v5, v6, v7;
drop table t1;
