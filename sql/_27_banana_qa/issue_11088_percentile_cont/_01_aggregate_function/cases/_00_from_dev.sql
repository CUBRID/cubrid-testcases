--test cases from dev

autocommit off;

drop table if exists percentile_t;

create table percentile_t (a int, c1 short, c2 int, c3 bigint, c4 float, c5 double, c6 monetary, c7 numeric(38,18), c8 date, c9 datetime, c10 timestamp, c11 varchar(255), c12 varchar(255), c13 varchar(255), c14 time);

insert into percentile_t values(1, 1, 1, 1, 1.0, 1.0, 1.0, 1.0, date'2011-1-1', datetime'2011-1-1 1:1:1.111', timestamp'2011-1-1 1:1:1', '1.0', '2011-1-1 1:1:1.111', '1.0', time'0:0:1');
insert into percentile_t values(1, 32767, 2147483647, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, '99999999999999999999.999999999999999999', date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '+1.7976931348623157E+308', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59');
insert into percentile_t values(2, 2, 2, 2, 2.0, 2.0, 2.0, 2.0, date'2012-2-2', datetime'2012-2-2 2:2:2.222', timestamp'2012-2-2 2:2:2', '2.0', '2012-2-2 2:2:2.222', '2.0', time'0:1:2');
insert into percentile_t values(3, 3, 3, 3, 3.0, 3.0, 3.0, 3.0, date'2013-3-3', datetime'2013-3-3 3:3:3.333', timestamp'2013-3-3 3:3:3', '3.0', '2013-3-3 3:3:3.333', '3.0', time'1:2:3');
insert into percentile_t values(3, 4, 5, 6, 7.0, 8.0, 9.0, 10.0, date'2013-3-4', datetime'2013-3-5 3:3:3.333', timestamp'2013-3-6 3:3:3', '7.0', '2013-3-8 3:3:3.333', '9.0', time'2:3:4');
insert into percentile_t values(3, 5, 7, 9, 11.0, 13.0, 15.0, 17.0, date'2013-3-5', datetime'2013-3-7 3:3:3.333', timestamp'2013-3-9 3:3:3', '11.0', '2013-3-13 3:3:3.333', '15.0', time'3:4:5');
insert into percentile_t values(3, 6, 9, 12, 15.0, 18.0, 21.0, 24.0, date'2013-3-6', datetime'2013-3-9 3:3:3.333', timestamp'2013-3-12 3:3:3', '15.0', '2013-3-18 3:3:3.333', '21.0', time'4:5:6');
insert into percentile_t values(3, 7, 11, 15, 19.0, 23.0, 27.0, 31.0, date'2013-3-7', datetime'2013-3-11 3:3:3.333', timestamp'2013-3-15 3:3:3', '19.0', '2013-3-23 3:3:3.333', '27.0', time'5:6:7');
insert into percentile_t values(4, 4, 4, 4, 4.0, 4.0, 4.0, 4.0, date'2014-4-4', datetime'2014-4-4 4:4:4.444', timestamp'2014-4-4 4:4:4', '4.0', '2014-4-4 4:4:4.444', '4.0', time'6:7:8');
insert into percentile_t values(4, 5, 6, 7, 8.0, 9.0, 10.0, 11.0, date'2014-4-5', datetime'2014-4-6 4:4:4.444', timestamp'2014-4-7 4:4:4', '8.0', '2014-4-9 4:4:4.444', '10.0', time'7:8:9');
insert into percentile_t values(4, 6, 8, 10, 12.0, 14.0, 16.0, 18.0, date'2014-4-6', datetime'2014-4-8 4:4:4.444', timestamp'2014-4-10 4:4:4', '12.0', '2014-4-14 4:4:4.444', '16.0', time'8:9:10');
insert into percentile_t values(4, 7, 10, 13, 16.0, 19.0, 22.0, 25.0, date'2014-4-7', datetime'2014-4-10 4:4:4.444', timestamp'2014-4-13 4:4:4', '16.0', '2014-4-19 4:4:4.444', '22.0', time'10:11:12');

--analytic
select a,percentile_cont(0.5) within group (order by c1) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c2) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c3) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c4) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c5) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c6) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c7) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c8) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c9) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c10) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c11) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by cast(c11 as double)) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c12) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by cast(c12 as datetime)) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c13) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by cast(c13 as double)) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c14) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by c14) over(partition by a order by c14) from percentile_t order by 1, 2;
--	constant
select a,percentile_cont(0.5) within group (order by null) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by 123456789) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by date'2013-5-7') over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by datetime'2013-5-7 15:26:30.123') over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by timestamp'2013-5-7 15:26:31') over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by time'15:30:00') over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by '123456789') over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by '2013-5-7') over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by '2013-5-7 15:26:30.123') over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by '2013-5-7 15:26:31') over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by '15:30:00') over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by 'abcdefg') over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.5) within group (order by {0}) over(partition by a) from percentile_t order by 1, 2;
--	host variable
prepare s from 'select a,percentile_cont(0.5) within group (order by ?) over(partition by a) from percentile_t order by 1, 2';
execute s using null;
execute s using 123456789;
execute s using date'2013-5-7';
execute s using datetime'2013-5-7 15:26:30.123';
execute s using timestamp'2013-5-7 15:26:31';
execute s using time'15:30:00';
execute s using '123456789';
execute s using '2013-5-7';
execute s using '2013-5-7 15:26:30.123';
execute s using '2013-5-7 15:26:31';
execute s using '15:30:00';
execute s using 'abcdefg';

