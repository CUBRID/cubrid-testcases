--implicit conversion from bit/blob/clob types to DATETIME(L)TZ types, in update


drop table if exists tz_test, bbc_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999', datetimeltz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '2009-10-12 03:45:56.999 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from bit/blob/clob types to ts types
update tz_test set ts=B'10101010';
update tz_test set ts=X'aaa';
update tz_test set ts=bit_to_blob(B'1010');
update tz_test set ts=char_to_clob('2000-12-12 13:13:13.999');
--test: [er] implicit conversion from bit/blob/clob types to ts types
update tz_test set ts=(select a from bbc_types);
update tz_test set ts=(select b from bbc_types);
update tz_test set ts=(select c from bbc_types);
update tz_test set ts=(select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to dtltz types
update tz_test set dtltz=B'10101010';
update tz_test set dtltz=X'aaa';
update tz_test set dtltz=bit_to_blob(B'1010');
update tz_test set dtltz=char_to_clob('2000-12-12 13:13:13.999');
--test: [er] implicit conversion from bit/blob/clob types to dtltz types
update tz_test set dtltz=(select a from bbc_types);
update tz_test set dtltz=(select b from bbc_types);
update tz_test set dtltz=(select c from bbc_types);
update tz_test set dtltz=(select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to dttz types
update tz_test set dttz=B'10101010';
update tz_test set dttz=X'aaa';
update tz_test set dttz=bit_to_blob(B'1010');
update tz_test set dttz=char_to_clob('2000-12-12 13:13:13.999');
--test: [er] implicit conversion from bit/blob/clob types to dttz types
update tz_test set dttz=(select a from bbc_types);
update tz_test set dttz=(select b from bbc_types);
update tz_test set dttz=(select c from bbc_types);
update tz_test set dttz=(select d from bbc_types);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
