create table t (i int, j int, k int);
create table u (i int, j int, k int);
create table v (i int, j int, k int);

insert into t values (1,1,1);
insert into u values (1,1,1);
insert into v values (1,1,1);

--set trigger active
--set trigger depth infinite

--create trigger NAME
--BEFORE|AFTER|DEFERRED
--DELETE|UPDATE|INSERT|STATEMENT UPDATE|STATEMENT ...
--ON class
--IF new|old.i > 0
--EXECUTE 
--INSERT|UPDATE|DELETE|REJECT|INVALIDATE|PRINT 'xxx'|EVALUATE;

set trigger depth 100;
set trigger depth -100;


create trigger trg before delete on t execute delete from t;
delete from t;
drop trigger trg;

create trigger trg before statement delete on t execute delete from t;
-- ok, nu da eroare
delete from t;
drop trigger trg;

select * from t order by 1,2,3;
insert into t values (1,1,1);

create trigger trg before update on t if new.i > obj.i execute update t set i = i + 1;
-- ok, the if is FALSE
update t set i = 0;
-- er:
update t set i = 1;
drop trigger trg;


delete from t;
insert into t values (1,1,1);
create trigger trg after update on t if obj.i  < 0 execute update t set i = i + 1;
-- ok
update t set i = 2 where i = 1;
-- ok, recursive lvl 1
update t set i = -2 where i = 2;
drop trigger trg;

create trigger trg before insert on t execute insert into t (j) values (3);
insert into t(i) values (3);
alter trigger trg status inactive;
insert into t(i) values (3);
drop trigger trg;

delete from t;

create trigger trg before statement insert on t execute insert into t values (0,0,0);
insert into t values (1,1,1);
insert into t values (9,9,9);
drop trigger trg;

select * from t order by 1,2,3; 
delete from t;
insert into t values (1,1,1);


create trigger trg_t before insert on t execute insert into u values (2,2,2);
create trigger trg_u after statement insert on u execute delete from v where i = 1;
create trigger trg_v after delete on v execute insert into t values (4,4,4);
commit;
-- ok
insert into t values (3,3,3);

-- er
insert into v values (1,1,1);
set trigger depth 3;
insert into t values (3,3,3);

set trigger depth 32;
-- works ok because trg_u is triggered by statement insert
insert into u values (3,3,3);

insert into v values (1,1,1);
insert into v values (2,1,1);

-- er
delete from v where i = 2;

select count(*) from v;

-- success: deletes everything for the first time, and the second time trg_v gets called, it does not have
-- any record to delete, so no "after delete" action happens.
delete from v;
select count(*) from v;

drop trigger trg_t;
drop trigger trg_u;
drop trigger trg_v;

insert into v values (1,1,1);

drop table t;
drop table u;
drop table v;

-- -------------------------------------------

create table t00(i int);
create table t01(i int);
create table t02(i int);
create table t03(i int);
create table t04(i int);
create table t05(i int);
create table t06(i int);
create table t07(i int);
create table t08(i int);
create table t09(i int);
create table t10(i int);
create table t11(i int);
create table t12(i int);
create table t13(i int);
create table t14(i int);
create table t15(i int);
create table t16(i int);
create table t17(i int);
create table t18(i int);
create table t19(i int);

