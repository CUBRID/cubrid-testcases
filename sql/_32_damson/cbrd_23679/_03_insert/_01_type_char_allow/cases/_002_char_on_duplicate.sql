set system parameters 'allow_truncated_string=yes';

---------- INSERT INTO ... SET ... ON DUPLICATE KEY UPDATE
---------- INSERT INTO ... SELECT ... ON DUPLICATE KEY UPDATE
drop table if exists t1;
create table t1 (col1 int not null primary key, col2 char(5));
insert into t1(col1) values (1), (2), (3);
show columns from t1;
select * from t1;

drop table if exists t2;
create table t2 (col1 int not null primary key, col2 char(5));
insert into t2(col1) values (1), (2), (3);
show columns from t2;
select * from t2;

-- precision > value : OK
insert into t1 set col1=1, col2= 'abc' on duplicate key update col1=1, col2 = 'abc';
select * from t1 order by 1;
insert into t2 select * from t1 where col1=1 on duplicate key update col2='abc';
select * from t2 order by 1;

-- precision = value : OK
insert into t1 set col1=2, col2= 'abcde' on duplicate key update col1=2, col2 = 'abcde';
select * from t1 order by 1;
insert into t2 select * from t1 where col1=2 on duplicate key update col2='abcde';
select * from t2 order by 1;

-- precision < value :truncated string
insert into t1 set col1=3, col2= 'abcde12' on duplicate key update col1=3, col2 = 'abcde12';
select * from t1 order by 1;
insert into t2 select * from t1 where col1=3 on duplicate key update col2='abcde12';
select * from t2 order by 1;

drop table t1;
drop table t2;
set system parameters 'allow_truncated_string=no';
