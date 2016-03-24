--'Indian/Antananarivo' has problem
--sql/_27_banana_qa/issue_5765_timezone_support/_09_timezone_rules/cases/africa.sql has reflected this error 

set timezone 'Africa/Tripoli';
set @a=(select datetimeltz'1951-10-14 1:59:59');
select datetimetz'1951-10-14 2:59:59';
select datetimeltz'1951-10-14 2:59:59';
select datetimeltz'1951-10-14 3:00:00';
select to_datetime_tz(addtime(@a,time'1:00:00'));
select addtime(datetimeltz'1951-10-14 1:59:59',time'1:00:00');



set @a=(select datetimeltz'1953-10-9 1:59:59');
select datetimetz'1953-10-9 2:59:59';
select datetimeltz'1953-10-9 2:59:59';
select datetimeltz'1953-10-9 3:00:00';
select to_datetime_tz(addtime(@a,time'1:00:00'));
select addtime(datetimeltz'1953-10-9 1:59:59',time'1:00:00');


set timezone 'Indian/Antananarivo';
set @a=(select datetimeltz'1954-2-27 22:59:59');
select datetimetz'1954-2-27 22:59:59';
select datetimeltz'1954-2-27 22:59:59';
select datetimeltz'1954-2-27 23:30:00';
select to_datetime_tz(addtime(@a,time'1:00:00'));
select addtime(datetimeltz'1954-2-27 22:59:59',time'1:00:00');


set timezone 'Indian/Mauritius';
set @a=(select datetimeltz'1982-10-9 23:59:59');
select datetimetz'1982-10-9 23:59:59';
select datetimeltz'1982-10-9 23:59:59';
select datetimeltz'1982-10-10 00:30:00 am';
select to_datetime_tz(addtime(@a,time'1:00:00'));
select addtime(datetimeltz'1982-10-9 23:59:59',time'1:00:00');

set timezone 'Africa/Casablanca';
set @a=(select datetimeltz'1977-4-30 23:59:59');
select datetimetz'1977-4-30 23:59:59';
select datetimeltz'1977-4-30 23:59:59';
select datetimeltz'1977-5-1 00:30:00 am';
select to_datetime_tz(addtime(@a,time'1:00:00'));
select addtime(datetimeltz'1977-4-30 23:59:59',time'1:00:00');

set timezone 'Africa/Windhoek';
set @a=(select datetimeltz'1994-9-4 1:59:59');
select datetimetz'1994-9-4 1:59:59';
select datetimeltz'1994-9-4 1:59:59';
select datetimeltz'1994-9-4 2:30:00';
select to_datetime_tz(addtime(@a,time'1:00:00'));
select addtime(datetimeltz'1994-9-4 1:59:59',time'1:00:00');

set timezone 'Africa/Freetown';
set @a=(select datetimeltz'1942-5-31 23:59:59');
select datetimetz'1942-5-31 23:59:59';
select datetimeltz'1942-5-31 23:59:59';
select datetimeltz'1942-6-1 00:30:00';
select datetimeltz'1942-6-1 00:40:00';
select datetimeltz'1942-6-1 00:50:00';
select to_datetime_tz(addtime(@a,time'00:40:00'));
select addtime(datetimeltz'1942-5-31 23:59:59',time'00:40:00');

set timezone 'Africa/Khartoum';
set @a=(select datetimeltz'1971-4-29 23:59:59');
select datetimetz'1971-4-29 23:59:59';
select datetimeltz'1971-4-29 23:59:59';
select datetimeltz'1971-4-30 00:30:00';
select to_datetime_tz(addtime(@a,time'1:00:00'));
select addtime(datetimeltz'1971-4-29 23:59:59',time'1:00:00');

set timezone 'Africa/Juba';
set @a=(select datetimeltz'1971-4-29 23:59:59');
select datetimetz'1971-4-29 23:59:59';
select datetimeltz'1971-4-29 23:59:59';
select datetimeltz'1971-4-30 00:30:00';
select to_datetime_tz(addtime(@a,time'1:00:00'));
select addtime(datetimeltz'1971-4-29 23:59:59',time'1:00:00');

set timezone 'Africa/Tunis';
set @a=(select datetimeltz'2005-4-30 23:59:59');
select datetimetz'2005-4-30 23:59:59';
select datetimeltz'2005-4-30 23:59:59';
select datetimeltz'2005-5-1 00:30:00';
select to_datetime_tz(addtime(@a,time'1:00:00'));
select addtime(datetimeltz'2005-4-30 23:59:59',time'1:00:00');

set timezone 'Asia/Seoul';




