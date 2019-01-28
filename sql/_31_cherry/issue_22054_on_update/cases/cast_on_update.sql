 drop if exists t,t1,t2,t3;
 create table t(a int ,b timestamp default cast('2018-7-25 13:25:00' as timestamp) on update current_timestamp);
 create table t1(a int ,b timestamp default cast('2018-7-25 13:25:00' as datetime) on update current_timestamp);
 create table t2(a int ,b timestamp default cast('2018-7-25 13:25:00' as datetimetz) on update current_timestamp);
 create table t3(a int ,b timestamp default cast('2018-7-25 13:25:00' as timestamptz) on update current_timestamp);

insert t(a) values(1),(2),(3),(4);
insert t2(a) values(1),(2),(3),(4);
 select * from t order by 1;
 select * from t2 order by 1;
 update t set a=a+1;
 select if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') from t;
 update t2 set a=1;
 select if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') from t2;

  drop if exists t,t1,t2,t3;
 create table t(a int ,b timestamptz default cast('2018-7-25 13:25:00' as timestamp) on update current_timestamp);
 create table t1(a int ,b timestamptz default cast('2018-7-25 13:25:00' as datetime) on update current_timestamp);
 create table t2(a int ,b timestamptz default cast('2018-7-25 13:25:00' as datetimetz) on update current_timestamp);
 create table t3(a int ,b timestamptz default cast('2018-7-25 13:25:00' as timestamptz) on update current_timestamp);

insert t(a) values(1),(2),(3),(4);
insert t2(a) values(1),(2),(3),(4);
 select * from t order by 1;
 select * from t2 order by 1;
 update t set a=a+1;
 select if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') from t;
 update t2 set a=1;
 select if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') from t2;
drop if exists t,t1,t2,t3;