deallocate prepare s;

--aggregate
select a,percentile_cont(0.5) within group (order by c1) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c2) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c3) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c4) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c5) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c6) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c7) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c8) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c9) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c10) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c11) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by cast(c11 as double)) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c12) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by cast(c12 as datetime)) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c13) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by cast(c13 as double)) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by c14) from percentile_t group by a order by 1, 2;
--	constant
select a,percentile_cont(0.5) within group (order by null) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by 123456789) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by date'2013-5-7') from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by datetime'2013-5-7 15:26:30.123') from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by timestamp'2013-5-7 15:26:31') from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by time'15:30:00') from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by '123456789') from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by '2013-5-7') from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by '2013-5-7 15:26:30.123') from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by '2013-5-7 15:26:31') from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by '15:30:00') from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by 'abcdefg') from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.5) within group (order by {0}) from percentile_t group by a order by 1, 2;
--	host variable
prepare s from 'select a,percentile_cont(0.5) within group (order by ?) from percentile_t group by a';
execute s using null;
execute s using 123456789;
execute s using date'2013-5-7';
execute s using datetime'2013-5-7 15:26:30.123';
execute s using timestamp'2013-5-7 15:26:31';
execute s using time'15:30:00';
execute s using '123456789';
execute s using '2013-5-7';
execute s using '2013-5-7 15:26:30.123';
execute s using '2013-5-7 15:26:31';
execute s using '15:30:00';
execute s using 'abcdefg';

deallocate prepare s;

--more test
insert into percentile_t values(2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '123', NULL);
insert into percentile_t values(3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '234', NULL);
insert into percentile_t values(4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '345', NULL);
insert into percentile_t values(5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'abc', NULL);
--	analytic
select a,percentile_cont(0.2) within group (order by c1) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c2) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c3) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c4) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c5) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c6) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c7) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c8) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c9) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c10) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c11) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by cast(c11 as double)) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c12) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by cast(c12 as datetime)) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c13) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by cast(c13 as double)) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c14) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(0.2) within group (order by c14) over(partition by a order by c14) from percentile_t order by 1, 2;
--	aggregate
select a,percentile_cont(0.2) within group (order by c1) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c2) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c3) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c4) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c5) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c6) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c7) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c8) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c9) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c10) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c11) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by cast(c11 as double)) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c12) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by cast(c12 as datetime)) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c13) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by cast(c13 as double)) from percentile_t group by a order by 1, 2;
select a,percentile_cont(0.2) within group (order by c14) from percentile_t group by a order by 1, 2;

--		more test
select a,percentile_cont(a/5.0) within group (order by c1) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c2) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c3) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c4) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c5) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c6) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c7) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c8) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c9) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c10) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c11) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by cast(c11 as double)) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c12) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by cast(c12 as datetime)) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c13) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by cast(c13 as double)) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c14) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c14) over(partition by a order by c14) from percentile_t order by 1, 2;
--		aggregate
select a,percentile_cont(a/5.0) within group (order by c1) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c2) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c3) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c4) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c5) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c6) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c7) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c8) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c9) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c10) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c11) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by cast(c11 as double)) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c12) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by cast(c12 as datetime)) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c13) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by cast(c13 as double)) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c14) from percentile_t group by a order by 1, 2;
--		fails
select a,percentile_cont(a) within group (order by c1) over(partition by a) from percentile_t order by 1, 2;
select a,percentile_cont(a) within group (order by c1) from percentile_t group by a order by 1, 2;
select a,percentile_cont(a/5.0) within group (order by c1) over() from percentile_t order by 1, 2;
--		host variable
prepare s from 'select a,percentile_cont(?) within group (order by c1) over(partition by a) from percentile_t order by 1, 2';
execute s using null;
execute s using 123456789;
execute s using date'2013-5-7';
execute s using datetime'2013-5-7 15:26:30.123';
execute s using timestamp'2013-5-7 15:26:31';
execute s using time'15:30:00';
execute s using '123456789';
execute s using '2013-5-7';
execute s using '2013-5-7 15:26:30.123';
execute s using '2013-5-7 15:26:31';
execute s using '15:30:00';
execute s using 'abcdefg';
prepare s from 'select a,percentile_cont(?) within group (order by c1) from percentile_t group by a order by 1, 2';
execute s using null;
execute s using 123456789;
execute s using date'2013-5-7';
execute s using datetime'2013-5-7 15:26:30.123';
execute s using timestamp'2013-5-7 15:26:31';
execute s using time'15:30:00';
execute s using '123456789';
execute s using '2013-5-7';
execute s using '2013-5-7 15:26:30.123';
execute s using '2013-5-7 15:26:31';
execute s using '15:30:00';
execute s using 'abcdefg';

deallocate prepare s;


drop table if exists percentile_t;

--keyword test
create table percentile_t (percentile_cont int, within int);
drop table if exists percentile_t; 

commit;
autocommit on;
