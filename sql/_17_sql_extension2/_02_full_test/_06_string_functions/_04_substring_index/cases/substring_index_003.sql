--test all kinds of date/time types for the first 2 params



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



insert into soo values (date'2010-10-18', time'10:10:18 am', timestamp'10/18/2010 10:10:18 pm', datetime'10:10:18.101 2010-10-18',
			date'10-10', time'18', timestamp'10/18/2010 10:10:18', datetime'10:10:18.101 2010-10-18');


--combination of date and all the date/time types
select substring_index(col1, col5, 1) from soo;
select substring_index(col1, col6, -1) from soo;
select substring_index(col1, col7, 1) from soo;
select substring_index(col1, col8, -1) from soo;


--combination of time and all the date/time types
select substring_index(col2, col5, 1) from soo;
select substring_index(col2, col6, -1) from soo;
select substring_index(col2, col7, 1) from soo;
select substring_index(col2, col8, -1) from soo;


--combination of timestamp and all the date/time types
select substring_index(col3, col5, 1) from soo;
select substring_index(col3, col6, -1) from soo;
select substring_index(col3, col7, 1) from soo;
select substring_index(col3, col8, -1) from soo;


--combination of datetime and all the date/time types
select substring_index(col4, col5, 1) from soo;
select substring_index(col4, col6, -1) from soo;
select substring_index(col4, col7, 1) from soo;
select substring_index(col4, col8, -1) from soo;


drop table soo;
