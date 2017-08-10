--TEST: test with date/time data types and normal syntax


create table rownum_date_time(
	col1 date,
	col2 time, 
	col3 timestamp,
	col4 datetime
);


insert into rownum_date_time values('2000-12-12', '11:11:11', '1990-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values('2000-12-12', '12:12:12', '1991-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values('2000-12-12', '11:11:11', '1992-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values('2000-12-12', '12:12:12', '1993-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values('2000-12-12', '11:11:11', '1994-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values(date'1999-11-11', '12:12:12', '1995-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values(date'1999-11-11', '11:11:11', '1996-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values(date'1999-11-11', '11:11:11', '1997-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values(date'1999-11-11', '13:13:13', '1998-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values('10/10/2001', '11:11:11', '1999-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values('10/10/2001', '11:11:11', '2000-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values('10/10/2001', '13:13:13', '2001-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values('2011-11-23', '11:11:11', '2002-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values(date'1888-09-09', '11:11:11', '2003-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values(date'1888-09-09', '12:12:12', '2004-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values(date'1888-09-09', '11:11:11', '2005-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values(date'1888-09-09', '11:11:11', '2006-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values(date'1888-09-09', '13:13:13', '2007-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values(date'1888-09-09', '11:11:11', '2008-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into rownum_date_time values(date'1888-09-09', '11:11:11', '2009-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');


--TEST: OVER() clause
--TEST: no alias 
select row_num from (select  col1, col2, row_number() over() row_num from rownum_date_time) order by 1;
--TEST: with alias
select row_num from (select  col2, col3, row_number() over() row_num from rownum_date_time) order by 1;
--TEST: with where clause
select row_num from (select  col3, col4, row_number() over() row_num from rownum_date_time where col1 > '2000-12-12') order by 1;
--TEST:
select row_num from (select  col4, col1, row_number() over() row_num from rownum_date_time) order by 1;
select row_num from (select  *, row_number() over() row_num from rownum_date_time) order by 1;
--TEST: syntax error
select col1, col3, col4, row_number() over row_num from rownum_date_time;
select col1, col3, col2, row_number() over(1) row_num from rownum_date_time;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by date
select row_num from (select  col1, col2, col3, col4, row_number() over(partition by col1) row_num from rownum_date_time) order by 1;
select row_num from (select  col1, col2, col3, col4, row_number() over(partition by 1) row_num from rownum_date_time) order by 1;
--TEST: partition by time
select row_num from (select  col1, col2, col3, col4, row_number() over(partition by col2) row_num from rownum_date_time) order by 1;
--TEST: partition by timestamp
select row_num from (select  col1, col2, col3, col4, row_number() over(partition by col3) row_num from rownum_date_time) order by 1;
--TEST: partition by datetime
select row_num from (select  col1, col2, col3, col4, row_number() over(partition by col4) row_num from rownum_date_time) order by 1;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, row_number() over(order by col1) row_num from rownum_date_time order by 1, 2;
--TEST: order by 2 column names
select col2, col3, row_number() over(order by col2, col3 asc) row_num from rownum_date_time order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, row_number() over(order by col1, col2 desc, col3, col4 asc) row_num from rownum_date_time order by 1, 2, 3, 4, 5;
--TEST: order by columns not selected
select row_num from (select col3, row_number() over(order by col4 desc, col2, col1 asc) row_num from rownum_date_time) order by 1;
--TEST: order by 1 position
select col4, row_number() over(order by 1) row_num from rownum_date_time order by 1, 2;
--TEST: order by 3 positions
select col3, col2, row_number() over(order by 1, 2 desc, 3 asc) row_num from rownum_date_time;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, row_number() over(order by 3, 2 asc, 1 desc, 4) row_num from rownum_date_time;
--TEST: order by positions not existed
select col2, row_number() over(order by 2) row_num from rownum_date_time;
select col1, row_number() over(order by 3, 4, 1 desc) row_num, col2, col4 from rownum_date_time;
select col3, col4, row_number() over(order by 5) row_num from rownum_date_time;
select col3, col1, row_number() over(order by 100) row_num from rownum_date_time;
--TEST: order by column names and positions
select col1, col2, col3, col4, row_number() over(order by 1, col2 desc, 3, col4 asc) row_num from rownum_date_time;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by date
select col1, col2, col3, row_number() over(partition by col1 order by col1, col2, col3) from rownum_date_time;
--TEST: partition by time
select col2, col4, col1, row_number() over(partition by col2 order by col2, col4, col1 desc) from rownum_date_time;
--TEST: partition by timestamp
select col3, row_number() over(partition by col3 order by col3) row_num, col2 from rownum_date_time;
--TEST: partition by datetime
select col4, col1, row_number() over(partition by col4 order by 1, 2 desc) row_num from rownum_date_time;
--TEST: syntax error
select col1, col2, row_number() over(order by col1, col2 partition by col2) from rownum_date_time;



drop table rownum_date_time; 















