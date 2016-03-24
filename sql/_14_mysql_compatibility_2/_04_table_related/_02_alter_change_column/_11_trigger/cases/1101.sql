---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints :
-- ordering : no order defined
-- name : same of different
-- other : the table has triggers 

-------------- column name changes + type changes
create table t1 (i1 integer);
create table t2 (i2 integer);

insert into t1 values (1),(2),(3);

select * from t1  order by 1;
select * from t2 order by 1;

-- TODO : change for CUBRID syntax
create trigger tr1  before insert on t1 
execute insert t2 set i2=new.i1; 

--MYSQL
--create trigger tr1  before insert on t1 
--for each row insert t2 set i2=NEW.i1; 

insert into t1 values (4);
-- OK
alter table t1 change column i1 d1 double;

-- SHOULD FAIL (name of i1 changed)
insert into t1 values (5);

select * from t1 order by 1;
select * from t2 order by 1;

drop table t2;
drop table t1;




-------------- column name the same , type changes
create table t1 (i1 integer);
create table t2 (i2 integer);

insert into t1 values (1),(2),(3);

select * from t1 order by 1;
select * from t2 order by 1;

-- TODO : change for CUBRID syntax
create trigger tr1  before insert on t1 
execute insert t2 set i2=new.i1; 

--MYSQL
--create trigger tr1  before insert on t1 
--for each row insert t2 set i2=NEW.i1; 

insert into t1 values (4);
-- OK :
alter table t1 change column i1 i1 double;

-- no error in MYSQL
insert into t1 values (5e-11);

-- no error in MYSQL, but results are different (new entry in t2 is 0 , while in t1 is 5e-11)
select * from t1 order by 1;
select * from t2 order by 1;

drop table t2;
drop table t1;




-------------- column name the same , type changes
create table t1 (i1 integer);
create table t2 (i2 integer);

insert into t1 values (1),(2),(3);

select * from t1 order by 1;
select * from t2 order by 1;

-- TODO : change for CUBRID syntax
create trigger tr1  before insert on t1 
execute insert t2 set i2=NEW.i1; 

--MYSQL
--create trigger tr1  before insert on t1 
--for each row insert t2 set i2=NEW.i1; 

insert into t1 values (4);
-- OK in MYSQL
alter table t1 change column i1 i1 char(20);

-- MYSQL : ERROR 1366 (HY000): Incorrect integer value: 'abc' for column 'i2' at row 1
-- CUBRID: ERROR: Error evaluating action for "tr1", A domain conflict exists on attribute "i2".
-- no insert is done in t2
insert into t1 values ('abc');

select * from t1 order by 1;
select * from t2 order by 1;

drop table t2;
drop table t1;


