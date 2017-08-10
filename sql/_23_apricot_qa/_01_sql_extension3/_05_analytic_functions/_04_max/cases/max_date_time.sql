--TEST: test with date/time data types and normal syntax


create table max_date_time(
	col1 date,
	col2 time, 
	col3 timestamp,
	col4 datetime,
	col5 smallint
);


insert into max_date_time values('2000-12-12', '11:11:11', '1990-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 111);
insert into max_date_time values('2000-12-12', '12:12:12', '1991-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 222);
insert into max_date_time values('2000-12-12', '11:11:11', '1992-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 333);
insert into max_date_time values('2000-12-12', '12:12:12', '1993-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 111);
insert into max_date_time values('2000-12-12', '11:11:11', '1994-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 444);
insert into max_date_time values(date'1999-11-11', '12:12:12', '1995-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 555);
insert into max_date_time values(date'1999-11-11', '11:11:11', '1996-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 666);
insert into max_date_time values(date'1999-11-11', '11:11:11', '1997-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 444);
insert into max_date_time values(date'1999-11-11', '13:13:13', '1998-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 777);
insert into max_date_time values('10/10/2001', '11:11:11', '1999-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 888);
insert into max_date_time values('10/10/2001', '11:11:11', '2000-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 999);
insert into max_date_time values('10/10/2001', '13:13:13', '2001-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 444);
insert into max_date_time values('2011-11-23', '11:11:11', '2002-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 222);
insert into max_date_time values(date'1888-09-09', '11:11:11', '2003-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 333);
insert into max_date_time values(date'1888-09-09', '12:12:12', '2004-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 909);
insert into max_date_time values(date'1888-09-09', '11:11:11', '2005-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 888);
insert into max_date_time values(date'1888-09-09', '11:11:11', '2006-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 999);
insert into max_date_time values(date'1888-09-09', '13:13:13', '2007-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 101);
insert into max_date_time values(date'1888-09-09', '11:11:11', '2008-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 222);
insert into max_date_time values(date'1888-09-09', '11:11:11', '2009-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 555);


--TEST: OVER() clause
--TEST: date 
select col1, col2, max(col5) over() from max_date_time order by 1, 2;
--TEST: time, with alias+all
select col2, col3, max(all col4) over() maximum from max_date_time order by 1, 2;
--TEST: timestamp, with where clause
select col3, col4, max(col3) over() maximum from max_date_time where col1 > '2000-12-12' order by col3, col4;
--TEST: datetime, distinct
select col4, col1, max(distinct col2) over() maximum from max_date_time order by 1, 2;
select col5, max(col5) over() maximum from max_date_time;
--TEST: syntax error
select col1, col3, col4, max(col5) over maximum from max_date_time;
select col1, col3, col2, max(col5) over(1) maximum from max_date_time;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by date
select col1, col2, col3, col4, max(col1) over(partition by col1) maximum from max_date_time order by 1, 2, 3, 4;
--TEST: partition by time
select col1, col2, col3, col4, max(distinct col2) over(partition by col2) maximum from max_date_time order by 2, 1, 3, 4;
--TEST: partition by timestamp
select col1, col2, col3, col4, max(unique col3) over(partition by col3) maximum from max_date_time order by 3, 1, 2, 4;
--TEST: partition by datetime
select col1, col2, col3, col4, max(all col5) over(partition by col4) maximum from max_date_time order by 4, 1, 2, 3, 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, max(unique col4) over(order by col1) maximum from max_date_time;
--TEST: order by 2 column names
select col2, col3, max(all col5) over(order by col2, col3 asc) maximum from max_date_time;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, max(col3) over(order by col1, col2 desc, col3, col4 asc) maximum from max_date_time;
--TEST: order by columns not selected
select col3, max(distinct col2) over(order by col4 desc, col2, col1 asc) maximum from max_date_time;
--TEST: order by 1 position
select col4, max(unique col1) over(order by 1) maximum from max_date_time;
--TEST: order by 3 positions
select col3, col2, max(col5) over(order by 1, 2 desc, 3 asc) maximum from max_date_time;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, max(unique col5) over(order by 3, 2 asc, 1 desc, 4) maximum from max_date_time;
--TEST: order by positions not existed
select col2, max(distinct col5) over(order by 2) maximum from max_date_time;
select col1, max(all col5) over(order by 3, 4, 1 desc) maximum, col2, col4 from max_date_time;
select col3, col4, max(col5) over(order by 5) maximum from max_date_time;
select col3, col1, max(col5) over(order by 100) maximum from max_date_time;
--TEST: order by column names and positions
select col1, col2, col3, col4, max(col5) over(order by 1, col2 desc, 3, col4 asc) maximum from max_date_time;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by date
select col1, col2, col3, max(distinct col5) over(partition by col1 order by 1, 2, 3) from max_date_time;
--TEST: partition by time
select col2, col4, col1, max(col4) over(partition by col2 order by col2, col4, col1 desc) from max_date_time;
--TEST: partition by timestamp
select col3, max(all col2) over(partition by col3 order by 1, 2, 3) maximum, col2 from max_date_time;
--TEST: partition by datetime
select col4, col1, max(unique col1) over(partition by col4 order by 1, 2 desc) maximum from max_date_time;
--TEST: syntax error
select col1, col2, max(unique col3) over(order by col1, col2 partition by col2) from max_date_time;



drop table max_date_time; 















