---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : constraints are maintained  : UNIQUE KEY
-- ordering : no order defined
-- name : different names


------- type the same, keep UNIQUE, change name
create table t1 (d1 double unique key);
insert into t1 values (1.112),(1.123);

-- should fail
insert into t1 values (1.112);

select * from t1 order by 1;
show columns in t1;
-- should be OK
alter table t1 change d1 d_1 double unique key;
-- should fail
insert into t1 values (1.112);
select * from t1 order by 1;

show columns in t1;

drop table t1;


------- type unchanged (prec decreased), keep UNIQUE
create table t1 (s varchar(10) unique key);
insert into t1 values ('123'),('abc');

-- should fail
insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;
-- should fail
alter table t1 change s s varchar(5) unique;

-- should fail
insert into t1 values ('123');
select * from t1 order by 1;
show columns in t1;

drop table t1;



------- type unchanged (prec increased), keep UNIQUE
create table t1 (s varchar(10) unique key);
insert into t1 values ('123'),('abc');

-- should fail
insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;
-- should be OK
alter table t1 change s s varchar(25) unique;

-- should fail
insert into t1 values ('123');
-- should be OK
insert into t1 values ('1234567890123');
-- should fail
insert into t1 values ('1234567890123');
select * from t1 order by 1;
show columns in t1;

drop table t1;


