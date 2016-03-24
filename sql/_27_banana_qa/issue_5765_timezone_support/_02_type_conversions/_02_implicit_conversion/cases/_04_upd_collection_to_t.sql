--implicit conversion from collection types to TIME(L)TZ types, in insert 


drop table if exists tz_test, collection_types;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, tltz, ttz) values(datetimetz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table collection_types(a set datetime with time zone, b multiset time, c sequence datetime with local time zone);
insert into collection_types values({datetimetz'2015-9-17 12:13:14 +4:00'}, {datetimetz'2015-9-17 12:13:14 +4:00'}, {datetimetz'2015-9-17 12:13:14 +4:00'});

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from collection types to ts types
update tz_test set ts={datetimetz'2015-9-17 12:13:14'};
update tz_test set ts={datetimetz'2015-9-17 12:13:14 +4:00'};
update tz_test set ts={datetimetz'2015-9-17 12:13:14 America/New_York'};
--test: [er] implicit conversion from collection types to ts types
update tz_test set ts=(select a from collection_types);
update tz_test set ts=(select b from collection_types);
update tz_test set ts=(select c from collection_types);

--test: [er] implicit conversion from collection types to ts types
update tz_test set tltz={datetimetz'2015-9-17 12:13:14'};
update tz_test set tltz={datetimetz'2015-9-17 12:13:14 +4:00'};
update tz_test set tltz={datetimetz'2015-9-17 12:13:14 America/New_York'};
--test: [er] implicit conversion from collection types to tltz types
update tz_test set tltz=(select a from collection_types);
update tz_test set tltz=(select b from collection_types);
update tz_test set tltz=(select c from collection_types);

--test: [er] implicit conversion from collection types to ttz types
update tz_test set ttz={datetimetz'2015-9-17 12:13:14'};
update tz_test set ttz={datetimetz'2015-9-17 12:13:14 +4:00'};
pdate tz_test set ttz={datetimetz'2015-9-17 12:13:14 America/New_York'};
--test: [er] implicit conversion from collection types to ttz types
update tz_test set ttz=(select a from collection_types);
update tz_test set ttz=(select b from collection_types);
update tz_test set ttz=(select c from collection_types);


drop table tz_test, collection_types;

set timezone 'Asia/Seoul';
