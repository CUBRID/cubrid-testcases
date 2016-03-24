--implicit conversion from DATETIME(L)TZ columns to bit/blob/clob types, in update


drop table if exists tz_test, bbc_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999', datetimeltz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '2009-10-12 03:45:56.999 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to bit/blob/clob types
update bbc_types set a=datetime'1980-10-01 2:00:00.999';
update bbc_types set b=datetime'1980-10-01 2:00:00.999';
update bbc_types set c=datetime'1980-10-01 2:00:00.999';
update bbc_types set d=datetime'1980-10-01 2:00:00.999';
--test: [er] implicit conversion from ts column to bit/blob/clob types
update bbc_types set a=(select ts from tz_test);
update bbc_types set b=(select ts from tz_test);
update bbc_types set c=(select ts from tz_test);
update bbc_types set d=(select ts from tz_test);

--test: [er] implicit conversion from dtltz constant value to bit/blob/clob types
update bbc_types set a=datetime'1980-10-01 2:00:00.999 -5:00';
update bbc_types set b=datetime'1980-10-01 2:00:00.999 -5:00';
update bbc_types set c=datetime'1980-10-01 2:00:00.999 -5:00';
update bbc_types set d=datetime'1980-10-01 2:00:00.999 -5:00';
--test: [er] implicit conversion from dtltz column to bit/blob/clob types
update bbc_types set a=(select dtltz from tz_test);
update bbc_types set b=(select dtltz from tz_test);
update bbc_types set c=(select dtltz from tz_test);
update bbc_types set d=(select dtltz from tz_test);

--test: [er] implicit conversion from dttz constant value to bit/blob/clob types
update bbc_types set a=datetime'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update bbc_types set b=datetime'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update bbc_types set c=datetime'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
update bbc_types set d=datetime'1980-10-01 2:00:00.999 America/Argentina/Jujuy';
--test: [er] implicit conversion from dttz column to bit/blob/clob types
update bbc_types set a=(select dttz from tz_test);
update bbc_types set b=(select dttz from tz_test);
update bbc_types set c=(select dttz from tz_test);
update bbc_types set d=(select dttz from tz_test);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
