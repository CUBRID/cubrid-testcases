set system parameters 'allow_truncated_string=yes';

---------- INSERT INTO ... VALUES
---------- INSERT INTO ... SET
drop table if exists t1;
create table t1 (col1 int, col2 char(5));
show columns from t1;

-- precision > value : OK
insert into t1 values (1, 'abc');
insert into t1 set col1=2, col2= '123';
select * from t1 order by 1;

-- precision = value : OK
insert into t1 values (3, 'abcde');
insert into t1 set col1=4, col2= '12345';
select * from t1 order by 1;

-- precision < value :truncated string
insert into t1 values (5, 'abcde12');
insert into t1 set col1=6, col2= '12345ab';
select * from t1 order by 1;

drop table t1;
set system parameters 'allow_truncated_string=no';
