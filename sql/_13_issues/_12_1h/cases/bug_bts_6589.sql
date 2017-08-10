drop table if exists t1;
CREATE TABLE t1 (a int);
INSERT t1 VALUES (1);
--we expect two columns list in result.
SELECT * FROM (SELECT *, 'hello' from t1) t;
SELECT *, a as b from t1;
SELECT *, 'hello' from t1;
SELECT * FROM (SELECT *, 'hello' from t1) t;
SELECT a FROM (SELECT *, 'hello' from t1) t;
SELECT * FROM (SELECT *, a as b from t1) t;
SELECT * FROM (SELECT *, 'aaa' as b from t1) t;

drop table t1;


--more than 1 column
create table t1(a int, b int, c char(20));
insert into t1 values(1, 1, 'aaa');
insert into t1 values(2, 2, 'bbb');
insert into t1 values(3, 3, 'ccc');
insert into t1 values(4, 4, 'ddd');

select * from (select *, 'hello' from t1) t;
select a, b from (select *, 'hello' from t1);
--error, duplicate column a
select * from (select *, a, b, 'hello' from t1) t;
select * from (select *, a as aa, b as bb, 'hello' as cc from t1) t;
--error
select * from (select a, *, 'hello' from t1) t;
--error
select * from (select a, b as bb, 'hello', * from t1) t;


drop table t1;

