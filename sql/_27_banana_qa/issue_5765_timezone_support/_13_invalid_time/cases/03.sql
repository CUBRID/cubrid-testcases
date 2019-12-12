--+ holdcas on;
--'Indian/Antananarivo' has problem
--sql/_27_banana_qa/issue_5765_timezone_support/_09_timezone_rules/cases/africa.sql has reflected this error 

set timezone 'Africa/Cairo';
set @a=(select timestamptz'2010-9-9 23:59:59');
select timestamptz'2010-9-9 23:59:59';
select timestampltz'2010-9-9 23:59:59';
select timestampltz'2010-9-10 00:30:00';
select to_timestamp_tz(addtime(@a,time'1:00:00'));
select addtime(timestampltz'2010-9-9 23:59:59',time'1:00:00');

set timezone 'Africa/Algiers';
set @a=(select timestamptz'1980-4-24 23:59:59');
select timestamptz'1980-4-24 23:59:59';
select timestampltz'1980-4-24 23:59:59';
select timestampltz'1980-4-25 00:30:00';
select to_timestamp_tz(addtime(@a,time'1:00:00'));
select addtime(timestampltz'1980-4-24 23:59:59',time'1:00:00');




set timezone 'Africa/Tripoli';
set @a=(select timestampltz'1987-3-31 23:59:59');
select timestamptz'1987-3-31 23:59:59';
select timestampltz'1987-3-31 23:59:59';
select timestampltz'1987-4-1 00:30:00';
select to_timestamp_tz(addtime(@a,time'1:00:00'));
select addtime(timestampltz'1987-3-31 23:59:59',time'1:00:00');


set timezone 'Indian/Mauritius';
set @a=(select timestampltz'1982-10-9 23:59:59');
select timestamptz'1982-10-9 23:59:59';
select timestampltz'1982-10-9 23:59:59';
select timestampltz'1982-10-10 00:30:00 am';
select to_timestamp_tz(addtime(@a,time'1:00:00'));
select addtime(timestampltz'1982-10-9 23:59:59',time'1:00:00');

set timezone 'Africa/Casablanca';
set @a=(select timestampltz'1977-4-30 23:59:59');
select timestamptz'1977-4-30 23:59:59';
select timestampltz'1977-4-30 23:59:59';
select timestampltz'1977-5-1 00:30:00 am';
select to_timestamp_tz(addtime(@a,time'1:00:00'));
select addtime(timestampltz'1977-4-30 23:59:59',time'1:00:00');

set timezone 'Africa/Windhoek';
set @a=(select timestampltz'1994-9-4 1:59:59');
select timestamptz'1994-9-4 1:59:59';
select timestampltz'1994-9-4 1:59:59';
select timestampltz'1994-9-4 2:30:00';
select to_timestamp_tz(addtime(@a,time'1:00:00'));
select addtime(timestampltz'1994-9-4 1:59:59',time'1:00:00');


set timezone 'Africa/Khartoum';
set @a=(select timestampltz'1971-4-29 23:59:59');
select timestamptz'1971-4-29 23:59:59';
select timestampltz'1971-4-29 23:59:59';
select timestampltz'1971-4-30 00:30:00';
select to_timestamp_tz(addtime(@a,time'1:00:00'));
select addtime(timestampltz'1971-4-29 23:59:59',time'1:00:00');

set timezone 'Africa/Juba';
set @a=(select timestampltz'1971-4-29 23:59:59');
select timestamptz'1971-4-29 23:59:59';
select timestampltz'1971-4-29 23:59:59';
select timestampltz'1971-4-30 00:30:00';
select to_timestamp_tz(addtime(@a,time'1:00:00'));
select addtime(timestampltz'1971-4-29 23:59:59',time'1:00:00');

set timezone 'Africa/Tunis';
set @a=(select timestampltz'2005-4-30 23:59:59');
select timestamptz'2005-4-30 23:59:59';
select timestampltz'2005-4-30 23:59:59';
select timestampltz'2005-5-1 00:30:00';
select to_timestamp_tz(addtime(@a,time'1:00:00'));
select addtime(timestampltz'2005-4-30 23:59:59',time'1:00:00');

set timezone 'Asia/Seoul';

drop variable @a;




--+ holdcas off;
