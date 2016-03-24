select adddate(datetimetz'1987-10-11 2:59:59 Asia/Seoul KST', interval '1' second); 
select datetimetz'1987-10-11 2:59:59.999 Asia/Seoul KST' + 1;
select subdate(datetimetz'1987-10-11 3:00:00 am Asia/Seoul KST', interval '1' second); 
select datetimetz'1987-10-11 3:00:00 am Asia/Seoul KST'-1;

select datetimetz'1987-10-11 2:59:59.999 Asia/Seoul KDT' + 1;
select datetimetz'1987-5-10 1:59:59.000 Asia/Seoul KST'+3660000;
select adddate(datetimetz'1987-5-10 1:59:59 Asia/Seoul KST', interval '1:1' hour_minute);
select datetimeltz'1987-5-10 1:59:59.000 Asia/Seoul KST'+3660000;
select adddate(datetimeltz'1987-5-10 1:59:59 Asia/Seoul KST', interval '1:1' hour_minute);
select adddate(datetimetz'1987-10-11 2:59:59 Asia/Seoul KDT', interval '1' second);
select datetimetz'1987-10-11 2:59:59.999 Asia/Seoul KDT' + 1;
select datetimetz'1987-10-11 2:59:59 Asia/Seoul KDT' + 1000;
select datetimetz '1987-10-11 3:00:00 am  Asia/Seoul KST';
select adddate(datetimetz'1987-10-11 2:00:00 Asia/Seoul KST', interval '1' hour);
select adddate(datetimetz'1987-10-11 2:59:59 Asia/Seoul KDT', interval '1' day);
select adddate(datetimetz'1987-10-11 2:59:59 Asia/Seoul KDT', 1);
set timezone 'Asia/Seoul';
select adddate(datetimeltz'1987-10-11 2:59:59', interval '1' second);
select adddate(datetimeltz'1987-10-11 2:59:59', interval '1' second);
select adddate(datetimeltz'1987-5-10 1:59:59', interval '1:1' hour_minute);
select adddate(datetimetz'1987-5-11 1:59:59', interval '1:1' hour_minute); 
set timezone 'Asia/Seoul';

select adddate(timestamptz'1987-10-11 2:59:59 Asia/Seoul KST', interval '1' second); 
select timestamptz'1987-10-11 2:59:59 Asia/Seoul KST' + 1;
select subdate(timestamptz'1987-10-11 3:00:00 am Asia/Seoul KST', interval '1' second); 
select timestamptz'1987-10-11 3:00:00 am Asia/Seoul KST'-1;
select timestamptz'1987-10-11 2:59:59 Asia/Seoul KDT' + 1;
select timestamptz'1987-5-10 1:59:59 Asia/Seoul KST'+3660;

select adddate(timestamptz'1987-5-10 1:59:59 Asia/Seoul KST', interval '1:1' hour_minute);
select timestamptz'1987-5-10 1:59:59 Asia/Seoul KST'+3660;
select adddate(timestamptz'1987-5-10 1:59:59 Asia/Seoul KST', interval '1:1' hour_minute);

select adddate(timestamptz'1987-10-11 2:59:59 Asia/Seoul KDT', interval '1' second);
select subdate(timestamptz'1987-10-11 2:00:00 Asia/Seoul KST', interval '1' second);

select timestamptz'1987-10-11 2:59:59 Asia/Seoul KDT' + 1;
select timestamptz'1987-10-11 2:00:00 Asia/Seoul KST' - 1;

select timestamptz'1987-10-11 3:00:00 am  Asia/Seoul KST';
select adddate(timestamptz'1987-10-11 2:00:00 Asia/Seoul KST', interval '1' hour);
select adddate(timestamptz'1987-10-11 2:59:59 Asia/Seoul KDT', interval '1' day);
select adddate(timestamptz'1987-10-11 2:59:59 Asia/Seoul KDT', 1);
set timezone 'Asia/Seoul';
select adddate(timestamptz'1987-10-11 2:59:59', interval '1' second);
select adddate(timestamptz'1987-5-10 1:59:59', interval '1:1' hour_minute);
select adddate(timestamptz'1987-5-11 1:59:59', interval '1:1' hour_minute); 

set timezone 'Asia/Seoul';
