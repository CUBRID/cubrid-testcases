--insert into DATETIMETZ columns, with boundary and out-of-range values

set time zone 'GMT';

drop table if exists tz_test;
create table tz_test(id int auto_increment, col datetime with time zone);

--test: test with bounadary values
insert into tz_test(col) values(datetimetz'0001-01-01 00:00:0.000');
--BUG: CUBRIDSUS-16274
insert into tz_test(col) values(datetimetz'9999-12-31 23:59:59.999');
--BUG: CUBRIDSUS-16277
insert into tz_test(col) values(datetimetz'0000-00-00 00:00:00');
insert into tz_test(col) values(datetimetz'0001-01-01 00:00:0.000 +00:00');
insert into tz_test(col) values(datetimetz'0001-01-01 05:00:00.000 +05:00');
insert into tz_test(col) values(datetimetz'0001-01-01 14:00:00.000 +14:00');
insert into tz_test(col) values(datetimetz'0001-01-01 00:00:0.000 -0:00');
insert into tz_test(col) values(datetimetz'0000-12-31 13:00:0.000 -10:00');
insert into tz_test(col) values(datetimetz'9999-12-31 23:59:59.999 +0:00');
insert into tz_test(col) values(datetimetz'9999-12-31 21:59:59.999 -2:00');
insert into tz_test(col) values(datetimetz'9999-12-31 11:59:59.999 -12:00');
insert into tz_test(col) values(datetimetz'0000-00-00 00:00:00.789 +00:00');
insert into tz_test(col) values(datetimetz'9999-12-31 23:59:59.999 -00:00');
insert into tz_test(col) values(datetimetz'0001-01-01 00:00:0.000 GMT');
insert into tz_test(col) values(datetimetz'9999-12-31 23:59:59.999 GMT');
insert into tz_test(col) values(datetimetz'0001-01-01 08:00:00.001 Asia/Shanghai');
insert into tz_test(col) values(datetimetz'0001-01-01 09:00:01.000 AM Asia/Seoul LMT');
insert into tz_test(col) values(datetimetz'0001-01-01 09:00:00.000 AM Asia/Seoul');
insert into tz_test(col) values(datetimetz'10000-01-01 8:59:59.999 Asia/Seoul KST');
insert into tz_test(col) values(datetimetz'9999-12-31 20:59:59.999 Antarctica/Palmer');

select * from tz_test where id <> 3 order by 1;
select * from tz_test order by id;


--test: [er] test with out-of-value values
insert into tz_test(col) values(datetimetz'0000-12-31 00:00:00.000');
insert into tz_test(col) values(datetimetz'10000-01-01 00:00:00:001');
insert into tz_test(col) values(datetimetz'0000-12-31 00:00:00.789');
insert into tz_test(col) values(datetimetz'12345-05-01 03:14:08.2345');
insert into tz_test(col) values(datetimetz'0001-01-01 12:30:00.000 AM +01:00');
insert into tz_test(col) values(datetimetz'0001-01-01 00:01:01.876 +00:02');
insert into tz_test(col) values(datetimetz'9999-12-31 23:59:59.999 -00:30');
insert into tz_test(col) values(datetimetz'10000-01-01 12:00:00 AM -00:00');
insert into tz_test(col) values(datetimetz'9999-12-31 21:00:00.000 Antarctica/Palmer');
insert into tz_test(col) values(datetimetz'10000-01-01 14:00:00.000 +14:01');
insert into tz_test(col) values(datetimetz'10000-01-01 15:00:00 +15:00');
insert into tz_test(col) values(datetimetz'9999-12-31 11:59:59.000 -12:01');
insert into tz_test(col) values(datetimetz'9999-12-31 20:59:59.000 -13:00');

select * from tz_test where id <> 3 order by 1;
select * from tz_test order by 1;


drop table tz_test;

set time zone 'Asia/Seoul';

