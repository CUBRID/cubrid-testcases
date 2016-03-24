---- ALTER TABLE ...  CHANGE COLUMN  
-- shared attribute
-- type change from double

-- to int
create table t1 ( d1 double shared 0, i2 integer) ;
insert into t1 values (1.0,1),(0.123,2);
update t1 set d1=0.123456e-2;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 i_1 int;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- to numeric
create table t1 ( d1 double shared 0, i2 integer) ;
insert into t1 values (1.0,1),(0.123,2);
update t1 set d1=0.123456e-2;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 n1 numeric(10,5);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;




-- to timestamp
-- unsupported 
create table t1 ( d1 double shared 0, i2 integer) ;
insert into t1 values (1.0,1),(0.123,2);
update t1 set d1=0.123456e-2;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 ts1 timestamp;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- to varchar
create table t1 ( d1 double shared 0, i2 integer) ;
insert into t1 values (1.0,1),(0.123,2);
update t1 set d1=0.123456e-2;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 s1 varchar(30);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- to char, value too big
create table t1 ( d1 double shared 0, i2 integer) ;
insert into t1 values (1.0,1),(0.123,2);
update t1 set d1=0.123456e-2;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 s1 char(5);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;

