--+ holdcas on;
-- modified for timezone difference of two cities
set @x1=(select adddate(current_date,interval 1 month));
set @x2=(select add_months(current_date,1));
select if(month(@x1)-month(@x2)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+00:00';
set @x1=(select adddate(current_date,interval 1 month));
set timezone '+00:00:01';
set @x2=(select add_months(current_date,1));
select if(month(@x1)-month(@x2)=0,'ok','nok');
drop variable @x1,@x2;

set timezone '+12:00';
set @x1=(select adddate(current_date,interval 1 month));
set timezone '-12:00:00';
set @x2=(select add_months(current_date,1));
select if(month(@x1)-month(@x2) in (0,1,-11),'ok','nok');
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(current_date,interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_date,1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(current_datetime,interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_datetime,1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(curdate(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(curdate(),1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(current_date(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_date(),1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;

et timezone 'America/Chicago';
set @x1=(select adddate(now(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(now(),1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(current_datetime(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_datetime(),1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(current_timestamp,interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_timestamp,1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;


set timezone 'America/Chicago';
set @x1=(select adddate(current_timestamp(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(current_timestamp(),1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(localtimestamp,interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(localtimestamp,1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(localtimestamp(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(localtimestamp(),1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;


set timezone 'America/Chicago';
set @x1=(select adddate(localtime,interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(localtime,1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;

set timezone 'America/Chicago';
set @x1=(select adddate(localtime(),interval 1 month));
set timezone 'America/Los_Angeles';
set @x2=(select add_months(localtime(),1));
select if(month(@x1)-month(@x2) in (0,1,-11), 'ok', 'nok');
drop variable @x1,@x2;

set timezone 'Asia/Seoul';




--+ holdcas off;
