--implicit conversion from TIME(L)TZ columns to bit/blob/clob types, in insert 


drop table if exists tz_test;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, tltz, ttz) values (datetimetz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '03:45:56 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to bit/blob/clob types
insert into bbc_types(a) values (datetimetz'2015-9-17 2:00:00');
insert into bbc_types(b) values (datetimetz'2015-9-17 2:00:00');
insert into bbc_types(c) values (datetimetz'2015-9-17 2:00:00');
insert into bbc_types(d) values (datetimetz'2015-9-17 2:00:00');
--test: [er] implicit conversion from ts column to bit/blob/clob types
insert into bbc_types(a) values (select ts from tz_test);
insert into bbc_types(b) values (select ts from tz_test);
insert into bbc_types(c) values (select ts from tz_test);
insert into bbc_types(d) values (select ts from tz_test);

--test: [er] implicit conversion from tltz constant value to bit/blob/clob types
insert into bbc_types(a) values (datetimetz'2015-9-17 2:00:00 -5:00');
insert into bbc_types(b) values (datetimetz'2015-9-17 2:00:00 -5:00');
insert into bbc_types(c) values (datetimetz'2015-9-17 2:00:00 -5:00');
insert into bbc_types(d) values (datetimetz'2015-9-17 2:00:00 -5:00');
--test: [er] implicit conversion from tltz column to bit/blob/clob types
insert into bbc_types(a) values (select tltz from tz_test);
insert into bbc_types(b) values (select tltz from tz_test);
insert into bbc_types(c) values (select tltz from tz_test);
insert into bbc_types(d) values (select tltz from tz_test);

--test: [er] implicit conversion from ttz constant value to bit/blob/clob types
insert into bbc_types(a) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into bbc_types(b) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into bbc_types(c) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
insert into bbc_types(d) values (datetimetz'2015-9-17 2:00:00 America/Argentina/Jujuy');
--test: [er] implicit conversion from ttz column to bit/blob/clob types
insert into bbc_types(a) values (select ttz from tz_test);
insert into bbc_types(b) values (select ttz from tz_test);
insert into bbc_types(c) values (select ttz from tz_test);
insert into bbc_types(d) values (select ttz from tz_test);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
