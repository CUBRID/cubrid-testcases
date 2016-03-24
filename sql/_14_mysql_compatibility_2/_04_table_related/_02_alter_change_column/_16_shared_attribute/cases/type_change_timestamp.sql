---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from int

-- to double 
create table t1 (ts1 timestamp shared timestamp'2001-01-04 11:12:13', i2 int);

insert into t1 values (timestamp'2001-01-04 11:12:13',1),(timestamp'2001-01-04 11:12:13',2);
update t1 set t1.ts1=timestamp'2000-03-05 10:10:10';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change ts1 d1 double;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;



-- to datetime
create table t1 (ts1 timestamp shared timestamp'2001-01-04 11:12:13', i2 int);

insert into t1 values (timestamp'2001-01-04 11:12:13',1),(timestamp'2001-01-04 11:12:13',2);
update t1 set t1.ts1=timestamp'2000-03-05 10:10:10';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change ts1 dt1 datetime;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;



-- to char, not enough chars
create table t1 (ts1 timestamp shared timestamp'2001-01-04 11:12:13', i2 int);

insert into t1 values (timestamp'2001-01-04 11:12:13',1),(timestamp'2001-01-04 11:12:13',2);
update t1 set t1.ts1=timestamp'2000-03-05 10:10:10';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change ts1 c1 char(10);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;



-- to varnchar, enough chars
create table t1 (ts1 timestamp shared timestamp'2001-01-04 11:12:13', i2 int);

insert into t1 values (timestamp'2001-01-04 11:12:13',1),(timestamp'2001-01-04 11:12:13',2);
update t1 set t1.ts1=timestamp'2000-03-05 10:10:10';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change ts1 c1 varchar(30);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;
