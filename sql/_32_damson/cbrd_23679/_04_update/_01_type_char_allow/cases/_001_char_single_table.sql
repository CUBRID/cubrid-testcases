set system parameters 'allow_truncated_string=yes';

---------- UPDATE ... SET ...
drop table if exists t1;
create table t1 (col1 int, col2 char(5));
insert into t1 values (1,null);
show columns from t1;
select * from t1 order by 1;

-- precision > value : OK
update t1 set col2 = 'abc' where col1 = 1;
select * from t1 order by 1;

-- precision = value : OK
update t1 set col2 = 'abcde' where col1 = 1;
select * from t1 order by 1;

-- precision < value :truncated string
update t1 set col2 = 'abcde12' where col1 = 1;
select * from t1 order by 1;

drop table t1;
set system parameters 'allow_truncated_string=no';
