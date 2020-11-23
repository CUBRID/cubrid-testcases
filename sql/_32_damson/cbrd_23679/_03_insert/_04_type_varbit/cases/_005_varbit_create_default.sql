set system parameters 'allow_truncated_string=no';
---------- CREATE TABLE ... DEFAULT ...
---------- INSERT INTO ... VALUES ...

-- precision > value : OK
drop table if exists t1;
create table t1 (col1 int, col2 bit varying(10) default b'101011');
show columns from t1;
insert into t1 (col1) values (1), (2);
select * from t1 order by 1;

-- precision = value : OK
drop table if exists t1;
create table t1 (col1 int, col2 bit varying(10) default b'1010101010');
show columns from t1;
insert into t1 (col1) values (1), (2);
select * from t1 order by 1;

-- precision < value :data overflow
drop table if exists t1;
create table t1 (col1 int, col2 bit varying(10) default b'101010101111');
show columns from t1;
insert into t1 (col1) values (1), (2);
select * from t1 order by 1;

drop table t1;

set system parameters 'allow_truncated_string=no';
