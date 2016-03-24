set timezone 'Asia/Seoul'; 

select timestamp'2000-12-31 23:00:00'-1;
select timestampltz'2000-12-31 23:00:00 +9:00'-1;
select timestamptz'2000-12-31 23:00:00 +8:00'-1;
select timestamptz'2000-12-31 23:00:00 Asia/Chongqing'-1;

select timestamp'2000-12-31 23:00:00'+1;
select timestampltz'2000-12-31 23:00:00 +9:00'+1;
select timestampltz'2000-12-31 23:00:00 Asia/Seoul'+1;
select timestamptz'2000-12-31 23:00:00 +8:00'+1;

set system parameters 'tz_leap_second_support=yes';

select timestamp'2000-12-31 23:00:00'-1;
select timestampltz'2000-12-31 23:00:00 +9:00'-1;
select timestamptz'2000-12-31 23:00:00 +8:00'-1;
select timestamptz'2000-12-31 23:00:00 Asia/Chongqing'-1;

select timestamp'2000-12-31 23:00:00'+1;
select timestampltz'2000-12-31 23:00:00 +9:00'+1;
select timestampltz'2000-12-31 23:00:00 Asia/Seoul'+1;
select timestamptz'2000-12-31 23:00:00 +8:00'+1;

set system parameters 'tz_leap_second_support=no';

