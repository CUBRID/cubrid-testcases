--test all kinds of date/time types for the 1st and the 4th parameter



create table soo(
	col1 date,
	col2 time,
	col3 timestamp,
	col4 datetime,
	col5 date,
	col6 time,
	col7 timestamp,
	col8 datetime
);



insert into soo values (date'2010-10-25', time'13:25:21', timestamp'2010-10-25 13:25:21', datetime'2010-10-25 13:25:21.123',
			date'09/09/1999', time'11:11:11', timestamp'09/09/1999 11:11:11 am', datetime'11:11:11.111 PM 09/09/1999');


--combination of date and all the date/time types
select insert(col1, 3, 6, col5) from soo;
select insert(col1, 3, 6, col6) from soo;
select insert(col1, 3, 6, col7) from soo;
select insert(col1, 3, 6, col8) from soo;


--combination of time and all the date/time types
select insert(col2, 3, 6, col5) from soo;
select insert(col2, 3, 6, col6) from soo;
select insert(col2, 3, 6, col7) from soo;
select insert(col2, 3, 6, col8) from soo;


--combination of timestamp and all the date/time types
select insert(col3, 3, 6, col5) from soo;
select insert(col3, 3, 6, col6) from soo;
select insert(col3, 3, 6, col7) from soo;
select insert(col3, 3, 6, col8) from soo;


--combination of datetime and all the date/time types
select insert(col4, 3, 6, col5) from soo;
select insert(col4, 3, 6, col6) from soo;
select insert(col4, 3, 6, col7) from soo;
select insert(col4, 3, 6, col8) from soo;


drop table soo;
