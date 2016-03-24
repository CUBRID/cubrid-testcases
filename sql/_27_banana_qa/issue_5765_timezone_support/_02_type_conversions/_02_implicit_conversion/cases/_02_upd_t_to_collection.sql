--implicit conversion from TIME(L)TZ columns to collection types, in update


drop table if exists tz_test, collection_types;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, tltz, ttz) values (time'2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table collection_types(a set datetime with time zone, b multiset time, c sequence datetime with local time zone);
insert into collection_types values({datetimetz'2015-9-17 12:13:14 +4:00'}, {datetimetz'2015-9-17 12:13:14 +4:00'}, {datetimetz'2015-9-17 12:13:14 +4:00'});

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to collection types
update collection_types set a=time'2:00:00';
update collection_types set b=time'2:00:00';
update collection_types set c=time'2:00:00';
--test: [er] implicit conversion from ts column to collection types
update collection_types set a=(select ts from tz_test);
update collection_types set b=(select ts from tz_test);
update collection_types set c=(select ts from tz_test);

--test: [er] implicit conversion from tltz constant value to collection types
update collection_types set a=datetimeltz'2015-9-17 2:00:00 -5:00';
update collection_types set b=datetimeltz'2015-9-17 2:00:00 -5:00';
update collection_types set c=datetimeltz'2015-9-17 2:00:00 -5:00';
--test: [er] implicit conversion from tltz column to collection types
update collection_types set a=(select tltz from tz_test);
update collection_types set b=(select tltz from tz_test);
update collection_types set c=(select tltz from tz_test);

--test: [er] implicit conversion from ttz constant value to collection types
update collection_types set a=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update collection_types set b=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
update collection_types set c=datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy';
--test: [er] implicit conversion from ttz column to collection types
update collection_types set a=(select ttz from tz_test);
update collection_types set b=(select ttz from tz_test);
update collection_types set c=(select ttz from tz_test);


drop table tz_test, collection_types;

set timezone 'Asia/Seoul';
