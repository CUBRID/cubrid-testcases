set system parameters 'allow_truncated_string=no';

---------- UPDATE ... SET ...
drop table if exists t1;
create table t1 (col1 int, col2 bit varying(10));
insert into t1 values (1,null);
show columns from t1;
select * from t1 order by 1;

-- precision > value : OK
update t1 set col2 = b'1010' where col1 = 1;
select * from t1 order by 1;

-- precision = value : OK
update t1 set col2 = b'1010111110' where col1 = 1;
select * from t1 order by 1;

-- precision < value :data overflow
update t1 set col2 = '101011111010' where col1 = 1;
select * from t1 order by 1;

drop table t1;
set system parameters 'allow_truncated_string=no';
