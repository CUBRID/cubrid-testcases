--implicit conversion from numeric types to DATETIME(L)TZ types, in update


autocommit off;

drop table if exists tz_test, numeric_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';
insert into tz_test(ts, dtltz, dttz) values (datetime'1980-10-01 2:00:00.999', datetimeltz'1980-10-01 2:00:00.999', datetimetz'1980-10-01 2:00:00.999 Asia/Yakutsk');

create table numeric_types (a smallint, b int, c bigint, d numeric(4, 2), e float, f double);
insert into numeric_types values(5, 55, 555, 56.78, 1.23, 10000.6789);

commit;

set timezone 'Asia/Seoul';
--test: implicit conversion from numeric constant values to ts types
update tz_test set ts=1, dtltz=1, dttz=1;
select * from tz_test order by 1;
update tz_test set ts=3600, dtltz=3600, dttz=cast(3600 as int);
select * from tz_test order by 1;
update tz_test set ts=cast(86400 as bigint), dtltz=cast(86400 as bigint), dttz=cast(86400 as bigint);
select * from tz_test order by 1;
update tz_test set ts=10.9, dtltz=cast(10.9 as numeric(4, 2)), dttz=10.9;
select * from tz_test order by 1;
update tz_test set ts=cast(86400.99 as float), dtltz=cast(86400.99 as float), dttz=cast(86400.99 as float);
select * from tz_test order by 1;
update tz_test set ts=2147483647, dtltz=2147483647, dttz=2147483647;
select * from tz_test order by 1;

--test: [er] out-of-range
update tz_test set ts=2147483648;
update tz_test set dtltz=2147483648;
update tz_test set ts=2147483648;

rollback;

--test: implicit conversion from numeric types to ts types
update tz_test set ts=(select a from numeric_types), dtltz=(select a from numeric_types), dttz=(select a from numeric_types);
select * from tz_test order by 1;
update tz_test set ts=(select b from numeric_types), dtltz=(select b from numeric_types), dttz=(select b from numeric_types);
select * from tz_test order by 1;
update tz_test set ts=(select c from numeric_types), dtltz=(select c from numeric_types), dttz=(select c from numeric_types);
select * from tz_test order by 1;
rollback;
update tz_test set ts=(select d from numeric_types), dtltz=(select d from numeric_types), dttz=(select d from numeric_types);
select * from tz_test order by 1;
update tz_test set ts=(select e from numeric_types), dtltz=(select e from numeric_types), dttz=(select e from numeric_types);
select * from tz_test order by 1;
update tz_test set ts=(select f from numeric_types), dtltz=(select f from numeric_types), dttz=(select f from numeric_types);
select * from tz_test order by 1;


drop table tz_test, numeric_types;
commit;

set timezone 'Asia/Seoul';

autocommit on;
