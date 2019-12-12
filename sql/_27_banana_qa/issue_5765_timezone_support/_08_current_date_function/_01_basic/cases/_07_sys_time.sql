--+ holdcas on;
--test sys time doesn't change as the session time zone setting
set timezone '+02:30';
set @x2=(select sys_time);
set timezone '+01:30';
set @x1=(select sys_time);
select if(hour(@x1)=hour(@x2),'ok','nok');
drop variable @x2,@x1;

set timezone '+02:30';
set @x2=(select systime);
set timezone '+01:30';
set @x1=(select systime);
select if(hour(@x1)=hour(@x2),'ok','nok');
drop variable @x2,@x1;

--for time type,timediff has below limit
--select timediff('2:00:00 am','11:00:00 pm') : print error
drop table if exists t;
create table t(i string unique);
set timezone '+9:00';
insert into t select timediff(sys_time,current_time());
set timezone 'Asia/Seoul';
insert into t select timediff(sys_time,current_time());
drop table if exists t;
set timezone 'Asia/Seoul';








--+ holdcas off;
