--test all kinds of date/time types for the 1st parameter



create table soo(
	col1 date,
	col2 time,
	col3 timestamp,
	col4 datetime
);



insert into soo values (date'2010-10-25', time'13:25:21', timestamp'2010-10-25 13:25:21', datetime'2010-10-25 13:25:21.123');


--date
select repeat(col1, 3) from soo;
--time
select repeat(col2, 3) from soo;
--timestamp
select repeat(col3, 3) from soo;
--datetime
select repeat(col4, 3) from soo;


drop table soo;
