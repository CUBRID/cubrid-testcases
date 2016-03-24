--implicit conversion from bit/blob/clob types to TIMESTAMP(L)TZ types, in update


drop table if exists tz_test, bbc_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table bbc_types(a bit(8), b bit varying, c blob, d clob);
insert into bbc_types values(B'10101111', X'abcdef', B'11001010', '2009-10-12 03:45:56 Africa/Ouagadougou');

set timezone 'Asia/Seoul';
--test: [er] implicit conversion from bit/blob/clob types to ts types
update tz_test set ts=B'10101010';
update tz_test set ts=X'aaa';
update tz_test set ts=bit_to_blob(B'1010');
update tz_test set ts=char_to_clob('2000-12-12 13:13:13');
--test: [er] implicit conversion from bit/blob/clob types to ts types
update tz_test set ts=(select a from bbc_types);
update tz_test set ts=(select b from bbc_types);
update tz_test set ts=(select c from bbc_types);
update tz_test set ts=(select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to tsltz types
update tz_test set tsltz=B'10101010';
update tz_test set tsltz=X'aaa';
update tz_test set tsltz=bit_to_blob(B'1010');
update tz_test set tsltz=char_to_clob('2000-12-12 13:13:13');
--test: [er] implicit conversion from bit/blob/clob types to tsltz types
update tz_test set tsltz=(select a from bbc_types);
update tz_test set tsltz=(select b from bbc_types);
update tz_test set tsltz=(select c from bbc_types);
update tz_test set tsltz=(select d from bbc_types);

--test: [er] implicit conversion from bit/blob/clob types to tstz types
update tz_test set tstz=B'10101010';
update tz_test set tstz=X'aaa';
update tz_test set tstz=bit_to_blob(B'1010');
update tz_test set tstz=char_to_clob('2000-12-12 13:13:13');
--test: [er] implicit conversion from bit/blob/clob types to tstz types
update tz_test set tstz=(select a from bbc_types);
update tz_test set tstz=(select b from bbc_types);
update tz_test set tstz=(select c from bbc_types);
update tz_test set tstz=(select d from bbc_types);


drop table tz_test, bbc_types;

set timezone 'Asia/Seoul';
