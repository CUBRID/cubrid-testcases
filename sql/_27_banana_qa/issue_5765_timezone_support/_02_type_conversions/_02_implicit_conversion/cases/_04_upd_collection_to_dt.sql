--implicit conversion from collection types to DATETIME(L)TZ types, in insert 


drop table if exists tz_test, collection_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values(datetimetz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table collection_types(a set datetime with time zone, b multiset datetime, c sequence datetime with local time zone);
insert into collection_types values({datetimetz'2000-01-01 12:13:14.999 +4:00'}, {datetimetz'2000-01-01 12:13:14.999 +4:00'}, {datetimetz'2000-01-01 12:13:14.999 +4:00'});

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from collection types to ts types
update tz_test set ts={datetimetz'2000-01-01 12:13:14.999'};
update tz_test set ts={datetimetz'2000-01-01 12:13:14.999 +4:00'};
update tz_test set ts={datetimetz'2000-01-01 12:13:14.999 America/New_York'};
--test: [er] implicit conversion from collection types to ts types
update tz_test set ts=(select a from collection_types);
update tz_test set ts=(select b from collection_types);
update tz_test set ts=(select c from collection_types);

--test: [er] implicit conversion from collection types to ts types
update tz_test set dtltz={datetimetz'2000-01-01 12:13:14.999'};
update tz_test set dtltz={datetimetz'2000-01-01 12:13:14.999 +4:00'};
update tz_test set dtltz={datetimetz'2000-01-01 12:13:14.999 America/New_York'};
--test: [er] implicit conversion from collection types to dtltz types
update tz_test set dtltz=(select a from collection_types);
update tz_test set dtltz=(select b from collection_types);
update tz_test set dtltz=(select c from collection_types);

--test: [er] implicit conversion from collection types to dttz types
update tz_test set dttz={datetimetz'2000-01-01 12:13:14.999'};
update tz_test set dttz={datetimetz'2000-01-01 12:13:14.999 +4:00'};
pdate tz_test set dttz={datetimetz'2000-01-01 12:13:14.999 America/New_York'};
--test: [er] implicit conversion from collection types to dttz types
update tz_test set dttz=(select a from collection_types);
update tz_test set dttz=(select b from collection_types);
update tz_test set dttz=(select c from collection_types);


drop table tz_test, collection_types;

set timezone 'Asia/Seoul';
