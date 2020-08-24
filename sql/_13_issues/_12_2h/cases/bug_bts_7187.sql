set system parameters 'create_table_reuseoid=no';
--TEST: 'Accessing deleted object error' occurs when creating a trigger with delete action on 'before update' event.

autocommit off;

--original scenario
drop table if exists t1;

create table t1(a int);
insert into t1 values(1), (2), (3), (4);

create trigger trigg1 before update on t1
execute delete from t1;

update t1 set a=6;
select * from t1 order by 1;
drop table t1;


--other scenarios
-------------------------------------------------------------------------------
---test update statement with trigger
-------------------------------------------------------------------------------
--CASE1: test update statement with before delete trigger, they operate the same object
create table t1(a int);
insert into t1 values(1), (2), (3);
create trigger trigg1 before update on t1 execute delete from t1;
update t1 set a=11;
SELECT * FROM t1 order by 1;
drop table t1;

--CASE2: test update statement with before delete trigger, they operate the different object
create table t2(a int);
insert into t2 values(1), (2), (3);
create trigger trigg2 before update on t2 execute delete from t2 WHERE a = 1;
update t2 set a=22 WHERE a = 2;
SELECT * FROM t2 order by 1;
drop table t2;

--CASE2a: test update statement with before delete trigger, they operate the different object
create table t2a(a int);
insert into t2a values(1), (2), (3);
create trigger trigg21 before update on t2a execute delete from t2a WHERE a = 1;
update t2a set a=1 WHERE a = 2;
SELECT * FROM t2a order by 1;
drop table t2a;

--CASE3: test update statement with after delete trigger, they operate the same object
create table t3(a int);
insert into t3 values(1), (2), (3);
create trigger trigg3 after update on t3 execute delete from t3;
update t3 set a=33;
SELECT * FROM t3 order by 1;
drop table t3;

--CASE4: test update statement with after delete trigger, they operate the different object
create table t4(a int);
insert into t4 values(1), (2), (3);
create trigger trigg4 after update on t4 execute delete from t4 WHERE a = 1;
update t4 set a=44 WHERE a = 2;
SELECT * FROM t4 order by 1;
drop table t4;

--CASE5: test update statement with before insert trigger, they operate the different object
create table t5(a int);
insert into t5 values(1), (2), (3);
create trigger trigg5 before update on t5 EXECUTE INSERT INTO t5 VALUES (5);
update t5 set a=55;
SELECT * FROM t5 order by 1;
drop table t5;

--CASE6: test update statement with before insert trigger, they operate the different object
create table t6(a int);
insert into t6 values(1), (2), (3);
create trigger trigg6 after update on t6 EXECUTE INSERT INTO t6 VALUES (6);
update t6 set a=66;
SELECT * FROM t6 order by 1;
drop table t6;


-------------------------------------------------------------------------------
---test delete statement with trigger
-------------------------------------------------------------------------------
--CASE7: test delete statement with before update trigger, they operate the same object 
create table t7(a int);
insert into t7 values(1), (2), (3);
create trigger trigg7 before delete on t7 execute UPDATE t7 SET a= 7;
DELETE FROM t7;
SELECT * FROM t7 order by 1;
drop table t7;

--CASE8: test delete statement with before update trigger, they operate the different object
create table t8(a int);
insert into t8 values(1), (2), (3);
create trigger trigg8 BEFORE delete on t8 execute UPDATE t8 SET a= 8 WHERE a = 2;
DELETE FROM t8 WHERE a = 1;
SELECT * FROM t8 order by 1;
drop table t8;

--CASE9: test delete statement with after update trigger, they operate the same object
create table t9(a int);
insert into t9 values(1), (2), (3);
create trigger trigg9 after delete on t9 execute UPDATE t9 SET a= 9;
DELETE FROM t9;
SELECT * FROM t9 order by 1;
drop table t9;

--CASE10: test delete statement with after update trigger, they operate the different object
create table t10(a int);
insert into t10 values(1), (2), (3);
create trigger trigg10 after delete on t10 execute UPDATE t10 SET a= 10 WHERE a = 2;
DELETE FROM t10 WHERE a = 1;
SELECT * FROM t10 order by 1;
drop table t10;


-------------------------------------------------------------------------------
---test insert statement with trigger
-------------------------------------------------------------------------------
--CASE11: test insert statement with before delete trigger, they operate the different object
create table t11(a int);
insert into t11 values(1), (2), (3);
create trigger trigg11 BEFORE insert on t11 execute DELETE FROM t11;
INSERT INTO t11 VALUES(4);
SELECT * FROM t11 order by 1;
drop table t11;

--CASE12: test insert statement with after delete trigger, they operate the different object
create table t12(a int);
insert into t12 values(1), (2), (3);
create trigger trigg12 after insert on t12 execute DELETE FROM t12;
INSERT INTO t12 VALUES(4);
SELECT * FROM t12 order by 1;
drop table t12;

--CASE13: test insert statement with after update trigger, they operate the different object
create table t13(a int);
insert into t13 values(1), (2), (3);
create trigger trigg13 BEFORE insert on t13 execute UPDATE t13 SET a= 13 WHERE a = 2;
INSERT INTO t13 VALUES(4);
SELECT * FROM t13 order by 1;
drop table t13;

--CASE14: test insert statement with before update trigger, they operate the same object
create table t14(a int);
insert into t14 values(1), (2), (3);
create trigger trigg14 after insert on t14 execute UPDATE t14 SET a= 14 WHERE a = 2;
INSERT INTO t14 VALUES(2);
SELECT * FROM t14 order by 1;
drop table t14;


--CASE15: test view, original scenario of CUBRIDSUS-8175
create table t15 (a int, b int);
insert into t15 values (2,2), (3,3);
create view v15 as select * from t15;
create trigger trigg15_1 before delete ON t15 execute UPDATE v15 SET a= 7;
create trigger trigg15_2 before delete ON t15 execute UPDATE t15 SET a= 8;
--Test: below will throw core file.
DELETE FROM v15;
SELECT * FROM v15 order by 1;
drop view v15;
drop table t15;

rollback;

autocommit on;
set system parameters 'create_table_reuseoid=yes';
