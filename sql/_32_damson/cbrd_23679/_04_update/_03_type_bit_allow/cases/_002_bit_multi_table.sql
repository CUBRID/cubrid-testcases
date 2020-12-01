set system parameters 'allow_truncated_string=yes';

---------- UPDATE ... INNER JOIN ... SET...
drop table if exists t1;
create table t1 (col1 int primary key, col2 bit(10));
insert into t1 (col1) values (1),(2),(3);
show columns from t1;
select * from t1 order by 1;

-- precision > value : OK
drop table if exists s1;
create table s1 (col1 int, col2 bit(4));
insert into s1 values (1,b'1010');
update t1 inner join s1 on t1.col1=s1.col1
set t1.col2=s1.col2;
select * from t1 order by 1;

-- precision = value : OK
drop table if exists s1;
create table s1 (col1 int, col2 bit(10));
insert into s1 values (2,b'1010111110');
update t1 inner join s1 on t1.col1=s1.col1
set t1.col2=s1.col2;
select * from t1 order by 1;

-- precision < value :truncated string
drop table if exists s1;
create table s1 (col1 int, col2 bit(12));
insert into s1 values (3,b'101011111010');
update t1 inner join s1 on t1.col1=s1.col1
set t1.col2=s1.col2;
select * from t1 order by 1;

drop table t1, s1;
set system parameters 'allow_truncated_string=no';
