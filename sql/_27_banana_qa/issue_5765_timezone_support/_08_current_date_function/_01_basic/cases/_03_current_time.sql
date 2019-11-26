--+ holdcas on;
--test current time can change as the time zone setting
--if v1='2000-1-1 23:30:00',if v2='2000-1-2 12:30:00 am'
--hour(v2)-hour(v1)=-23,not 1
--if v1='2000-1-1 23:59:59',if v2='2000-1-2 1:00:00 am'
--hour(v2)-hour(v1)=-22,not 2
set timezone '+01:30';
set @v1=(select current_time);
set timezone '+02:30';
set @v2=(select current_time);
select if(hour(@v2)-hour(@v1)=1 or hour(@v2)-hour(@v1)=2 or hour(@v2)-hour(@v1)=-22 or hour(@v2)-hour(@v1)=-23,'ok','nok');
drop variable @v2,@v1;


set timezone '+01:30';
set @v1=(select current_time());
set timezone '+02:30';
set @v2=(select current_time());
select if(hour(@v2)-hour(@v1)=1 or hour(@v2)-hour(@v1)=2 or hour(@v2)-hour(@v1)=-22 or hour(@v2)-hour(@v1)=-23,'ok','nok');
drop variable @v2,@v1;


set timezone '+01:30';
set @v1=(select curtime());
set timezone '+02:30';
set @v2=(select curtime());
select if(hour(@v2)-hour(@v1)=1 or hour(@v2)-hour(@v1)=2 or hour(@v2)-hour(@v1)=-22 or hour(@v2)-hour(@v1)=-23,'ok','nok');
drop variable @v2,@v1;

set timezone 'Asia/Seoul';



--+ holdcas off;
