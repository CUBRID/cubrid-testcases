--implicit conversion from numeric types to TIMESTAMP(L)TZ types, in update


autocommit off;

drop table if exists tz_test, numeric_types;

create table tz_test (id int auto_increment, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone);
set timezone '+10:00';
insert into tz_test(ts, tsltz, tstz) values (timestamp'1980-10-01 2:00:00', timestampltz'1980-10-01 2:00:00', timestamptz'1980-10-01 2:00:00 Asia/Yakutsk');

create table numeric_types (a smallint, b int, c bigint, d numeric(4, 2), e float, f double);
insert into numeric_types values(5, 55, 555, 56.78, 1.23, 10000.6789);

commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from numeric constant values to ts types
update tz_test set ts=1, tsltz=1, tstz=1;
select * from tz_test order by 1;
update tz_test set ts=3600, tsltz=3600, tstz=cast(3600 as int);
select * from tz_test order by 1;
update tz_test set ts=cast(86400 as bigint), tsltz=cast(86400 as bigint), tstz=cast(86400 as bigint);
select * from tz_test order by 1;
update tz_test set ts=10.9, tsltz=cast(10.9 as numeric(4, 2)), tstz=10.9;
select * from tz_test order by 1;
update tz_test set ts=cast(86400.99 as float), tsltz=cast(86400.99 as float), tstz=cast(86400.99 as float);
select * from tz_test order by 1;
update tz_test set ts=2147483647, tsltz=2147483647, tstz=2147483647;
select * from tz_test order by 1;

--test: [er] out-of-range
update tz_test set ts=2147483648;
update tz_test set tsltz=2147483648;
update tz_test set ts=2147483648;

rollback;

--test: implicit conversion from numeric types to ts types
update tz_test set ts=(select a from numeric_types), tsltz=(select a from numeric_types), tstz=(select a from numeric_types);
select * from tz_test order by 1;
update tz_test set ts=(select b from numeric_types), tsltz=(select b from numeric_types), tstz=(select b from numeric_types);
select * from tz_test order by 1;
update tz_test set ts=(select c from numeric_types), tsltz=(select c from numeric_types), tstz=(select c from numeric_types);
select * from tz_test order by 1;
rollback;
update tz_test set ts=(select d from numeric_types), tsltz=(select d from numeric_types), tstz=(select d from numeric_types);
select * from tz_test order by 1;
update tz_test set ts=(select e from numeric_types), tsltz=(select e from numeric_types), tstz=(select e from numeric_types);
select * from tz_test order by 1;
update tz_test set ts=(select f from numeric_types), tsltz=(select f from numeric_types), tstz=(select f from numeric_types);
select * from tz_test order by 1;


drop table tz_test, numeric_types;
commit;

set timezone 'Asia/Seoul';

autocommit on;
