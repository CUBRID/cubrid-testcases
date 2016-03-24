--bug_bts_13208.sql

--Init state
autocommit off;
drop table if exists t1;
create table t1 (a int, b varchar);
insert into t1 values(1,'aaa'),(2,'bbb'),(3,'ccc'),(4,'ddd');

create or replace view t1_v as select * from t1 where a > 2;

drop table if exists t2;
create table t2 (a int, b string);
create index idx_t2_a on t2(a);
insert into t2 values(1,'A'),(2,'B'),(3,'C'),(4,'D');
commit;

--Test Point 1: check the error message if using FOR UPDATE in subqueries (select specific column)
select * from t1, (select b from t1 for update) as t;

--Test Point 2: check the error message if using FOR UPDATE in subqueries (select all columns)
select * from t1, (select * from t1 for update) as t;

--Test Point 3: check the error message if using FOR UPDATE in subqueries (view, select specific column)
select * from t1_v, (select b from t1_v for update) as t;

--Test Point 4: check the error message if using FOR UPDATE in subqueries (view, select all columns)
select * from t1_v, (select * from t1_v for update) as t;

--Test Point 5: check the error message if using FOR UPDATE in subqueries (inde table, specific column)
select * from t2, (select a from t2 for update) as t;

--Test Point 6: check the error message if using FOR UPDATE in subqueries (inde table, all columns)
select * from t2, (select * from t2 for update) as t;

drop view if exists t1_v;
drop table if exists t1;
drop table if exists t2;
commit;

autocommit on;
