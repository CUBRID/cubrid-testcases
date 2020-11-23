set system parameters 'allow_truncated_string=yes';
---------- CREATE ... AS SELECT ...

drop table if exists t1;
create table t1 (col1 int, col2 bit varying(10));
insert into t1 values(1, b'1010101010'), (2, x'ab');
show columns from t1;
select * from t1 order by 1;

-- precision > value : OK
drop table if exists t2;
create table t2 (col1 int, col2 bit varying(12)) as select * from t1;
select * from t2 order by 1;

-- precision = value : OK
drop table if exists t2;
create table t2 (col1 int, col2 bit varying(10)) as select * from t1;
select * from t2 order by 1;

-- precision < value :truncated string
drop table if exists t2;
create table t2 (col1 int, col2 bit varying(4)) as select * from t1;
select * from t2 order by 1;

drop table t1;
drop table t2;
set system parameters 'allow_truncated_string=no';
