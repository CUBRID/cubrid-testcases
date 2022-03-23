--test index on DATETIME(L)TZ columns
set system parameters 'tz_leap_second_support=yes';

drop table if exists tz_test;

set timezone 'Asia/Seoul';
create table tz_test(id int auto_increment, col1 datetime with local time zone not null default datetimetz'2014-09-01 2:00:20.999 Asia/Shanghai', col2 datetime with time zone);

insert into tz_test(col1, col2) values(datetimeltz'2013-12-10 15:30:00.999', datetimetz'2013-12-10 15:30:00.999');
insert into tz_test(col1, col2) values(datetimeltz'2011-05-12 9:12:56.999 PM', datetimeltz'2011-05-12 9:12:56.999 PM');
insert into tz_test(col1, col2) values(datetimeltz'2013-12-10 3:00:00.999 AM -03:30', datetimetz'2013-12-10 3:00:00.999 -3:30');
insert into tz_test(col1, col2) values(datetimeltz'2011-05-12 5:12:56.999 PM +5:00', null);
insert into tz_test(col1, col2) values(datetimeltz'2013-12-10 8:30:00.999 Europe/Bucharest', datetimetz'2013-12-10 8:30:00.999 Europe/Riga');
insert into tz_test(col1, col2) values(datetimeltz'2011-05-12 9:12:56.999 AM America/Argentina/Buenos_Aires', datetimetz'2011-05-12 10:12:56.999 America/Noronha');

--DST related
set timezone 'Europe/Bucharest';
insert into tz_test(col1, col2) values(datetimeltz'1992-07-10 2:00:00.999', datetimetz'1992-07-10 2:00:00.999');
insert into tz_test(col1, col2) values(datetimeltz'1992-07-10 3:00:00.999 Europe/Bucharest', datetimetz'1992-07-10 3:00:00.999 Europe/Bucharest');
set timezone '+2:00';
insert into tz_test(col1, col2) values(datetimeltz'1992-07-10 2:00:00.999', datetimetz'1992-07-10 2:00:00.999');

--leap second
set timezone 'UTC';
insert into tz_test(col1, col2) values(datetimeltz'1994-6-30 23:59:59.999', datetimetz'1994-6-30 23:59:59.999');
insert into tz_test(col1, col2) values(datetimeltz'1994-6-30 23:59:59.999'+1, datetimetz'1994-6-30 23:59:59.999'+1);
set timezone 'Europe/Bucharest';
insert into tz_test(col1, col2) values(datetimeltz'1994-7-1 1:59:59.999 AM', datetimetz'1994-7-1 1:59:59.999');
insert into tz_test(col1, col2) values(datetimeltz'1994-7-1 1:59:59.999 AM'+1, datetimetz'1994-7-1 1:59:59.999'+1);
insert into tz_test(col1, col2) values(datetimeltz'1994-7-1 2:59:59.999 AM', datetimetz'1994-7-1 2:59:59.999');
insert into tz_test(col1, col2) values(datetimeltz'1994-7-1 2:59:59.999 AM'+1, datetimetz'1994-7-1 2:59:59.999'+1);


--test: single column index
create index idx1 on tz_test(col1);
create index idx2 on tz_test(col2);

--test: multi column index
create index idx3 on tz_test(col1, col2);
create unique index idx4 on tz_test(id, col1);
create unique index idx5 on tz_test(id, col2);

update statistics on tz_test with fullscan;

set timezone 'Europe/Bucharest';

--test: idx1
--@queryplan
select /*+ recompile */ * from tz_test where col1=datetimeltz'2013-12-10 15:30:00.999 +9:00' order by 1;
set timezone '-04:30';
--@queryplan
select /*+ recompile */ * from tz_test where col1>datetimeltz'2013-12-10 3:00:00.999' order by 1;

set timezone 'Asia/Seoul';
--test: idx2
--@queryplan
select /*+ recompile */ * from tz_test where col2=datetimeltz'2013-12-10 15:30:00.999' order by col1, id;
set timezone '+4:00';
--@queryplan
select /*+ recompile */ * from tz_test where col2=datetimeltz'2011-05-12 16:12:56.999' order by 1;
--@queryplan
select /*+ recompile */ id, col2, col1 from tz_test where col2=datetimeltz'2011-05-12 9:12:56.999 AM America/Argentina/Buenos_Aires' order by 1, 2;

--test: idx3
set timezone 'Australia/Perth';
--@queryplan
select /*+ recompile */ * from tz_test where col1 < datetimeltz'2013-12-10 15:30:00.999 +9:00' and col2>datetimetz'2011-05-12 8:12:55.999 PM' order by 1;
--@queryplan
select /*+ recompile */ * from tz_test where col1 = col2 order by 1;
--@queryplan
select /*+ recompile */ t.col1 a, to_char(t.col2) b from (select /*+ recompile NO_MERGE */ col1, col2 from tz_test where col1=datetimeltz'1992-07-10 3:00:00.999 Europe/Bucharest' order by 1, 2) t order by b;

--test: idx4
--@queryplan
select /*+ recompile */ id, col1, col2 from tz_test where id > 5 and col1 < datetimeltz'2013-12-10 15:30:00.999 +9:00' order by 1;
--test: idx5
--@queryplan
set timezone 'Europe/Bucharest';
select /*+ recompile */ * from tz_test where id < 10 and col2>=datetimeltz'1992-07-10 3:00:00.999' order by 1;


drop index idx1 on tz_test;
drop index idx2 on tz_test;
drop index idx4 on tz_test;

--test: filtered index
set timezone 'Atlantic/Cape_Verde';
create index filter_idx2 on tz_test(col2) where col2 < datetimeltz'2011-11-12 5:12:56.999';
create index filter_idx4 on tz_test(id, col1) where col2 = datetimeltz'2011-11-12 5:12:56.999';

--test: function index
create index function_idx2 on tz_test(year(col2));

set timezone 'Europe/Bucharest';
--test: filter_idx2
--@queryplan
select /*+ recompile */ * from tz_test use index(filter_idx2) where col2 < datetimeltz'2011-05-12 5:12:56.999' order by 1, 2;
set timezone 'Atlantic/Cape_Verde';
--@queryplan
select /*+ recompile */ * from tz_test use index(filter_idx2) where col2 < datetimeltz'2011-5-12 5:12:56.999' order by 1;
--@queryplan
select /*+ recompile */ * from tz_test force index(filter_idx2) where col2 > datetimeltz'2011-5-12 5:12:56.999' order by 1;
--test: filter_idx3
set timezone 'Atlantic/Cape_Verde';
--test: filter_idx4 ?? 
--@queryplan
select /*+ recompile */ * from tz_test use index(filter_idx4) where col2 = datetimeltz'2011-11-12 5:12:56.999' order by 1;

--test: function_idx2
set timezone 'Europe/Bucharest';
--@queryplan
select /*+ recompile */ * from tz_test force index(function_idx2) where hour(col2)=8 order by 3, 2, 1;
--@queryplan
select /*+ recompile */ * from tz_test use index(function_idx2) where year(col2)=1994 order by 3, 2, 1;



drop table tz_test;


set timezone 'Asia/Seoul';

 
set system parameters 'tz_leap_second_support=no';
