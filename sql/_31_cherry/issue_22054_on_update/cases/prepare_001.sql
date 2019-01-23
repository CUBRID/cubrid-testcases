drop table if exists t;
create table t(
a int,
b timestamp on update current_timestamp
);
insert into t(a) values(1);
prepare st from 'update t set a=?';
execute st using 2;
select if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') from t;
drop prepare st;

drop table if exists t;
create table t(
a int primary key,
b timestamp on update current_timestamp,
c int default 0
);
insert into t(a,c) values(1,2);
prepare st from 'insert into t(a,c) values(?,?) on duplicate key update c=?';
execute st using 1,2,5;
select if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') from t;
drop prepare st;
drop table if exists t;



