drop table if exists t;
create table t ( a char(1));
prepare s from 'insert into t select ? from db_root limit 1';
execute s using 1;
execute s using 0;
execute s using 9;
select * from t order by 1;

drop prepare s;
prepare s from 'insert into t select ? from db_class limit 41';
execute s using 1;
execute s using 0;
execute s using 9;
select * from t order by 1;

drop prepare s;
drop table t;
create table t ( a char(1),b char(2),c char(1),d varchar(3),e varchar(1),f char(1));
prepare s from 'insert into t select ?,?,?,?,?,? from db_class limit 41';
execute s using 1,1,1,1,1,1;
execute s using 0,0,0,0,0,0;
execute s using 9,9,9,9,9,9;
select * from t order by 1;
drop prepare s;
drop table t;
