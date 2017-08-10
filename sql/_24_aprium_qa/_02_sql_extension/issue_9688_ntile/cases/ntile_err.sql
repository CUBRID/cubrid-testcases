--TEST: error and special cases 


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



--TEST: [er] pass invalid data type
select col1, col2, col3, col4, ntile(col1) over(order by col1) b_num from ntile_dt order by 1;
select col1, col2, col3, col4, ntile(col2) over(order by 1) b_num from ntile_dt order by 1;
select col1, ntile('aaa') over(order by 1) b_num from ntile_dt order by 1;
select col1, ntile(B'1010') over(order by 1) b_num from ntile_dt order by 1;

--TEST: pass float number
select col1, ntile(3.33333) over(order by col1) b_num from ntile_dt order by 1;
--TEST: number of string format
select col3, ntile('10') over(order by col3 desc) b_num from ntile_dt;

--TEST: [er] expr=0
select col1, ntile(0) over(order by col1, col2, col3) from ntile_dt;
--TEST: [er] expr<0
select col4, ntile(-100) over(order by col4 desc) from ntile_dt;
--TEST: 0 < expr < 1
select col3, ntile(0.5) over(order by col3) from ntile_dt order by 1;

--TEST: large numeric value to expr
select col2, ntile(99999999999999999999) over(order by col2) from ntile_dt order by 1, 2;

--TEST: marginal numeric values to expr
select col1, ntile(32767) over(order by col1) from ntile_dt order by 1, 2;
select col1, ntile(2147483647) over(order by col1) from ntile_dt order by 1, 2;
select col1, ntile(9223372036854775807) over(order by col1) from ntile_dt order by 1, 2;
select col1, ntile(1.7976931348623157E+308) over(order by col1) from ntile_dt order by 1, 2;

--TEST: out-of-range value
select col1, ntile(1.7976931348623157E+309) over(order by col1) from ntile_dt order by 1, 2;
select col1, ntile(2147483649) over(order by col1) from ntile_dt order by 1, 2;

--TEST: null value
select col1, ntile(null) over(order by col1) from ntile_dt order by 1, 2;


drop table ntile_dt; 















