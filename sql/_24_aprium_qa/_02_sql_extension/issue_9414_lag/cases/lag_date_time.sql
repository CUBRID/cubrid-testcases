--TEST: test with date/time data types and normal syntax
--syntax: LEAD(expr, offset, default)


create table lag_dt(
	col1 date,
	col2 time, 
	col3 timestamp,
	col4 datetime
);


insert into lag_dt values('2000-12-12', '11:11:11', '1990-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values('2000-12-12', '12:12:12', '1991-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values('2000-12-12', '11:11:11', '1992-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values('2000-12-12', '12:12:12', '1993-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values('2000-12-12', '11:11:11', '1994-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values(date'1999-11-11', '12:12:12', '1995-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values(date'1999-11-11', '11:11:11', '1996-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values(date'1999-11-11', '11:11:11', '1997-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values(date'1999-11-11', '13:13:13', '1998-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values('10/10/2001', '11:11:11', '1999-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values('10/10/2001', '11:11:11', '2000-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values('10/10/2001', '13:13:13', '2001-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values('2011-11-23', '11:11:11', '2002-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values(date'1888-09-09', '11:11:11', '2003-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values(date'1888-09-09', '12:12:12', '2004-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values(date'1888-09-09', '11:11:11', '2005-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values(date'1888-09-09', '11:11:11', '2006-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values(date'1888-09-09', '13:13:13', '2007-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values(date'1888-09-09', '11:11:11', '2008-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into lag_dt values(date'1888-09-09', '11:11:11', '2009-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');


--TEST: OVER() clause
select new.col1, new.col2, lag(new.col1) over() next_v from (select * from lag_dt order by 1, 2,3,4) new;
--TEST: with where clause
select col3, col4, lag(col2, 3, null) over() next_v from lag_dt where col1 > '2000-12-12' order by 1;
--TEST: syntax error
select col1, col3, col4, lag(1) over next_v from lag_dt;
select col1, col3, col2, lag(20) over(1) next_v from lag_dt;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by date
select new.col1, new.col2, new.col3, new.col4, lag(new.col2) over(partition by new.col1) next_v from (select * from lag_dt order by 1, 2,3,4) new;
select new.col1, new.col2, new.col3, new.col4, lag(new.col3, 2) over(partition by 1) next_v from (select * from lag_dt order by 1, 2,3,4) new;
--TEST: partition by time
select col1, col2, col3, col4, lag(col2, 3, '1999-01-01') over(partition by col2) next_v from lag_dt order by 1;
select new.col1, new.col2, new.col3, new.col4, lag(new.col3, 4) over(partition by 2) next_v from (select * from lag_dt order by 1, 2,3,4) new;
--TEST: partition by timestamp
select col1, col2, col3, col4, lag(col4, 5, date'2012-12-21') over(partition by col3) next_v from lag_dt order by 1;
--TEST: partition by datetime
select new.col1, new.col2, new.col3, new.col4, lag(new.col1, 6) over(partition by new.col4) next_v from (select * from lag_dt order by 1, 2,3,4) new;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, lag(col1, 1, null) over(order by col1) next_v from lag_dt order by 1, 2;
--TEST: order by 2 column names
select col2, col3, lag(col2, 10, '0001-01-01') over(order by col2, col3 asc) next_v from lag_dt order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, lag(col1, 2, '1212-12-12') over(order by col1, col2 desc, col3, col4 asc) next_v from lag_dt order by 1, 2, 3, 4, 5;
--TEST: order by columns not selected
select new.col3, lag(new.col4, 3, null) over(order by new.col4 desc, new.col2, new.col1 asc) next_v from (select * from lag_dt order by 1, 2,3,4) new;
--TEST: order by 1 position
select col4, lag(col4, 100, 'aaa') over(order by 1) next_v from lag_dt order by 1, 2;
--TEST: order by 3 positions
select col3, col2, lag(col1, 10) over(order by 1, 2 desc, 3 asc) next_v from lag_dt;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, lag(col3) over(order by 3, 2 asc, 1 desc, 4) next_v from lag_dt;
--TEST: order by positions not existed
select col2, lag(col4) over(order by 2) next_v from lag_dt;
select col1, lag(new.col3) over(order by 3, 4, 1 desc) next_v, new.col2, new.col4 from (select * from lag_dt order by 1, 2,3,4) new;
select col3, col4, lag(col2, 1, null) over(order by 5) next_v from lag_dt;
select col3, col1, lag(col1, 22, null) over(order by 100) next_v from lag_dt;
--TEST: order by column names and positions
select col1, col2, col3, col4, lag(col4, 20, '9999-12-31 23:59:59') over(order by 1, col2 desc, 3, col4 asc) next_v from lag_dt;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by date
select col1, col2, col3, lag(col1) over(partition by col1 order by col1, col2, col3) from lag_dt;
--TEST: partition by time
select col2, col4, col1, lag(col2, 2, '12:12:12') over(partition by col2 order by col2, col4, col1 desc) from lag_dt;
--TEST: partition by timestamp
select col3, lag(col3, 5) over(partition by col3 order by col3) next_v, col2 from lag_dt;
--TEST: partition by datetime
select col4, col1, lag(col4, 100, 4) over(partition by col4 order by 1, 2 desc) next_v from lag_dt;



drop table lag_dt; 















