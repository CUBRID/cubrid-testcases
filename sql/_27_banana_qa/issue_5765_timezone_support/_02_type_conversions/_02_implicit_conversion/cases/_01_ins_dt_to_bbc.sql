--implicit conversion from DATETIME(L)TZ columns to bit/blob/clob types, in insert 


drop table if exists tz_test;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetimetz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '2009-10-12 03:45:56.999 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to bit/blob/clob types
insert into bbc_types(a) values (datetimetz'1980-10-01 2:00:00.999');
insert into bbc_types(b) values (datetimetz'1980-10-01 2:00:00.999');
insert into bbc_types(c) values (datetimetz'1980-10-01 2:00:00.999');
insert into bbc_types(d) values (datetimetz'1980-10-01 2:00:00.999');
--test: [er] implicit conversion from ts column to bit/blob/clob types
insert into bbc_types(a) values (select ts from tz_test);
insert into bbc_types(b) values (select ts from tz_test);
insert into bbc_types(c) values (select ts from tz_test);
insert into bbc_types(d) values (select ts from tz_test);

--test: [er] implicit conversion from dtltz constant value to bit/blob/clob types
insert into bbc_types(a) values (datetimetz'1980-10-01 2:00:00.999 -5:00');
insert into bbc_types(b) values (datetimetz'1980-10-01 2:00:00.999 -5:00');
insert into bbc_types(c) values (datetimetz'1980-10-01 2:00:00.999 -5:00');
insert into bbc_types(d) values (datetimetz'1980-10-01 2:00:00.999 -5:00');
--test: [er] implicit conversion from dtltz column to bit/blob/clob types
insert into bbc_types(a) values (select dtltz from tz_test);
insert into bbc_types(b) values (select dtltz from tz_test);
insert into bbc_types(c) values (select dtltz from tz_test);
insert into bbc_types(d) values (select dtltz from tz_test);

--test: [er] implicit conversion from dttz constant value to bit/blob/clob types
insert into bbc_types(a) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into bbc_types(b) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into bbc_types(c) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
insert into bbc_types(d) values (datetimetz'1980-10-01 2:00:00.999 America/Argentina/Jujuy');
--test: [er] implicit conversion from dttz column to bit/blob/clob types
insert into bbc_types(a) values (select dttz from tz_test);
insert into bbc_types(b) values (select dttz from tz_test);
insert into bbc_types(c) values (select dttz from tz_test);
insert into bbc_types(d) values (select dttz from tz_test);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
