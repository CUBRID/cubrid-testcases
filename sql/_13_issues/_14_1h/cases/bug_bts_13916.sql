drop table if exists median_t;
create table median_t (a int, c11 varchar(255));
insert into median_t values(3,'19.0');
insert into median_t values(3, '3.0');
insert into median_t values(3,'7.0');
insert into median_t values(3,'11.0');
insert into median_t values(3, '15.0');
select median(cast(c11 as double)) from median_t;
select median(cast(c11 as float)) from median_t group by a;
select median(cast(c11 as double)) from median_t group by a;
select median(cast(c11 as int)) from median_t group by a;
select median(cast(c11 as short)) from median_t group by a;
select median(cast(c11 as bigint)) from median_t group by a;
select median(cast(c11 as monetary)) from median_t group by a;
select median(cast(c11 as numeric(10,2))) from median_t group by a;
select median(cast(c11 as time)) from median_t group by a;
select median(cast(c11 as timestamp)) from median_t group by a;
select median(cast(c11 as datetime)) from median_t group by a;


drop table if exists median_t;
create table median_t (a int, c11 varchar(255));
insert into median_t values(3, '3.0');
insert into median_t values(3,'7.0');
insert into median_t values(3,'11.0');
insert into median_t values(3, '15.0');
insert into median_t values(3,'19.0');
select a,c11 from median_t order by 1,2 asc;
select a,cast(c11 as double) from median_t order by 1,2 asc;
 
select median(cast(newt.c11 as double) ) from (select a,c11 from median_t order by 1 ,2 asc) newt group by newt.a ;
select median(newt.c11 ) from (select a,c11 from median_t order by 1 ,2 asc) newt group by newt.a ;

drop table if exists median_t;
create table median_t (a int, c12 varchar(255));
insert into median_t values(3, '2013-03-18');
insert into median_t values(3,  '2013-03-23');
insert into median_t values(3,  '2013-03-03');
insert into median_t values(3,  '2013-03-08');
insert into median_t values(3, '2013-03-13');
select median(cast(c12 as timestamp)) from median_t;
select median(to_date(c12 , 'yyyy-mm-dd')) from median_t group by a;
select median(cast(c12 as date )) from median_t group by a;
select median(cast(c12 as datetime)) from median_t group by a;
select median(cast(c12 as timestamp)) from median_t group by a;

drop table if exists median_t;
create table median_t(a int,c double);
insert into median_t values(3,3.3);
insert into median_t values(4,4.4);
insert into median_t values(1,1.1);
insert into median_t values(9,9.9);
select median(cast(a as bigint)) from median_t;
select median(cast(a as double)) from median_t;
select median(cast(a as short)) from median_t;
select median(cast(a as float)) from median_t;
select median(cast(a as monetary)) from median_t;
select median(cast(a as date)) from median_t;

select median(cast(c as bigint)) from median_t;

drop table if exists median_t;
create table median_t(a int,c double);
insert into median_t values(3,4.3);
insert into median_t values(4,7.6);
insert into median_t values(1,3.1);
insert into median_t values(9,9.9);
select median(cast(a as bigint)) from median_t;
select median(cast(a as double)) from median_t;
select median(cast(a as short)) from median_t;
select median(cast(a as float)) from median_t;
select median(cast(a as monetary)) from median_t;
select median(cast(a as date)) from median_t;

select median(cast(c as bigint)) from median_t;

drop table if exists median_t;

create table median_t (a int, c1 short, c2 int, c3 bigint, c4 float, c5 double, c6 monetary, c7 numeric(38,18), c8 date, c9 datetime, c10 timestamp, c11 varchar(255), c12 varchar(255), c13 varchar(255), c14 time);

