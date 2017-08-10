--TEST: test with date/time data types and normal syntax

drop table if exists p_cont_date_time;
create table p_cont_date_time(
	col1 date,
	col2 time, 
	col3 timestamp,
	col4 datetime,
	col5 smallint
);


insert into p_cont_date_time values('2000-12-12', '11:11:11', '1990-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 111);
insert into p_cont_date_time values('2000-12-12', '12:12:12', '1991-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 222);
insert into p_cont_date_time values('2000-12-12', '11:11:11', '1992-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 333);
insert into p_cont_date_time values('2000-12-12', '12:12:12', '1993-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 111);
insert into p_cont_date_time values('2000-12-12', '11:11:11', '1994-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 444);
insert into p_cont_date_time values(date'1999-11-11', '12:12:12', '1995-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 555);
insert into p_cont_date_time values(date'1999-11-11', '11:11:11', '1996-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 666);
insert into p_cont_date_time values(date'1999-11-11', '11:11:11', '1997-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 444);
insert into p_cont_date_time values(date'1999-11-11', '13:13:13', '1998-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 777);
insert into p_cont_date_time values('10/10/2001', '11:11:11', '1999-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 888);
insert into p_cont_date_time values('10/10/2001', '11:11:11', '2000-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 999);
insert into p_cont_date_time values('10/10/2001', '13:13:13', '2001-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 444);
insert into p_cont_date_time values('2011-11-23', '11:11:11', '2002-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 222);
insert into p_cont_date_time values(date'1888-09-09', '11:11:11', '2003-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 333);
insert into p_cont_date_time values(date'1888-09-09', '12:12:12', '2004-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 909);
insert into p_cont_date_time values(date'1888-09-09', '11:11:11', '2005-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 888);
insert into p_cont_date_time values(date'1888-09-09', '11:11:11', '2006-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 999);
insert into p_cont_date_time values(date'1888-09-09', '13:13:13', '2007-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 101);
insert into p_cont_date_time values(date'1888-09-09', '11:11:11', '2008-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 222);
insert into p_cont_date_time values(date'1888-09-09', '11:11:11', '2009-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 555);


--TEST: OVER() clause
select col1, col2, percentile_cont(0.12) within group (order by col5 desc) over() p_cont from p_cont_date_time order by 1, 2;

--TEST: [er] time to the first param
select col2, col3, percentile_cont(col2) within group (order by col5) over() p_cont from p_cont_date_time order by 1, 2;
--TEST: [er] timestamp to the first param
select col3, col5, percentile_cont(col3) within group (order by col5) over() p_cont from p_cont_date_time where col1 > '2000-12-12' order by col3, col4;
--TEST: [er] datetime to the first param
select col4, col1, percentile_cont(col4) within group (order by col5) over() p_cont from p_cont_date_time order by 1, 2;
--TEST: date/time type of argument
select percentile_cont(0.1) within group (order by col1) over() p_cont from p_cont_date_time order by 1;
select percentile_cont(0.3) within group (order by col2) over() p_cont from p_cont_date_time order by 1;
select percentile_cont(0.5) within group (order by col3) over() p_cont from p_cont_date_time order by 1;
select percentile_cont(0.7) within group (order by col4) over() p_cont from p_cont_date_time order by 1;
select percentile_cont(0.7) within group (order by col5) over() p_cont from p_cont_date_time order by 1;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by date
select col1, col2, col3, col4, col5, percentile_cont(0) within group (order by col5) over(partition by col1) p_cont from p_cont_date_time order by 1, 2, 3, 4;
--TEST: partition by time
select col1, col2, col3, col4, col5, percentile_cont(0.2) within group (order by col1) over(partition by col2) p_cont from p_cont_date_time order by 2, 1, 3, 4;
--TEST: partition by timestamp
select col1, col2, col3, col4, percentile_cont(0.4) within group (order by col2) over(partition by col3) p_cont from p_cont_date_time order by 3, 1, 2, 4;
--TEST: partition by datetime
select col1, col2, col3, col4, percentile_cont(1) within group (order by col3 desc) over(partition by col4) p_cont from p_cont_date_time order by 4, 1, 2, 3, 5;
--TEST: partition by position
select col1, col3, percentile_cont(0.5) within group (order by col5 asc) over(partition by 1) p_cont from p_cont_date_time order by 1, 2, 3;
--TEST: partition by multiple columns
select col1, col2, col3, col4, col5, percentile_cont(0) within group (order by col5) over(partition by col1, col3, col4) p_cont from p_cont_date_time order by 1, 2, 3, 4;



--TEST: [er] OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, percentile_cont(0.33) within group (order by col5) over(order by col1) p_cont from p_cont_date_time order by 1, 2;
--TEST: order by 2 column names
select col2, col3, percentile_cont(0.4) within group (order by col3) over(order by col2, col3 asc) p_cont from p_cont_date_time order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, percentile_cont(0.56) within group (order by col1) over(order by col1, col2 desc, col3, col4 asc) p_cont from p_cont_date_time order by 1, 2, 3, 4, 5;
--TEST: order by 1 position
select col4, percentile_cont(0.8) within group (order by 2) over(order by 1) p_cont from p_cont_date_time order by 1, 2;



--TEST: [er] OVER(PARTITION BY ORDER BY) clause
--TEST: partition by date
select col1, col2, col3, percentile_cont(0.7) within group (order by col5) over(partition by col1 order by 1, 2, 3) p_cont from p_cont_date_time order by 1, 2, 3, 4;


drop table p_cont_date_time; 















