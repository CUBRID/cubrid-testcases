--pass out-of-range data of string type to the parameter



--1. [error] out-of-range argument of date format
select week('13/11/1989');

select week('05/33/1901');

select week('2/20/10000');

select week('0-1-1');

select week('1999-04-31');

select week('03-02-31');



--2. [error] out-of-range argument of timestamp format
select week('23:00:00 13/01');

select week('04:14:07 1/19/2038');

select week('03:15:07 1/19/2038');

select week('03:14:08 1/19/2038');

select week('03:14:07 2/19/2038');

select week('03:14:07 1/20/2038');

select week('03:14:07 1/19/2039');

--??
select week('03:14:07 PM 1/19/2038');

select week('0:0:0 PM 1969-01-01');

select week('11:03:22 PM 1864-01-23');

select week('2300-12-12 22:02:33');

select week('2020-23-11 03:14:66 pm');

select week('1970-10-101 0:0');

select week('1999/12/11 3:14:7 am');

select week('2010-4-31 3:14:7 am');



--3. [error] out-of-range argument of datetime format
select week('2010-10 10:10:100.00 am');

select week('24:59:59.999 12/31/9999');

select week('23:60:59.999 12/31/9999');

select week('23:59:60.999 12/31/9999');

select week('23:59:59.1000 12/31/9999');

select week('23:59:59.999 13/31/9999');

select week('23:59:59.999 12/32/9999');

select week('23:59:59.999 12/31/10000');

select week('20:33:61.111 1990-10-19 ');

select week('2/31/2022 10:20:30.400');

select week('12/31/9999 23:59:59.999');

select week('0-12-12 23:59:59:999');