insert into median_t values(1, 1, 1, 1, 1.0, 1.0, 1.0, 1.0, date'2011-1-1', datetime'2011-1-1 1:1:1.111', timestamp'2011-1-1 1:1:1', '1.0', '2011-1-1 1:1:1.111', '1.0', time'0:0:1');
insert into median_t values(3, 5, 7, 9, 11.0, 13.0, 15.0, 17.0, date'2013-3-5', datetime'2013-3-7 3:3:3.333', timestamp'2013-3-9 3:3:3', '7.0', '2013-3-13 3:3:3.333', '15.0', time'3:4:5');
insert into median_t values(3, 4, 5, 6, 7.0, 8.0, 9.0, 10.0, date'2013-3-4', datetime'2013-3-5 3:3:3.333', timestamp'2013-3-6 3:3:3', '11.0', '2013-3-8 3:3:3.333', '9.0', time'2:3:4');
insert into median_t values(3, 3, 3, 3, 3.0, 3.0, 3.0, 3.0, date'2013-3-3', datetime'2013-3-3 3:3:3.333', timestamp'2013-3-3 3:3:3', '3.0', '2013-3-3 3:3:3.333', '3.0', time'1:2:3');
insert into median_t values(1, 32767, 2147483647, 9223372036854775807, +3.402823466E+38, +1.7976931348623157E+308, +3.402823466E+38, '99999999999999999999.999999999999999999', date'2099-12-31', datetime'2099-12-31 23:59:59.999', timestamp'2012-12-31 23:59:59', '32.0', '2099-12-31 23:59:59.999', '32164654987', time'23:59:59');
insert into median_t values(2, 2, 2, 2, 2.0, 2.0, 2.0, 2.0, date'2012-2-2', datetime'2012-2-2 2:2:2.222', timestamp'2012-2-2 2:2:2', '2.0', '2012-2-2 2:2:2.222', '2.0', time'0:1:2');
insert into median_t values(3, 6, 9, 12, 15.0, 18.0, 21.0, 24.0, date'2013-3-6', datetime'2013-3-9 3:3:3.333', timestamp'2013-3-12 3:3:3', '15.0', '2013-3-18 3:3:3.333', '21.0', time'4:5:6');
insert into median_t values(3, 7, 11, 15, 19.0, 23.0, 27.0, 31.0, date'2013-3-7', datetime'2013-3-11 3:3:3.333', timestamp'2013-3-15 3:3:3', '19.0', '2013-3-23 3:3:3.333', '27.0', time'5:6:7');
insert into median_t values(4, 4, 4, 4, 4.0, 4.0, 4.0, 4.0, date'2014-4-4', datetime'2014-4-4 4:4:4.444', timestamp'2014-4-4 4:4:4', '8.0', '2014-4-4 4:4:4.444', '4.0', time'6:7:8');
insert into median_t values(4, 5, 6, 7, 8.0, 9.0, 10.0, 11.0, date'2014-4-5', datetime'2014-4-6 4:4:4.444', timestamp'2014-4-7 4:4:4', '16.0', '2014-4-9 4:4:4.444', '10.0', time'7:8:9');
insert into median_t values(4, 6, 8, 10, 12.0, 14.0, 16.0, 18.0, date'2014-4-6', datetime'2014-4-8 4:4:4.444', timestamp'2014-4-10 4:4:4', '12.0', '2014-4-14 4:4:4.444', '16.0', time'8:9:10');
insert into median_t values(4, 7, 10, 13, 16.0, 19.0, 22.0, 25.0, date'2014-4-7', datetime'2014-4-10 4:4:4.444', timestamp'2014-4-13 4:4:4', '4.0', '2014-4-19 4:4:4.444', '22.0', time'10:11:12');
select a,median(c11) from median_t group by a order by 1;
select a,c11,median(c11) over(partition by a ) from median_t order by 1,2;
select a,median(cast(c11 as int)) from median_t group by a order by 1;
select a,c11,median(cast(c11 as int)) over(partition by a ) from median_t order by 1,2;
select a,median(cast(c11 as short)) from median_t group by a order by 1;
select a,median(cast(c11 as bigint)) from median_t group by a order by 1;
select a,median(cast(c11 as float)) from median_t group by a order by 1;
select a,median(cast(c11 as double)) from median_t group by a order by 1;
select a,median(cast(c11 as monetary)) from median_t group by a order by 1;
select a,median(cast(c11 as numeric(38,18))) from median_t group by a order by 1;
select a,median(cast(c11 as date)) from median_t group by a order by 1;
select a,median(cast(c11 as datetime)) from median_t group by a order by 1;
select a,median(cast(c11 as timestamp)) from median_t group by a order by 1;
select a,median(cast(c11 as time)) from median_t group by a order by 1;
select a,cast(c11 as time),median(cast(c11 as time)) over(partition by a) from median_t order by 1,2;


select a,median(c12) from median_t group by a order by 1;
select a,c12,median(c12) over(partition by a) from  median_t order by 1,2;
select a,median(cast(c12 as int)) from median_t group by a order by 1;
select a,median(cast(c12 as short)) from median_t group by a order by 1;
select a,median(cast(c12 as bigint)) from median_t group by a order by 1;
select a,median(cast(c12 as float)) from median_t group by a order by 1;
select a,median(cast(c12 as double)) from median_t group by a order by 1;
select a,median(cast(c12 as monetary)) from median_t group by a order by 1;
select a,median(cast(c12 as numeric(38,18))) from median_t group by a order by 1;
select a,median(cast(c12 as date)) from median_t group by a order by 1;
select a,median(cast(c12 as datetime)) from median_t group by a order by 1;
select a,median(cast(c12 as timestamp)) from median_t group by a order by 1;
select a,median(cast(c12 as time)) from median_t group by a order by 1;
select a,cast(c12 as time),median(cast(c12 as time)) over (partition by a )  from median_t order by 1,2;

insert into median_t values(2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '123', NULL);
insert into median_t values(3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '234', NULL);
insert into median_t values(4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '345', NULL);
insert into median_t values(5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'abc', NULL);

select a,median(c11) from median_t group by a order by 1;
select a,median(cast(c11 as int)) from median_t group by a order by 1;
select a,median(cast(c11 as short)) from median_t group by a order by 1;
select a,median(cast(c11 as bigint)) from median_t group by a order by 1;
select a,median(cast(c11 as float)) from median_t group by a order by 1;
select a,median(cast(c11 as double)) from median_t group by a order by 1;
select a,median(cast(c11 as monetary)) from median_t group by a order by 1;
select a,median(cast(c11 as numeric(38,18))) from median_t group by a order by 1;
select a,median(cast(c11 as date)) from median_t group by a order by 1;
select a,median(cast(c11 as datetime)) from median_t group by a order by 1;
select a,median(cast(c11 as timestamp)) from median_t group by a order by 1;
select a,median(cast(c11 as time)) from median_t group by a order by 1;
select a,median(c12) from median_t group by a order by 1,2;
select a,median(cast(c12 as datetime)) from median_t group by a order by 1;
select a,median(cast(c12 as timestamp)) from median_t group by a order by 1;
select a,median(cast(c12 as date)) from median_t group by a order by 1;
drop table median_t;
