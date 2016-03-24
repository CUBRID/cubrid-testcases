--select boundary data of DATETIMETZ type in different time zones


--test: [er] set out-of-range and invalid time zones
set timezone '+15:00';
select datetimetz'2000-12-12 12:12:12 AM';
select datetimetz'2000-12-12 12:12:12 AM +15:00';
set timezone '-14:00';
select datetimetz'0001-01-01 00:00:00';
select datetimetz'0001-01-01 00:00:00 -14:00:00';
set timezone '+24:00';
select datetimetz'9999-12-31 23:59:59'; 
select datetimetz'9999-12-31 23:59:59 +24:00'; 
set timezone '-24:00';
select datetimetz'0001-01-01 00:00:00';
select datetimetz'0001-01-01 00:00:00 -24:00';
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
select datetimetz'0001-01-01 12:00:00 PM +12:00';
select datetimetz'0001-01-01 12:00:00 PM +12:01';
select datetimetz'0001-01-01 12:00:00 AM -2:00' - (1000*3600*2+1);
set timezone '+3:00';
select datetimetz'9999-12-31 23:59:59 GMT';
select datetimetz'0001-01-01 00:00:00';
select datetimetz'9999-12-31 23:59:59 Asia/Seoul' + 1000*3600*9+1;
select datetimetz'9999-12-31 22:59:59 GMT' + 3600*1000;
set timezone '-2:00';
select datetimetz'0001-01-01 00:00:00';
select datetimetz'0001-01-01 00:00:00 GMT';
select datetimetz'0001-01-01 1:00:00 GMT' - 3600*1000;
select datetimetz'9999-12-31 23:59:59';

set timezone 'Asia/Seoul';
