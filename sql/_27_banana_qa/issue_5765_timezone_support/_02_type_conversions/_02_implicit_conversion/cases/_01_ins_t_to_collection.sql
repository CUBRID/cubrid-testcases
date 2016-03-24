--implicit conversion from TIME(L)TZ columns to collection types, in insert 


drop table if exists tz_test;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, tltz, ttz) values (time'2:00:00', datetimetz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table collection_types(a set datetime with time zone, b multiset time, c sequence datetime with local time zone);

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to collection types
insert into collection_types(a) values (time'2:00:00');
insert into collection_types(b) values (time'2:00:00');
insert into collection_types(c) values (time'2:00:00');
--test: [er] implicit conversion from ts column to collection types
insert into collection_types(a) values (select ts from tz_test);
insert into collection_types(b) values (select ts from tz_test);
insert into collection_types(c) values (select ts from tz_test);

--test: [er] implicit conversion from tltz constant value to collection types
insert into collection_types(a) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into collection_types(b) values (datetimeltz'2015-9-17 2:00:00 -5:00');
insert into collection_types(c) values (datetimeltz'2015-9-17 2:00:00 -5:00');
--test: [er] implicit conversion from tltz column to collection types
insert into collection_types(a) values (select tltz from tz_test);
insert into collection_types(b) values (select tltz from tz_test);
insert into collection_types(c) values (select tltz from tz_test);

--test: [er] implicit conversion from ttz constant value to collection types
insert into collection_types(a) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into collection_types(b) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into collection_types(c) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
--test: [er] implicit conversion from ttz column to collection types
insert into collection_types(a) values (select ttz from tz_test);
insert into collection_types(b) values (select ttz from tz_test);
insert into collection_types(c) values (select ttz from tz_test);


drop table tz_test, collection_types;

set timezone 'Asia/Seoul';
