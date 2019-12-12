--+ holdcas on;
--test sys date doesn't change as the session time zone setting
set timezone '-12:00';
set @v1=(select sys_date);
set timezone '+14:00';
set @v2=(select sys_date);
select if(day(@v2)=day(@v1),'ok','nok');
drop variable @v2,@v1;


set timezone '-12:00';
set @v1=(select sysdate);
set timezone '+14:00';
set @v2=(select sysdate);
select if(day(@v2)=day(@v1),'ok','nok');
drop variable @v2,@v1;

--for date type,timediff has below limit
--select timediff('2015-8-6','2015-8-5') : print error
--select timediff('2015-8-6','2015-8-6') : execute succussfully
drop table if exists t;
create table t(i string unique);
set timezone '+9:00';
insert into t select timediff(sys_date,current_date());
set timezone '+9:00';
insert into t select datediff(sys_date,current_date());
drop table if exists t;

set timezone 'Asia/Seoul';

--+ holdcas off;
