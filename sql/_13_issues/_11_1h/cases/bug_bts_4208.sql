create table t ( a timestamp, b timestamp);
insert into t values ('2011-02-08 01:00:00', '2011-02-08 04:00:00');

prepare s from 'select * from t where a between ? and ? or b between ? and ?' 
execute s using '2011-02-08 00:00:00' , '2011-02-08 01:00:00', '2011-02-08 03:00:00', '2011-02-08 06:00:00' 
drop prepare s;

drop table t;
