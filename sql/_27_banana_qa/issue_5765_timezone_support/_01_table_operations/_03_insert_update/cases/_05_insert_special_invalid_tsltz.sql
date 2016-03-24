--insert into TIMESTAMPLTZ columns, with special and invalid values
set system parameters 'tz_leap_second_support=yes';

set timezone 'UTC';

drop table if exists tz_test;
create table tz_test(id int auto_increment, col timestamp with local time zone);

--test: [er] test with invalid time zone values
insert into tz_test(col) values(timestampltz'2000-03-28 08:00:00 +1:34');
insert into tz_test(col) values(timestampltz'2000-03-28 08:00:00 -05:00:00');
insert into tz_test(col) values(timestampltz'08:22:50 AM 06/23/2014 0');
insert into tz_test(col) values(timestampltz'13:15:45 10/31/2008 0:0');
insert into tz_test(col) values(timestampltz'01:15:45 PM 2008-10-31 -12');
insert into tz_test(col) values(timestampltz'13:15:45 2008-10-31 +abc');
insert into tz_test(col) values(timestampltz'10/31/2008 01:15:45 PM Asia/Unknown');
insert into tz_test(col) values(timestampltz'10/31/2008 13:15:45 +10.0');
insert into tz_test(col) values(timestampltz'2008-10-31 01:15:45 PM -12.30');
insert into tz_test(col) values(timestampltz'2008-10-31 13:15:45 Some/Zone');

select * from tz_test order by 1;


--test: test with special values
set timezone 'MET';
--test: Values around and in spring time-gap
insert into tz_test(col) values(unix_timestamp(timestamp'2003-03-30 01:59:59'));
insert into tz_test(col) values(unix_timestamp(timestamp'2003-03-30 02:59:59'));
insert into tz_test(col) values(unix_timestamp(timestamp'2003-03-30 03:00:00'));
select * from tz_test order by 1;
--test: Normal value with DST
insert into tz_test(col) values(unix_timestamp(timestamp'2003-05-01 00:00:00'));
select * from tz_test order by 1;
--test: Ambiguos values (also check for determenism)
insert into tz_test(col) values(unix_timestamp(timestamp'2003-10-26 01:00:00'));
insert into tz_test(col) values(unix_timestamp(timestamp'2003-10-26 02:00:00'));
insert into tz_test(col) values(unix_timestamp(timestamp'2003-10-26 02:59:59'));
insert into tz_test(col) values(unix_timestamp(timestamp'2003-10-26 04:00:00'));
insert into tz_test(col) values(unix_timestamp(timestamptz'2003-10-26 02:59:59 MET MET'));
select * from tz_test order by 1;
--test: leap seconds
insert into tz_test(col) values(timestamp'1981-07-01 01:59:59');
insert into tz_test(col) values(timestamp'1981-07-01 02:00:00');
select *, unix_timestamp(col) from tz_test order by 1;
insert into tz_test(col) values(from_unixtime(362793609));
insert into tz_test(col) values(from_unixtime(362793610));
select * from tz_test order by 1;


--test: ambiguous values
set timezone 'Asia/Seoul';
insert into tz_test(col) values(timestampltz'1987-10-11 2:11:12');
insert into tz_test(col) values(timestampltz'1987-10-11 2:11:12 Asia/Seoul');
insert into tz_test(col) values(timestampltz'1987-10-11 2:11:12 Asia/Seoul KST');
insert into tz_test(col) values(timestampltz'1987-10-11 2:11:12 Asia/Seoul KDT');
select * from tz_test order by 1;


--test: [er] unmatched timezone
insert into tz_test(col) values(timestampltz'1987-10-09 23:11:12 Asia/Seoul KST');
insert into tz_test(col) values(timestampltz'1987-10-11 23:11:12 Asia/Seoul KDT');


drop table tz_test;


set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
