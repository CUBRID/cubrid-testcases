set system parameters 'allow_truncated_string=no';

---------- CREATE TABLE ... DEFAULT ...
---------- INSERT INTO ... VALUES ...
-- precision > value : OK
drop table if exists t1;
create table t1 (col1 int, col2 char(5) default 'abc');
show columns from t1;
insert into t1 (col1) values (1), (2);
select * from t1 order by 1;

-- precision = value : OK
drop table if exists t1;
create table t1 (col1 int, col2 char(5) default 'abcde');
show columns from t1;
insert into t1 (col1) values (1), (2);
select * from t1 order by 1;

-- precision < value :truncated string
drop table if exists t1;
create table t1 (col1 int, col2 char(5) default 'abcde12');
show columns from t1;
insert into t1 (col1) values (1), (2);
select * from t1 order by 1;

drop table t1;
set system parameters 'allow_truncated_string=no';
