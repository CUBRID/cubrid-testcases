set system parameters 'allow_truncated_string=no';
---------- REPLACE ... VALUES ...
---------- REPLACE ... SELECT ...

drop table if exists t1;
create table t1 (col1 int not null primary key, col2 bit(10));
insert into t1 values(1, b'1010101010'), (2, x'3ab');
show columns in t1;
select * from t1 order by 1;

-- precision > value : OK
drop table if exists t2;
create table t2 (col1 int not null primary key, col2 bit(12));
replace into t2 values (1, null), (2, null);
replace into t2 select * from t1;
select * from t2 order by 1;

-- precision = value : OK
drop table if exists t2;
create table t2 (col1 int not null primary key, col2 bit(10));
replace into t2 values (1, null), (2, null);
replace into t2 select * from t1;
select * from t2 order by 1;

-- precision < value :data overflow
drop table if exists t2;
create table t2 (col1 int not null primary key, col2 bit(4));
replace into t2 values (1, null), (2, null);
replace into t2 select * from t1;
select * from t2 order by 1;

drop table t1;
drop table t2;
set system parameters 'allow_truncated_string=no';
