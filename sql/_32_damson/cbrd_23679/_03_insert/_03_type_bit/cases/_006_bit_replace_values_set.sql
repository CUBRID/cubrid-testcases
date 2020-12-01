set system parameters 'allow_truncated_string=no';
---------- REPLACE ... VALUES ...
---------- REPLACE ... SET ...

drop table if exists t1;
create table t1 (col1 int not null primary key, col2 bit(10));
insert into t1 values(1, b'1010101010'), (2, x'ab');
show columns in t1;
select * from t1 order by 1;

-- precision > value : OK
replace into t1 values (1, b'1010');
replace into t1 set col1=2, col2= x'a';
select * from t1 order by 1;

-- precision = value : OK
replace into t1 values (1, b'1010111110');
replace into t1 set col1=2, col2= x'af';
select * from t1 order by 1;

-- precision < value :data overflow
replace into t1 values (1, b'101011111011');
replace into t1 set col1=2, col2=x'afb';
select * from t1 order by 1;

drop table t1;
set system parameters 'allow_truncated_string=no';
