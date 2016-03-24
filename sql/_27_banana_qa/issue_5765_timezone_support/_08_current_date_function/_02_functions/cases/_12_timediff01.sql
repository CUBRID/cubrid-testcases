--+ holdcas on;
--CUBRIDSUS-17374,when set timezone < +09:00,not supported
--set timezone 'Asia/Shanghai';
--select timediff(current_timestamp,systimestamp);
--select timediff(current_datetime,sysdatetime);
--select timediff(current_time,systime);
--select timediff(current_date,sysdate);
--select timediff(current_datetime,now());
--set timezone '-12:00';
--select timediff(current_date,sysdate);


set timezone '+10:00';
select timediff(current_timestamp,systimestamp);
select timediff(current_timestamp(),systimestamp);
select timediff(localtimestamp,systimestamp);
select timediff(localtimestamp(),systimestamp);
select timediff(localtime,systimestamp);
select timediff(localtime(),systimestamp);
select timediff(current_timestamp,sys_timestamp);
select timediff(current_timestamp(),sys_timestamp);
select timediff(localtimestamp,sys_timestamp);
select timediff(localtimestamp(),sys_timestamp);
select timediff(localtime,sys_timestamp);
select timediff(localtime(),sys_timestamp);
select timediff(current_datetime,sysdatetime);
select timediff(current_datetime(),sysdatetime);
select timediff(now(),sysdatetime);
select timediff(current_datetime,sys_datetime);
select timediff(current_datetime(),sys_datetime);
select timediff(now(),sys_datetime);
select timediff(current_datetime,now());

set timezone '+12:00';
select timediff(current_datetime,sysdatetime);
select timediff(current_timestamp,systimestamp);

select timediff(current_datetime,new_time(current_datetime,sessiontimezone,dbtimezone));

select timediff(current_datetime,new_time(sys_datetime,dbtimezone,sessiontimezone));
select timediff(current_time,new_time(sys_time,dbtimezone,sessiontimezone));

select timediff(current_datetime,new_time(sys_datetime,dbtimezone,'Asia/Shanghai'));
select timediff(current_datetime,new_time(sys_datetime,dbtimezone,'+08:30'));

select timediff(current_datetime,new_time(current_datetime,dbtimezone,'Asia/Shanghai'));
select timediff(current_datetime,new_time(current_datetime,dbtimezone,'+08:25'));

select timediff(current_datetime,new_time(current_datetime,dbtimezone,'UTC'));
select timediff(current_datetime,new_time(current_datetime,dbtimezone,'+00:00'));

select timediff(current_datetime,new_time(current_datetime,sessiontimezone,'UTC'));
select if (current_time>utc_time(),timediff(current_time,new_time(current_time,sessiontimezone,'UTC')),timediff(new_time(current_time,sessiontimezone,'UTC'),current_time));
select timediff(current_datetime,new_time(current_datetime,sessiontimezone,'+00:00'));
select if (current_time>utc_time(),timediff(current_time,new_time(current_time,sessiontimezone,'+00:00')),timediff(new_time(current_time,sessiontimezone,'+00:00'),current_time));

set timezone 'Asia/Seoul';
--+ holdcas off;
