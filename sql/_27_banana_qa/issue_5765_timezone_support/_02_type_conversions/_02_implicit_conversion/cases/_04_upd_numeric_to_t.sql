--implicit conversion from numeric types to TIME(L)TZ types, in update


autocommit off;

drop table if exists tz_test, numeric_types;

create table tz_test (id int auto_increment, t time, tltz time , ttz time );
set timezone '+10:00';
insert into tz_test(t, tltz, ttz) values (time'2:00:00', time'2:00:00', time'2:00:00');

create table numeric_types (a smallint, b int, c bigint, d numeric(4, 2), e float, f double);
insert into numeric_types values(5, 55, 555, 56.78, 1.23, 10000.6789);

commit;

set timezone '+9:00';
--test: implicit conversion from numeric constant values to t types
update tz_test set t=1, tltz=1, ttz=1;
select * from tz_test order by 1;
update tz_test set t=3600, tltz=3600, ttz=cast(3600 as int);
select * from tz_test order by 1;
update tz_test set t=cast(86400 as bigint), tltz=cast(86400 as bigint), ttz=cast(86400 as bigint);
select * from tz_test order by 1;
update tz_test set t=10.9, tltz=cast(10.9 as numeric(4, 2)), ttz=10.9;
select * from tz_test order by 1;
update tz_test set t=cast(86400.99 as float), tltz=cast(86400.99 as float), ttz=cast(86400.99 as float);
select * from tz_test order by 1;
update tz_test set t=2147483647, tltz=2147483647, ttz=2147483647;
select * from tz_test order by 1;

--test: [er] out-of-range
update tz_test set t=2147483648;
update tz_test set tltz=2147483648;
update tz_test set t=2147483648;

rollback;

--test: implicit conversion from numeric types to t types
update tz_test set t=(select a from numeric_types), tltz=(select a from numeric_types), ttz=(select a from numeric_types);
select * from tz_test order by 1;
update tz_test set t=(select b from numeric_types), tltz=(select b from numeric_types), ttz=(select b from numeric_types);
select * from tz_test order by 1;
update tz_test set t=(select c from numeric_types), tltz=(select c from numeric_types), ttz=(select c from numeric_types);
select * from tz_test order by 1;
rollback;
update tz_test set t=(select d from numeric_types), tltz=(select d from numeric_types), ttz=(select d from numeric_types);
select * from tz_test order by 1;
update tz_test set t=(select e from numeric_types), tltz=(select e from numeric_types), ttz=(select e from numeric_types);
select * from tz_test order by 1;
update tz_test set t=(select f from numeric_types), tltz=(select f from numeric_types), ttz=(select f from numeric_types);
select * from tz_test order by 1;


drop table tz_test, numeric_types;
commit;

set timezone 'Asia/Seoul';

autocommit on;