create trigger trg_00 before insert on t00 execute insert into t01 values (1);
create trigger trg_01 before insert on t01 execute insert into t02 values (1);
create trigger trg_02 before insert on t02 execute insert into t03 values (1);
create trigger trg_03 before insert on t03 execute insert into t04 values (1);
create trigger trg_04 before insert on t04 execute insert into t05 values (1);
create trigger trg_05 before insert on t05 execute insert into t06 values (1);
create trigger trg_06 before insert on t06 execute insert into t07 values (1);
create trigger trg_07 before insert on t07 execute insert into t08 values (1);
create trigger trg_08 before insert on t08 execute insert into t09 values (1);
create trigger trg_09 before insert on t09 execute insert into t10 values (1);
create trigger trg_10 before insert on t10 execute insert into t11 values (1);
create trigger trg_11 before insert on t11 execute insert into t12 values (1);
create trigger trg_12 before insert on t12 execute insert into t13 values (1);
create trigger trg_13 before insert on t13 execute insert into t14 values (1);
create trigger trg_14 before insert on t14 execute insert into t15 values (1);
create trigger trg_15 before insert on t15 execute insert into t16 values (1);
create trigger trg_16 before insert on t16 execute insert into t17 values (1);
create trigger trg_17 before insert on t17 execute insert into t18 values (1);
create trigger trg_18 before insert on t18 execute insert into t19 values (1);
create trigger trg_19 before insert on t19 execute insert into t05 values (1);

-- make sure the triggers are committed
commit; 

--er
insert into t00 values (1);
insert into t13 values (1);

-- break the chain
alter trigger trg_15 status inactive;
commit;

-- success
insert into t00 values (1);
insert into t13 values (1);

drop trigger trg_00;
drop trigger trg_01;
drop trigger trg_02;
drop trigger trg_03;
drop trigger trg_04;
drop trigger trg_05;
drop trigger trg_06;
drop trigger trg_07;
drop trigger trg_08;
drop trigger trg_09;
drop trigger trg_10;
drop trigger trg_11;
drop trigger trg_12;
drop trigger trg_13;
drop trigger trg_14;
drop trigger trg_15;
drop trigger trg_16;
drop trigger trg_17;
drop trigger trg_18;
drop trigger trg_19;

drop table t00;
drop table t01;
drop table t02;
drop table t03;
drop table t04;
drop table t05;
drop table t06;
drop table t07;
drop table t08;
drop table t09;
drop table t10;
drop table t11;
drop table t12;
drop table t13;
drop table t14;
drop table t15;
drop table t16;
drop table t17;
drop table t18;
drop table t19;


-- CUBRIDSUS-4536
CREATE TABLE with_trigger(a int primary key, b char(20), c double unique);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE INSERT INTO with_trigger VALUES (11, 'BEFORE INSERT', 11);
REPLACE INTO with_trigger VALUES (2, 'DDD', 6);
DROP TRIGGER trig_bef_ins;
DROP TABLE with_trigger;

-- CUBRIDSUS-4537
CREATE TABLE trigger_actions(id int auto_increment, a smallint, b string, c numeric);
CREATE TRIGGER trig_bef_ins BEFORE INSERT ON trigger_actions EXECUTE INSERT INTO trigger_actions(a, b, c) VALUES (33, 'BEFORE INSERT', 33);
CREATE TRIGGER trig_aft_ins AFTER INSERT ON trigger_actions EXECUTE DELETE FROM trigger_actions WHERE c=33;
CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON trigger_actions EXECUTE INSERT INTO trigger_actions(a, b, c) VALUES (55, 'BEFORE UPDATE', 55);
CREATE TRIGGER trig_aft_upd AFTER UPDATE ON trigger_actions EXECUTE UPDATE trigger_actions SET c=44 WHERE a=33;

INSERT INTO trigger_actions(a, b, c) VALUES (66, 'AFTER UPDATE', 66);

DROP TRIGGER trig_bef_ins;
DROP TABLE trigger_actions;

-- CUBRIDSUS-4569
CREATE TABLE with_trigger(a int primary key, b char(20), c double);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by 1;

CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE INSERT INTO with_trigger VALUES (11, 'BEFORE UPDATE', 11);
CREATE TRIGGER trig_aft_upd AFTER UPDATE ON with_trigger EXECUTE UPDATE with_trigger SET b='AFTER UPDATE' WHERE a=11;

-- er, will throw a LEGITIMATE 'duplicate key violation' error
INSERT INTO with_trigger VALUES (2, 'DDD', 7) ON DUPLICATE KEY UPDATE c=c+1;

drop trigger trig_bef_upd;
drop trigger trig_aft_upd;
drop table with_trigger;

commit;