--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : constraints are maintained  : PRIMARY KEY
-- ordering : no order defined
-- name : different names


------- type the same, keep PRIMARY, change name
create table t1 (d1 double primary key);
insert into t1 values (1.112),(1.123);

-- should fail
insert into t1 values (1.112);

select * from t1 order by 1;
show columns in t1;
-- should be OK
alter table t1 change d1 d_1 double primary key;
-- should fail
insert into t1 values (1.112);
select * from t1 order by 1;

show columns in t1;

drop table t1;


------- type unchanged (prec decreased), keep PRIMARY, data in range
create table t1 (s varchar(10) primary key);
insert into t1 values ('123'),('abc');

-- should fail
insert into t1 values ('123');

select * from t1  order by 1;
show columns in t1;
-- should fail
alter table t1 change s s varchar(5) primary key;

-- should fail
insert into t1 values ('123');
select * from t1 order by 1;
show columns in t1;

drop table t1;


------- type unchanged (prec decreased), keep PRIMARY, data out of range, strict=no
create table t1 (s varchar(10) primary key);
insert into t1 values ('123456789'),('abc');
insert into t1 values ('12345');

-- should fail
insert into t1 values ('123');

select * from t1  order by 1;
show columns in t1;
-- should fail
alter table t1 change s s varchar(5) primary key;

-- should fail
insert into t1 values ('123');
select * from t1 order by 1;
show columns in t1;

drop table t1;


------- type unchanged (prec decreased), keep PRIMARY, data out of range, strict=yes

create table t1 (s varchar(10) primary key);
insert into t1 values ('123456789'),('abc');
insert into t1 values ('12345');

-- should fail
insert into t1 values ('123');

select * from t1  order by 1;
show columns in t1;
-- should fail

set system parameters 'alter_table_change_type_strict=yes';

-- should fail
alter table t1 change s s varchar(5) primary key;

set system parameters 'alter_table_change_type_strict=no';

-- should fail
insert into t1 values ('123');
select * from t1 order by 1;
show columns in t1;

drop table t1;



------- type unchanged (prec increased), keep PRIMARY
create table t1 (s varchar(10) primary key);
insert into t1 values ('123'),('abc');

-- should fail
insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;
-- should be OK
alter table t1 change s s varchar(25) primary key;

-- should fail
insert into t1 values ('123');
-- should be OK
insert into t1 values ('1234567890123');
-- should fail
insert into t1 values ('1234567890123');

select * from t1 order by 1;
show columns in t1;

drop table t1;


commit;
--+ holdcas off;
