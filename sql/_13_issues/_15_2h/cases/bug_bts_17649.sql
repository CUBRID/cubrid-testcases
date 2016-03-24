drop table if exists tz_test;
set timezone 'Asia/Seoul';
create table tz_test(id int auto_increment, col1 timestamp with local time zone not null default timestamptz'2014-09-01 2:00:20 Asia/Shanghai', col2 timestamp with time zone);
--DST related(utc+3)
set timezone 'Europe/Bucharest';
insert into tz_test(col1, col2) values(timestampltz'1992-07-10 3:00:00 Europe/Bucharest', timestamptz'1992-07-10 3:00:00 Europe/Bucharest');
set timezone '+2:00';
insert into tz_test(col1, col2) values(timestampltz'1992-07-10 2:00:00', timestamptz'1992-07-10 2:00:00');
create index idx3 on tz_test(col1, col2);
update statistics on all classes with fullscan;
set timezone 'Europe/Bucharest';
--@queryplan
select /*+ recompile */ id ,col1, col2 from tz_test where col1=timestampltz'1992-07-10 3:00:00 Europe/Bucharest' order by col1;
--@queryplan
select /*+ recompile */ col1, col2 from tz_test where col1=timestampltz'1992-07-10 3:00:00 Europe/Bucharest' order by col1;


drop table if exists tz_test;
set timezone 'Asia/Seoul';
create table tz_test(id int auto_increment, col1 datetime with local time zone not null default timestamptz'2014-09-01 2:00:20 Asia/Shanghai', col2 datetime with time zone);
--DST related(utc+3)
set timezone 'Europe/Bucharest';
insert into tz_test(col1, col2) values(timestampltz'1992-07-10 3:00:00 Europe/Bucharest', timestamptz'1992-07-10 3:00:00 Europe/Bucharest');
set timezone '+2:00';
insert into tz_test(col1, col2) values(timestampltz'1992-07-10 2:00:00', timestamptz'1992-07-10 2:00:00');
create index idx3 on tz_test(col1, col2);
update statistics on all classes with fullscan;
set timezone 'Europe/Bucharest';
--@queryplan
select /*+ recompile */ id ,col1, col2 from tz_test where col1=timestampltz'1992-07-10 3:00:00 Europe/Bucharest' order by col1;
--@queryplan
select /*+ recompile */ col1, col2 from tz_test where col1=timestampltz'1992-07-10 3:00:00 Europe/Bucharest' order by col1;

drop table if exists tz_test;
set timezone 'default';
