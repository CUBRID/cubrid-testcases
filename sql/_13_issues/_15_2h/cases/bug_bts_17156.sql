drop table if exists tz_test;
create table tz_test(tsltz timestamp with local time zone, tstz timestamp with time zone);
select decode(tsltz, tstz, datetimetz'1999-01-01 10:00:00 AM', timestamptz'0000-00-00 00:00:00') as rs from tz_test order by 1;
drop table if exists tz_test;
