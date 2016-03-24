--conversion from enum to date/time types
create table t1(e1 enum('2011-01-01', '2012-01-01', '2010-04-05'));
insert into t1 values (3), (1), (2);
select * from t1 order by 1;
select cast(e1 as timestamp) from t1 order  by 1;
select cast(e1 as datetime) from t1 order  by 1;
select cast(e1 as date) from t1 order  by 1;
select cast(e1 as time) from t1 order  by 1;

drop table t1;