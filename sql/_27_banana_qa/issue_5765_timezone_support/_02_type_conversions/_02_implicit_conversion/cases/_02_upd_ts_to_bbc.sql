--implicit conversion from TIMESTAMP(L)TZ columns to bit/blob/clob types, in update


drop table if exists tz_test, bbc_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '2009-10-12 03:45:56 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from ts constant value to bit/blob/clob types
update bbc_types set a=timestamp'1980-10-01 2:00:00';
update bbc_types set b=timestamp'1980-10-01 2:00:00';
update bbc_types set c=timestamp'1980-10-01 2:00:00';
update bbc_types set d=timestamp'1980-10-01 2:00:00';
--test: [er] implicit conversion from ts column to bit/blob/clob types
update bbc_types set a=(select ts from tz_test);
update bbc_types set b=(select ts from tz_test);
update bbc_types set c=(select ts from tz_test);
update bbc_types set d=(select ts from tz_test);

--test: [er] implicit conversion from tsltz constant value to bit/blob/clob types
update bbc_types set a=timestamp'1980-10-01 2:00:00 -5:00';
update bbc_types set b=timestamp'1980-10-01 2:00:00 -5:00';
update bbc_types set c=timestamp'1980-10-01 2:00:00 -5:00';
update bbc_types set d=timestamp'1980-10-01 2:00:00 -5:00';
--test: [er] implicit conversion from tsltz column to bit/blob/clob types
update bbc_types set a=(select tsltz from tz_test);
update bbc_types set b=(select tsltz from tz_test);
update bbc_types set c=(select tsltz from tz_test);
update bbc_types set d=(select tsltz from tz_test);

--test: [er] implicit conversion from tstz constant value to bit/blob/clob types
update bbc_types set a=timestamp'1980-10-01 2:00:00 America/Argentina/Jujuy';
update bbc_types set b=timestamp'1980-10-01 2:00:00 America/Argentina/Jujuy';
update bbc_types set c=timestamp'1980-10-01 2:00:00 America/Argentina/Jujuy';
update bbc_types set d=timestamp'1980-10-01 2:00:00 America/Argentina/Jujuy';
--test: [er] implicit conversion from tstz column to bit/blob/clob types
update bbc_types set a=(select tstz from tz_test);
update bbc_types set b=(select tstz from tz_test);
update bbc_types set c=(select tstz from tz_test);
update bbc_types set d=(select tstz from tz_test);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
