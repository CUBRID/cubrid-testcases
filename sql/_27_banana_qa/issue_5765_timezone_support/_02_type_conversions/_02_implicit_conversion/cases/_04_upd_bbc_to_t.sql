--implicit conversion from bit/blob/clob types to TIME(L)TZ types, in update


drop table if exists tz_test, bbc_types;

create table tz_test (id int auto_increment, ts time, tltz datetime with local time zone, ttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, tltz, ttz) values (time'2:00:00', datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '03:45:56 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from bit/blob/clob types to ts types
update tz_test set ts=B'10101010';
update tz_test set ts=X'aaa';
update tz_test set ts=bit_to_blob(B'1010');
update tz_test set ts=char_to_clob('13:13:13');
--test: [er] implicit conversion from bit/blob/clob types to ts types
update tz_test set ts=(select a from bbc_types);
update tz_test set ts=(select b from bbc_types);
update tz_test set ts=(select c from bbc_types);
update tz_test set ts=(select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to tltz types
update tz_test set tltz=B'10101010';
update tz_test set tltz=X'aaa';
update tz_test set tltz=bit_to_blob(B'1010');
update tz_test set tltz=char_to_clob('13:13:13');
--test: [er] implicit conversion from bit/blob/clob types to tltz types
update tz_test set tltz=(select a from bbc_types);
update tz_test set tltz=(select b from bbc_types);
update tz_test set tltz=(select c from bbc_types);
update tz_test set tltz=(select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to ttz types
update tz_test set ttz=B'10101010';
update tz_test set ttz=X'aaa';
update tz_test set ttz=bit_to_blob(B'1010');
update tz_test set ttz=char_to_clob('13:13:13');
--test: [er] implicit conversion from bit/blob/clob types to ttz types
update tz_test set ttz=(select a from bbc_types);
update tz_test set ttz=(select b from bbc_types);
update tz_test set ttz=(select c from bbc_types);
update tz_test set ttz=(select d from bbc_types);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
