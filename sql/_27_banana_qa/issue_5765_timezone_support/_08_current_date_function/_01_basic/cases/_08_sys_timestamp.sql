--test current timestamp doesn't change as the session time zone setting
set timezone '+02:30';
set @x1=(select sys_timestamp);
set timezone '+01:30';
set @x2=(select sys_timestamp);
select if(hour(@x2)=hour(@x1),'ok','nok');
drop variable @x2,@x1;

set timezone '+02:30';
set @x1=(select systimestamp);
set timezone '+01:30';
set @x2=(select systimestamp);
select if(hour(@x2)=hour(@x1),'ok','nok');
drop variable @x2,@x1;

drop table if exists t;
create table t(i string unique);
set timezone '+4:00';
insert into t select timediff(sys_timestamp,utc_timestamp());
set timezone '+2:00';
insert into t select timediff(sys_timestamp,utc_timestamp());
drop table if exists t;
set timezone 'Asia/Seoul';


