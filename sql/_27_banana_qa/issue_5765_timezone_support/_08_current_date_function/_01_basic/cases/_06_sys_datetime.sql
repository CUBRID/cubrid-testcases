--+ holdcas on;
--test sys datetime can change as the datebase time zone setting
--but not change as the session time zone setting
set timezone '+02:30';
set @v1=(select sys_datetime);
set timezone '+01:30';
set @v2=(select sys_datetime);
select if(hour(@v1)=hour(@v2),'ok','nok');
drop variable @v2,@v1;



set timezone '+02:30';
set @v1=(select sysdatetime);
set timezone '+01:30';
set @v2=(select sysdatetime);
select if(hour(@v1)=hour(@v2),'ok','nok');
drop variable @v2,@v1;


drop table if exists t;
create table t(i string unique);
set timezone '+4:00';
insert into t select timediff(sys_datetime,utc_timestamp());
set timezone '+2:00';
insert into t select timediff(sys_datetime,utc_timestamp());
drop table if exists t;
set timezone 'Asia/Seoul';



--+ holdcas off;
