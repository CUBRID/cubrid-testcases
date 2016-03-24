--implicit conversion from numeric types to DATETIME(L)TZ types, in insert 


drop table if exists tz_test, numeric_types;

create table tz_test (id int auto_increment, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone);
set timezone '+10:00';

create table numeric_types (a smallint, b int, c bigint, d numeric(4, 2), e float, f double);
insert into numeric_types values(5, 55, 555, 56.78, 1.23, 10000.6789);

set timezone 'Asia/Seoul';
--test: implicit conversion from numeric constant values to ts types
insert into tz_test(ts, dtltz, dttz) values (1, cast(1 as short), 1);
insert into tz_test(ts, dtltz, dttz) values (3600, 3600, cast(3600 as int));
insert into tz_test(ts, dtltz, dttz) values (cast(86400 as bigint), 86400, 86000);
insert into tz_test(ts, dtltz, dttz) values (10.9, cast(10.9 as numeric(4, 2)), 10.9);
insert into tz_test(ts, dtltz, dttz) values (86400.99, 86400.99, cast(86400.99 as float));
insert into tz_test(ts, dtltz, dttz) values (2147483647, 2147483647, 2147483647);
select * from tz_test order by 1;

--test: [er] out-of-range
insert into tz_test(ts) values (2147483648);
insert into tz_test(dtltz) values (2147483648);
insert into tz_test(dttz) values (2147483648);

--test: implicit conversion from numeric types to ts types
insert into tz_test(ts, dtltz, dttz) values (select a from numeric_types, select a from numeric_types, select a from numeric_types);
insert into tz_test(ts, dtltz, dttz) values (select b from numeric_types, select b from numeric_types, select b from numeric_types);
insert into tz_test(ts, dtltz, dttz) values (select c from numeric_types, select c from numeric_types, select c from numeric_types);
insert into tz_test(ts, dtltz, dttz) values (select d from numeric_types, select d from numeric_types, select d from numeric_types);
insert into tz_test(ts, dtltz, dttz) values (select e from numeric_types, select e from numeric_types, select e from numeric_types);
insert into tz_test(ts, dtltz, dttz) values (select f from numeric_types, select f from numeric_types, select f from numeric_types);
select * from tz_test order by 1;


drop table tz_test, numeric_types;

set timezone 'Asia/Seoul';
