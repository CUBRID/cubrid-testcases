--+ holdcas on;
set @x1=(select adddate(current_date,interval 1 month));
set @x2=(select add_months(current_date,1));
select if(month(@x1)-month(@x2)=0, 'ok',  concat('nok, ',  month(@x1)- month(@x2),', ',now()) );
drop variable @x1,@x2;

set timezone '+00:00';
set @x1=(select adddate(current_date,interval 1 month));
set timezone '+00:00:01';
set @x2=(select add_months(current_date,1));
select if(month(@x1)-month(@x2)=0, 'ok',  concat('nok, ',  month(@x1)- month(@x2),', ',now() ));
drop variable @x1,@x2;

set timezone '+12:00';
set @x1=(select adddate(current_date,interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone '-12:00:00';
set @x2=(select add_months(current_date,1));
--select if(month(@x1)-month(@x2) in (0,1,-11),'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1),
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-2 0:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-2 0:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(current_date,interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_date,1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from 
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1), 
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;

drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(current_datetime,interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_datetime,1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1),
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(curdate(),interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(curdate(),1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from 
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1), 
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(current_date(),interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_date(),1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from 
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1), 
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(now(),interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(now(),1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from 
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1), 
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(current_datetime(),interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_datetime(),1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from 
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1), 
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(current_timestamp,interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_timestamp,1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from 
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1), 
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;


set timezone 'America/Chicago';
set @x1=(select adddate(current_timestamp(),interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_timestamp(),1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from 
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1), 
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(localtimestamp,interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(localtimestamp,1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from 
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1), 
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(localtimestamp(),interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(localtimestamp(),1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from 
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1), 
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;


set timezone 'America/Chicago';
set @x1=(select adddate(localtime,interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(localtime,1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from 
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1), 
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(localtime(),interval 1 month));
set @x_cur=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(localtime(),1));
--select if(month(@x1)-month(@x2)=0,'ok','nok');
select if(month(@x1)-month(@x2)=expect_value, 'ok', concat('nok, ',month(@x1)-month(@x2),', ', expect_value,', ',now())) from 
(
  select @x1_year:=year(@x1), @x1_month:=month(@x1), 
    CASE WHEN @x_cur <= TIMESTAMP(@x1_year||'-1-1 2:00') THEN -11
    WHEN @x_cur <= TIMESTAMP(@x1_year||'-'||@x1_month||'-1 2:00') THEN 1
    ELSE 0 END expect_value
) t;
drop variable @x1,@x2;

set timezone 'Asia/Seoul';




--+ holdcas off;
