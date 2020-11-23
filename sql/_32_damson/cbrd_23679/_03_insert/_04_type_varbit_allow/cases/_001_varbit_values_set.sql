set system parameters 'allow_truncated_string=yes';
---------- INSERT INTO ... VALUES
---------- INSERT INTO ... SET
drop table if exists t1;
create table t1 (col1 int, col2 bit varying(10));
show columns from t1;

-- precision > value : OK
insert into t1 values (1, b'101010');
insert into t1 set col1=2, col2= x'2a';
select * from t1 order by 1;

-- precision = value : OK
insert into t1 values (3, b'1111111111');
insert into t1 set col1=4, col2= x'ff';
select * from t1 order by 1;

-- precision < value :truncated string
insert into t1 values (5, b'101010101101');
insert into t1 set col1=6, col2= x'abcd';
select * from t1 order by 1;

drop table if exists t1;
set system parameters 'allow_truncated_string=no';
