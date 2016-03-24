set timezone 'Asia/Seoul';
drop table if exists tz;
create table tz(tsltz timestamp with local time zone, tstz timestamp with time zone);
insert into tz values(timestamptz'2013-02-28 23:59:59 UTC', timestamptz'2013-02-28 23:59:59 UTC');
select subdate(tsltz, interval 1 year), subdate(tstz, interval 1 year) from tz;
select if(subdate(tsltz, interval 1 year)=subdate(tstz, interval 1 year), 'ok', 'nok') from tz;

drop table if exists tz;
create table tz(dtltz datetime with local time zone, dttz datetime with time zone);
insert into tz values(datetimetz'2013-02-28 23:59:59 UTC', datetimetz'2013-02-28 23:59:59 UTC');
select subdate(dtltz, interval 1 year), subdate(dttz, interval 1 year) from tz;
select if(subdate(dtltz, interval 1 year)=subdate(dttz, interval 1 year), 'ok', 'nok') from tz;

drop table if exists tz;
create table tz(dtltz datetime with local time zone, dttz datetime with time zone);
insert into tz values(timestamptz'2013-02-28 23:59:59 UTC', timestamptz'2013-02-28 23:59:59 UTC');
select subdate(dtltz, interval 1 year), subdate(dttz, interval 1 year) from tz;
select if(subdate(dtltz, interval 1 year)=subdate(dttz, interval 1 year), 'ok', 'nok') from tz;


set timezone 'Asia/Seoul';
drop table if exists tz;
create table tz(tsltz timestamp with local time zone, tstz timestamp with time zone);
insert into tz values(timestamptz'2013-02-28 23:59:59 UTC', timestamptz'2013-02-28 23:59:59 UTC');
select adddate(tsltz, interval 1 year), adddate(tstz, interval 1 year) from tz;
select if(adddate(tsltz, interval 1 year)=adddate(tstz, interval 1 year), 'ok', 'nok') from tz;

drop table if exists tz;
create table tz(dtltz datetime with local time zone, dttz datetime with time zone);
insert into tz values(datetimetz'2013-02-28 23:59:59 UTC', datetimetz'2013-02-28 23:59:59 UTC');
select adddate(dtltz, interval 1 year), adddate(dttz, interval 1 year) from tz;
select if(adddate(dtltz, interval 1 year)=adddate(dttz, interval 1 year), 'ok', 'nok') from tz;

drop table if exists tz;
create table tz(dtltz datetime with local time zone, dttz datetime with time zone);
insert into tz values(timestamptz'2013-02-28 23:59:59 UTC', timestamptz'2013-02-28 23:59:59 UTC');
select adddate(dtltz, interval 1 year), adddate(dttz, interval 1 year) from tz;
select if(adddate(dtltz, interval 1 year)=adddate(dttz, interval 1 year), 'ok', 'nok') from tz;

set timezone 'Asia/Seoul';
drop table if exists tz;
create table tz(tsltz timestamp with local time zone, tstz timestamp with time zone);
insert into tz values(timestamptz'2011-02-28 23:59:59 UTC', timestamptz'2011-02-28 23:59:59 UTC');
select adddate(tsltz, interval 1 year), adddate(tstz, interval 1 year) from tz;
select if(adddate(tsltz, interval 1 year)=adddate(tstz, interval 1 year), 'ok', 'nok') from tz;

drop table if exists tz;
create table tz(tsltz timestamp with local time zone, tstz timestamp with time zone);
insert into tz values(timestamptz'2012-02-29 23:59:59 UTC', timestamptz'2012-02-29 23:59:59 UTC');
select adddate(tsltz, interval 1 year), adddate(tstz, interval 1 year) from tz;
select if(adddate(tsltz, interval 1 year)=adddate(tstz, interval 1 year), 'ok', 'nok') from tz;

drop table if exists tz;
