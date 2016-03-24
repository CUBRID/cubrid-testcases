---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from double

-- to int, char has only digits
create table t1 (s1 varchar(10) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='123';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 i1 int;

select * from t1 order by 1,2;

show columns in t1;

drop table t1;



-- to int, char other chars
create table t1 (s1 varchar(10) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='1D23Q';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 i1 int;

select * from t1 order by 1,2;

show columns in t1;

drop table t1;



-- to date
create table t1 (s1 varchar(14) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='2009-05-01';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 d1 date;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- to char, size decrease
create table t1 (s1 varchar(10) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='1234de';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 c1 char(8);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- to varchar, size decrease
create table t1 (s1 varchar(10) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='1234de';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 c1 char(4);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- to varchar,  size increase
create table t1 (s1 varchar(10) shared NULL, i2 int);

insert into t1 values ('1',1),('2',2);
update t1 set t1.s1='1234de';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 c1 char(18);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;
