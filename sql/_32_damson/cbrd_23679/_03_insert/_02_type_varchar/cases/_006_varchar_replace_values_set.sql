set system parameters 'allow_truncated_string=no';

---------- REPLACE ... VALUES ...
---------- REPLACE ... SET ...
drop table if exists t1;
create table t1 (col1 int not null primary key, col2 varchar(5));
insert into t1 values(1, 'abcde'), (2, '12345');
show columns in t1;
select * from t1 order by 1;

-- precision > value : OK
replace into t1 values (1, 'abc');
replace into t1 set col1=2, col2='123';
select * from t1 order by 1;

-- precision = value : OK
replace into t1 values (1, 'abcde');
replace into t1 set col1=2, col2='12345';
select * from t1 order by 1;

-- precision < value :data overflow
replace into t1 values (1, 'abcde12');
replace into t1 set col1=2, col2='12345ab';
select * from t1 order by 1;

drop table t1;
set system parameters 'allow_truncated_string=no';
