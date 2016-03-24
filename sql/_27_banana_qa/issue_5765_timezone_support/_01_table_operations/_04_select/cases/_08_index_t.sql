--test index on TIME(L)TZ columns
set system parameters 'tz_leap_second_support=yes';

drop table if exists tz_test;

set timezone '+9:00';
create table tz_test(id int auto_increment, col1 datetime with local time zone not null default datetimetz'2015-9-17 2:00:20 Asia/Shanghai', col2 datetime with time zone);

insert into tz_test(col1, col2) values(datetimeltz'2015-9-17 15:30:00', datetimetz'2015-9-17 15:30:00');
insert into tz_test(col1, col2) values(datetimeltz'2015-9-17 9:12:56 PM', datetimeltz'2015-9-17 9:12:56 PM');
insert into tz_test(col1, col2) values(datetimeltz'2015-9-17 3:00:00 AM -03:30', datetimetz'2015-9-17 3:00:00 -3:30');
insert into tz_test(col1, col2) values(datetimeltz'2015-9-17 5:12:56 PM +5:00', null);
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 8:30:00 America/Belem', datetimetz'2015-9-17 8:30:00 America/La_Paz');
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 9:12:56 AM America/La_Paz', datetimetz'2015-9-17 10:12:56 America/Noronha');

--DST related
set timezone 'America/Belem';
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00');
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 3:00:00 America/Belem', datetimetz'2015-9-17 3:00:00 America/Belem');
set timezone '+2:00';
insert into tz_test(col1, col2) values(datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00');

set timezone 'UTC';
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 23:59:59', datetimetz'2015-9-17 23:59:59');
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 23:59:59'+1, datetimetz'2015-9-17 23:59:59'+1);
set timezone 'America/Belem';
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 1:59:59 AM', datetimetz'2015-9-17 1:59:59');
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 1:59:59 AM'+1, datetimetz'2015-9-17 1:59:59'+1);
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 2:59:59 AM', datetimetz'2015-9-17 2:59:59');
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 2:59:59 AM'+1, datetimetz'2015-9-17 2:59:59'+1);


--test: single column index
create index idx1 on tz_test(col1);
create index idx2 on tz_test(col2);

--test: multi column index
create index idx3 on tz_test(col1, col2);
create unique index idx4 on tz_test(id, col1);
create unique index idx5 on tz_test(id, col2);

update statistics on tz_test with fullscan;

set timezone 'America/Belem';

--test: idx1
--@queryplan
select /*+ recompile */ * from tz_test where col1=datetimeltz'2015-9-17 15:30:00 +9:00' order by 1;
set timezone '-04:30';
--@queryplan
select /*+ recompile */ * from tz_test where col1>datetimeltz'2015-9-17 3:00:00' order by 1;

set timezone 'Asia/Seoul';
--test: idx2
--@queryplan
select /*+ recompile */ * from tz_test where col2=datetimetz'2015-9-17 15:30:00' order by col1, id;
set timezone '+4:00';
--@queryplan
select /*+ recompile */ * from tz_test where col2=datetimeltz'2015-9-17 16:12:56' order by 1;
--@queryplan
select /*+ recompile */ id, col2, col1 from tz_test where col2=datetimetz'2015-9-17 9:12:56 AM America/La_Paz' order by 1, 2;

--test: idx3
set timezone 'Indian/Christmas';
--@queryplan
select /*+ recompile */ * from tz_test where col1 < datetimeltz'2015-9-17 15:30:00 +9:00' and col2>datetimetz'2015-9-17 8:12:55 PM' order by 1;
--@queryplan
select /*+ recompile */ * from tz_test where col1 = col2 order by 1;
--@queryplan
select /*+ recompile */ col1, col2 from tz_test where col1=datetimetz'2015-9-17 3:00:00 America/Belem' order by 1, 2;

--test: idx4
--@queryplan
select /*+ recompile */ id, col1, col2 from tz_test where id > 5 and col1 < datetimeltz'2015-9-17 15:30:00 +9:00' order by 1;
--test: idx5
--@queryplan
set timezone 'America/Belem';
select /*+ recompile */ * from tz_test where id < 10 and col2>=datetimetz'2015-9-17 3:00:00' order by 1;


drop index idx1 on tz_test;
drop index idx2 on tz_test;
drop index idx4 on tz_test;

--test: filtered index
set timezone 'Atlantic/Cape_Verde';
create index filter_idx2 on tz_test(col2) where col2 < datetimetz'2015-9-17 5:12:56';
create index filter_idx4 on tz_test(id, col1) where col2 = datetimetz'2015-9-17 5:12:56';

--test: function index
create index function_idx2 on tz_test(second(col2));

set timezone 'America/Belem';
--test: filter_idx2
--@queryplan
select /*+ recompile */ * from tz_test use index(filter_idx2) where col2 < datetimetz'2015-9-17 5:12:56' order by 1, 2;
set timezone 'Atlantic/Cape_Verde';
--@queryplan
select /*+ recompile */ * from tz_test use index(filter_idx2) where col2 < datetimetz'2015-9-17 5:12:56' order by 1;
--@queryplan
select /*+ recompile */ * from tz_test force index(filter_idx2) where col2 > datetimetz'2015-9-17 5:12:56' order by 1;
set timezone 'Atlantic/Cape_Verde';
--test: filter_idx4 ?? 
--@queryplan
select /*+ recompile */ * from tz_test use index(filter_idx4) where col2 = datetimetz'2015-9-17 15:12:56' order by 1;

--test: function_idx2
set timezone 'America/Belem';
--@queryplan
select /*+ recompile */ * from tz_test force index(function_idx2) where hour(col2)=8 order by 3, 2, 1;
--@queryplan
select /*+ recompile */ * from tz_test use index(function_idx2) where second(col2)=59 order by 3, 2, 1;



drop table tz_test;


set timezone 'Asia/Seoul';
set system parameters 'tz_leap_second_support=no';
