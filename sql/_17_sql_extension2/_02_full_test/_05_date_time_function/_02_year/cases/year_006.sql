--pass out-of-range data of string type to the parameter



--1. [error] out-of-range argument of date format
select year('13/11/1989');

select year('05/33/1901');

select year('2/20/10000');

select year('0-1-1');

select year('1999-04-31');

select year('03-02-31');



--2. [error] out-of-range argument of timestamp format
select year('23:00:00 13/01');

select year('04:14:07 1/19/2038');

select year('03:15:07 1/19/2038');

select year('03:14:08 1/19/2038');

select year('03:14:07 2/19/2038');

select year('03:14:07 1/20/2038');

select year('03:14:07 1/19/2039');

--??
select year('03:14:07 PM 1/19/2038');

select year('0:0:0 PM 1969-01-01');

select year('11:03:22 PM 1864-01-23');

select year('2300-12-12 22:02:33');

select year('2020-23-11 03:14:66 pm');

select year('1970-10-101 0:0');

select year('1999/12/11 3:14:7 am');

select year('2010-4-31 3:14:7 am');



--3. [error] out-of-range argument of datetime format
select year('2010-10 10:10.100:00 am');

select year('24:59:59.999 12/31/9999');

select year('23:60:59.999 12/31/9999');

select year('23:59:60.999 12/31/9999');

select year('23:59:59.000 12/31/9999');

select year('23:59:59.999 13/31/9999');

select year('23:59:59.999 12/32/9999');

select year('23:59:59.999 12/31/10000');

select year('20:33:61.111 1990-10-19 ');

select year('2/31/2022 10:20:30.400');

select year('12/31/9999 23:59:59.999');

select year('0-12-12 23:59:59:999');

