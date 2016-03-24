---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from int

-- to short
create table t1 (d1 date shared date'2001-01-04', i2 int);

insert into t1 values (date'2001-01-04',1),(date'2001-01-04',2);
update t1 set t1.d1=date'2001-05-09';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 s1 short;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;



-- to datetime
create table t1 (d1 date shared date'2001-01-04', i2 int);

insert into t1 values (date'2001-01-04',1),(date'2001-01-04',2);
update t1 set t1.d1=date'2001-05-09';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 dt1 datetime;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- to varchar, not enough chars
create table t1 (d1 date shared date'2001-01-04', i2 int);

insert into t1 values (date'2001-01-04',1),(date'2001-01-04',2);
update t1 set t1.d1=date'2001-05-09';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 s1 varchar(6);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- to varchar, enough chars
create table t1 (d1 date shared date'2001-01-04', i2 int);

insert into t1 values (date'2001-01-04',1),(date'2001-01-04',2);
update t1 set t1.d1=date'2001-05-09';

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 s1 varchar(16);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;
