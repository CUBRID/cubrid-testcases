---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from double

-- to int, char has only digits
create table t1 (s1 char(10) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='123';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 i1 int;

select * from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to int, char has only digits, exact size
create table t1 (s1 char(3) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='123';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 i1 int;

select * from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to int, char other chars
create table t1 (s1 char(10) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='12AZ3';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 i1 int;

select * from t1 order by 1,2;

show columns in t1;

drop table t1;




-- to time
create table t1 (s1 char(10) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='10:11:12';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 t1 time;

select * from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to time, exact size
create table t1 (s1 char(8) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='10:11:12';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 t1 time;

select * from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to char, size decrease
create table t1 (s1 char(30) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='10:11:12';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 s1 char(10);

select * from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to varchar, size decrease, not enough
create table t1 (s1 char(10) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='10:11:12';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 s1 char(4);

select * from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to varchar,  size increase
create table t1 (s1 char(10) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='10:11:12';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 s1 varchar(14);

select * from t1 order by 1,2;

show columns in t1;

drop table t1;
