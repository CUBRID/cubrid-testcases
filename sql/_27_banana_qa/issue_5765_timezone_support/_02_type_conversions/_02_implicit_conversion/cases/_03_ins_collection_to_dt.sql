--implicit conversion from collection types to DATETIME(L)TZ types, in insert 


drop table if exists tz_test, collection_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetimetz'1980-10-01 2:00:00.999', datetimeltz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table collection_types(a set datetime with time zone, b multiset datetime, c sequence datetime with local time zone);
insert into collection_types values({datetimetz'2000-01-01 12:13:14.999 +4:00'}, {datetimetz'2000-01-01 12:13:14.999 +4:00'}, {datetimeltz'2000-01-01 12:13:14.999 +4:00'});

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from collection types to ts types
insert into tz_test(ts) values ({datetimetz'2000-01-01 12:13:14.999'});
insert into tz_test(ts) values ({datetimetz'2000-01-01 12:13:14.999 +4:00'});
insert into tz_test(ts) values ({datetimetz'2000-01-01 12:13:14.999 America/New_York'});
--test: [er] implicit conversion from collection types to ts types
insert into tz_test(ts) values (select a from collection_types);
insert into tz_test(ts) values (select b from collection_types);
insert into tz_test(ts) values (select c from collection_types);

--test: [er] implicit conversion from collection types to ts types
insert into tz_test(dtltz) values ({datetimetz'2000-01-01 12:13:14.999'});
insert into tz_test(dtltz) values ({datetimetz'2000-01-01 12:13:14.999 +4:00'});
insert into tz_test(dtltz) values ({datetimetz'2000-01-01 12:13:14.999 America/New_York'});
--test: [er] implicit conversion from collection types to dtltz types
insert into tz_test(dtltz) values (select a from collection_types);
insert into tz_test(dtltz) values (select b from collection_types);
insert into tz_test(dtltz) values (select c from collection_types);

--test: [er] implicit conversion from collection types to dttz types
insert into tz_test(dttz) values ({datetimetz'2000-01-01 12:13:14.999'});
insert into tz_test(dttz) values ({datetimetz'2000-01-01 12:13:14.999 +4:00'});
insert into tz_test(dttz) values ({datetimetz'2000-01-01 12:13:14.999 America/New_York'});
--test: [er] implicit conversion from collection types to dttz types
insert into tz_test(dttz) values (select a from collection_types);
insert into tz_test(dttz) values (select b from collection_types);
insert into tz_test(dttz) values (select c from collection_types);


drop table tz_test, collection_types;

set timezone 'Asia/Seoul';
