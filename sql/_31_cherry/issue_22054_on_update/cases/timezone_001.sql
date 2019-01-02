drop if exists t;
create table t(
a int,
time1 timestampltz on update current_timestamp,
time2 timestamptz on update current_timestamp
);
insert into t(a) values(1);
	
set timezone 'Asia/Shanghai';
update t set a=2;
select if(to_timestamp_tz(current_timestamp)-time1>=0 and to_timestamp_tz(current_timestamp)-time1<10,'ok','nok') from t where a=2;
select if(to_timestamp_tz(current_timestamp)-time2>=0 and to_timestamp_tz(current_timestamp)-time2<10,'ok','nok') from t where a=2;
	
set timezone 'America/New_York';
select sleep(3);
update t set a=3;
select if(to_timestamp_tz(current_timestamp)-time1>=0 and to_timestamp_tz(current_timestamp)-time1<10,'ok','nok') from t where a=3;
select if(to_timestamp_tz(current_timestamp)-time2>=0 and to_timestamp_tz(current_timestamp)-time2<10,'ok','nok') from t where a=3; 
drop if exists t;

