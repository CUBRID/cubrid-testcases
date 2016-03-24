--select boundary data of TIMESTAMPLTZ type in different time zones


--test: [er] set out-of-range and invalid time zones
set timezone '+15:00';
select timestampltz'2000-12-12 12:12:12 AM';
select timestampltz'2000-12-12 12:12:12 AM +15:00';
set timezone '-14:00';
select timestampltz'1969-12-31 10:00:01';
select timestampltz'1969-12-31 10:00:01 -14:00:00';
set timezone '+24:00';
select timestampltz'2038-01-20 03:14:07'; 
select timestampltz'2038-01-20 03:14:07 +24:00'; 
set timezone '-24:00';
select timestampltz'1969-12-31 00:00:00';
select timestampltz'1969-12-31 00:00:00 -24:00';
set timezone '+99:00';
set timezone '-100:00';
set timezone '+12.0';
set timezone '+++';
set timezone '---';
set timezone '12';
set timezone '-5';
set timezone 'abc';
set timezone '+0.1';
set timezone '-5.55';

set timezone '+00:00';
select timestampltz'1969-12-31 12:00:00 PM -12:00';
select timestampltz'1969-12-31 23:00:00 -2:00' - 3601;
set timezone '-3:00';
select timestampltz'2038-01-19 00:14:07' + 1;
select timestampltz'2038-01-19 10:14:07 Asia/Seoul' + 3600*2;
select timestampltz'2038-01-19 10:14:07 Asia/Seoul' + 3600*3;
set timezone '+2:00';
select timestampltz'1970-01-01 2:00:00' - 1;
select timestampltz'1970-01-01 3:00:00 +3:00';
select timestampltz'1970-01-01 3:00:00 +3:00' -1;


set timezone 'Asia/Seoul';
