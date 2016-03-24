--+ holdcas on;
set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=yes';
select if(abs(unix_timestamp()-unix_timestamp(current_timestamp))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(current_timestamp()))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtime()))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtime))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtimestamp))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtimestamp()))<=3,'ok','nok');

select if(abs(unix_timestamp()-unix_timestamp(sys_timestamp))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(systimestamp))<=3,'ok','nok');


set timezone 'America/New_York';
select if(abs(unix_timestamp()-unix_timestamp(current_timestamp))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(current_timestamp()))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtime()))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtime))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtimestamp))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtimestamp()))<=3,'ok','nok');



set timezone '+03:00';
select if(abs(unix_timestamp()-unix_timestamp(current_timestamp))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(current_timestamp()))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtime()))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtime))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtimestamp))<=3,'ok','nok');
select if(abs(unix_timestamp()-unix_timestamp(localtimestamp()))<=3,'ok','nok');

select if(unix_timestamp()-unix_timestamp(sys_timestamp)=-21600,'ok','nok');
select if(unix_timestamp()-unix_timestamp(systimestamp)=-21600,'ok','nok');

set timezone 'default';
set system parameters 'tz_leap_second_support=no';
--+ holdcas off;


