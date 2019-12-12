--TEST: test with date/time data types and normal syntax


create table ntile_dt(
	col1 date,
	col2 time, 
	col3 timestamp,
	col4 datetime
);


insert into ntile_dt values('2000-12-12', '11:11:11', '1990-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values('2000-12-12', '12:12:12', '1991-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values('2000-12-12', '11:11:11', '1992-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values('2000-12-12', '12:12:12', '1993-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values('2000-12-12', '11:11:11', '1994-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values(date'1999-11-11', '12:12:12', '1995-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values(date'1999-11-11', '11:11:11', '1996-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values(date'1999-11-11', '11:11:11', '1997-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values(date'1999-11-11', '13:13:13', '1998-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values('10/10/2001', '11:11:11', '1999-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values('10/10/2001', '11:11:11', '2000-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values('10/10/2001', '13:13:13', '2001-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values('2011-11-23', '11:11:11', '2002-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values(date'1888-09-09', '11:11:11', '2003-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values(date'1888-09-09', '12:12:12', '2004-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values(date'1888-09-09', '11:11:11', '2005-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values(date'1888-09-09', '11:11:11', '2006-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values(date'1888-09-09', '13:13:13', '2007-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values(date'1888-09-09', '11:11:11', '2008-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into ntile_dt values(date'1888-09-09', '11:11:11', '2009-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');

rename table ntile_dt as ntile_dt_ori;
create view ntile_dt as select * from ntile_dt_ori order by 1,2,3,4;

--TEST: OVER() clause
select new.col1, new.col2, ntile(5) over() b_num from (select * from ntile_dt order by 1,2,3,4) new order by 1, 2,3;
--TEST: with where clause
select col3, col4, ntile(10) over() b_num from (select * from ntile_dt order by 1,2,3,4) where col1 > '2000-12-12' order by 1;
--TEST: syntax error
select col1, col3, col4, ntile(1) over b_num from ntile_dt;
select col1, col3, col2, ntile(20) over(1) b_num from ntile_dt;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by date
select col1, col2, col3, col4, ntile(3) over(partition by col1) b_num from (select * from ntile_dt order by 1,2,3,4);
select col1, col2, col3, col4, ntile(2) over(partition by 1) b_num from (select * from ntile_dt order by 1,2,3,4);
--TEST: partition by time
select new.col1, new.col2, new.col3, new.col4, ntile(5) over(partition by new.col2) b_num from (select * from ntile_dt order by 1,2,3,4) new order by 1;
select new.col1, new.col2, new.col3, new.col4, ntile(6) over(partition by 2) b_num from (select * from ntile_dt order by 1,2,3,4) new order by 1;
--TEST: partition by timestamp
select col1, col2, col3, col4, ntile(3) over(partition by col3) b_num from ntile_dt order by 1;
--TEST: partition by datetime
select new.col1, new.col2, new.col3, new.col4, ntile(4) over(partition by new.col4) b_num from (select * from ntile_dt order by 1,2,3,4) new order by 1;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, ntile(7) over(order by col1) b_num from ntile_dt order by 1, 2;
--TEST: order by 2 column names
select col2, col3, ntile(10) over(order by col2, col3 asc) b_num from ntile_dt order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, ntile(20) over(order by col1, col2 desc, col3, col4 asc) b_num from ntile_dt order by 1, 2, 3, 4, 5;
--TEST: order by columns not selected
select col3, ntile(19) over(order by col4 desc, col3, col2, col1 asc) b_num from ntile_dt order by 1,2;
--TEST: order by 1 position
select col4, ntile(3) over(order by 1) b_num from ntile_dt order by 1, 2;
--TEST: order by 3 positions
select col3, col2, ntile(5) over(order by 1, 2 desc, 3 asc) b_num from ntile_dt;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, ntile(13) over(order by 3, 2 asc, 1 desc, 4) b_num from ntile_dt;
--TEST: order by positions not existed
select col2, ntile(30) over(order by 2) b_num from ntile_dt;
select col1, ntile(100) over(order by 3, 4, 1 desc) b_num, col2, col4 from ntile_dt order by 1,2;
select col3, col4, ntile(1) over(order by 5) b_num from ntile_dt;
select col3, col1, ntile(5) over(order by 100) b_num from ntile_dt;
--TEST: order by column names and positions
select col1, col2, col3, col4, ntile(16) over(order by 1, col2 desc, 3, col4 asc) b_num from ntile_dt;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by date
select col1, col2, col3, ntile(1) over(partition by col1 order by col1, col2, col3) from ntile_dt;
--TEST: partition by time
select col2, col4, col1, ntile(3) over(partition by col2 order by col2, col4, col1 desc) from ntile_dt order by 3,4;
--TEST: partition by timestamp
select col3, ntile(5) over(partition by col3 order by col3) b_num, col2 from ntile_dt;
--TEST: partition by datetime
select col4, col1, ntile(21) over(partition by col4 order by 1, 2 desc) b_num from ntile_dt order by 2,3;
--TEST: syntax error
select col1, col2, ntile(9) over(order by col1, col2 partition by col2) from ntile_dt;



drop view ntile_dt; 
drop table ntile_dt_ori;















