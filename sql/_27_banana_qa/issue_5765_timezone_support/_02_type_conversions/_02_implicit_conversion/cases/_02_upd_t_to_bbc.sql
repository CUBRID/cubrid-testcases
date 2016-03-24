--implicit conversion from TIME(L)TZ columns to bit/blob/clob types, in update


drop table if exists tz_test, bbc_types;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, tltz, ttz) values (time'2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '03:45:56 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to bit/blob/clob types
update bbc_types set a=time'2:00:00';
update bbc_types set b=time'2:00:00';
update bbc_types set c=time'2:00:00';
update bbc_types set d=time'2:00:00';
--test: [er] implicit conversion from ts column to bit/blob/clob types
update bbc_types set a=(select ts from tz_test);
update bbc_types set b=(select ts from tz_test);
update bbc_types set c=(select ts from tz_test);
update bbc_types set d=(select ts from tz_test);

--test: [er] implicit conversion from tltz constant value to bit/blob/clob types
update bbc_types set a=time'2:00:00 -5:00';
update bbc_types set b=time'2:00:00 -5:00';
update bbc_types set c=time'2:00:00 -5:00';
update bbc_types set d=time'2:00:00 -5:00';
--test: [er] implicit conversion from tltz column to bit/blob/clob types
update bbc_types set a=(select tltz from tz_test);
update bbc_types set b=(select tltz from tz_test);
update bbc_types set c=(select tltz from tz_test);
update bbc_types set d=(select tltz from tz_test);

--test: [er] implicit conversion from ttz constant value to bit/blob/clob types
update bbc_types set a=time'2:00:00 America/Argentina/Jujuy';
update bbc_types set b=time'2:00:00 America/Argentina/Jujuy';
update bbc_types set c=time'2:00:00 America/Argentina/Jujuy';
update bbc_types set d=time'2:00:00 America/Argentina/Jujuy';
--test: [er] implicit conversion from ttz column to bit/blob/clob types
update bbc_types set a=(select ttz from tz_test);
update bbc_types set b=(select ttz from tz_test);
update bbc_types set c=(select ttz from tz_test);
update bbc_types set d=(select ttz from tz_test);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
