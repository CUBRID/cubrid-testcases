--+ holdcas on;
--test current date can change as the time zone setting
set timezone '-12:00';
set @x1=(select current_date);
set timezone '+14:00';
set @x2=(select current_date);
select if(day(@x2)-day(@x1) in (1,2,-26,-27,-28,-29,-30),'ok','nok');
drop variable @x1,@x2;



set timezone '-12:00';
set @x1=(select current_date());
set timezone '+14:00';
set @x2=(select current_date());
select if(day(@x2)-day(@x1) in (1,2,-26,-27,-28,-29,-30),'ok','nok');
drop variable @x1,@x2;

set timezone '-12:00';
set @x1=(select curdate());
set timezone '+14:00';
set @x2=(select curdate());
select if(day(@x2)-day(@x1) in (1,2,-26,-27,-28,-29,-30),'ok','nok');
drop variable @x1,@x2;
set timezone 'Asia/Seoul';



--+ holdcas off;
