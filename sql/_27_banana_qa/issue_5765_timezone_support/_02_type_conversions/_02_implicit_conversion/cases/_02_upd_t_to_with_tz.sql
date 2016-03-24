--implicit conversion from TIME(L)TZ columns to date/time with time zone types, in updatenswer: /home/zll/dailyqa/trunk/scenario/sql/_27_banana_qa/issue_5765_timezone_support/_02_type_conversions/_02_implicit_conversion/answers/_02_upd_t_to_with_tz.answer


autocommit off;

drop table if exists tz_test, with_tz_types;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, tltz, ttz) values (time'2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table with_tz_types (
	id int auto_increment,
        c timestamp with local time zone,
        d timestamp with time zone,
        e datetime with local time zone,
        f datetime with time zone
);
set timezone '+3:00';
insert into with_tz_types(c, d, e, f) values(timestampltz'2019-12-10 3:40:56', timestamptz'2019-12-10 3:40:56 Indian/Comoro', datetimeltz' 2019-12-10 3:40:56.299', datetimetz' 2019-12-10 3:40:56.299 Indian/Comoro');
commit;

set timezone '+9:00';
--test: implicit conversion from ts constant value to date/time with time zone types
update with_tz_types set c=time'2:00:00';
update with_tz_types set d=time'2:00:00';
update with_tz_types set e=time'2:00:00';
update with_tz_types set f=time'2:00:00';
select * from with_tz_types order by id; 
rollback;
--test: implicit conversion from ts column to date/time with time zone types
update with_tz_types set c=(select ts from tz_test);
update with_tz_types set d=(select ts from tz_test);
update with_tz_types set e=(select ts from tz_test);
update with_tz_types set f=(select ts from tz_test);
select * from with_tz_types order by id;
rollback;

--test: implicit conversion from tltz constant value to date/time with time zone types
update with_tz_types set c=datetimeltz'2015-9-17 2:00:00 -5:00';
update with_tz_types set d=datetimeltz'2015-9-17 2:00:00 -5:00';
update with_tz_types set e=datetimeltz'2015-9-17 2:00:00 -5:00';
update with_tz_types set f=datetimeltz'2015-9-17 2:00:00 -5:00';
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from tltz column to date/time with time zone types
update with_tz_types set c=(select tltz from tz_test);
update with_tz_types set d=(select tltz from tz_test);
update with_tz_types set e=(select tltz from tz_test);
update with_tz_types set f=(select tltz from tz_test);
select * from with_tz_types order by id;
rollback;

--test: implicit conversion from ttz constant value to date/time with time zone types
update with_tz_types set c=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update with_tz_types set d=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update with_tz_types set e=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update with_tz_types set f=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
select * from with_tz_types order by id;
rollback;
--test: implicit conversion from ttz column to date/time with time zone types
update with_tz_types set c=(select ttz from tz_test);
update with_tz_types set d=(select ttz from tz_test);
update with_tz_types set e=(select ttz from tz_test);
update with_tz_types set f=(select ttz from tz_test);
select * from with_tz_types order by id;


drop table tz_test, with_tz_types;
commit;

set timezone 'Asia/Seoul';
autocommit on;
