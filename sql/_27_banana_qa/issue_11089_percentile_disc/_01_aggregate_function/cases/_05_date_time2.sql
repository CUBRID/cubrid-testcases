--TEST: pass date/time type values to the second param

drop table if exists p_disc;
create table p_disc(
	col1 date,
	col2 time, 
	col3 timestamp,
	col4 datetime
);


insert into p_disc values('2000-12-12', '11:11:11', '1990-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values('2000-12-12', '12:12:12', '1991-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values('2000-12-12', '11:11:11', '1992-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values('2000-12-12', '12:12:12', '1993-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values('2000-12-12', '11:11:11', '1994-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values(date'1999-11-11', '12:12:12', '1995-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values(date'1999-11-11', '11:11:11', '1996-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values(date'1999-11-11', '11:11:11', '1997-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values(date'1999-11-11', '13:13:13', '1998-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values('10/10/2001', '11:11:11', '1999-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values('10/10/2001', '11:11:11', '2000-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values('10/10/2001', '13:13:13', '2001-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values('2011-11-23', '11:11:11', '2002-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values(date'1888-09-09', '11:11:11', '2003-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values(date'1888-09-09', '12:12:12', '2004-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values(date'1888-09-09', '11:11:11', '2005-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values(date'1888-09-09', '11:11:11', '2006-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values(date'1888-09-09', '13:13:13', '2007-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values(date'1888-09-09', '11:11:11', '2008-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into p_disc values(date'1888-09-09', '11:11:11', '2009-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');


--test: pass constant date/time values to the second param
select col1, percentile_disc(0.5) within group(order by time'23:12:30') p_disc from p_disc group by col1 order by 1, 2;
select col1, percentile_disc(0.7) within group(order by date'2013-12-24') p_disc from p_disc group by col1 order by 1, 2;
select col1, percentile_disc(0.3) within group(order by timestamp'2013-12-24 15:55:55') p_disc from p_disc group by col1 order by 1, 2;
select col1, percentile_disc(0.6) within group(order by datetime'2013-12-24 15:55:55.555') p_disc from p_disc group by col1 order by 1, 2;

--test: pass constant string values of date/time format to the second param
select col1, percentile_disc(0.5) within group(order by '23:12:30') p_disc from p_disc group by col1 order by 1, 2;
select col1, percentile_disc(0.7) within group(order by '2013-12-24') p_disc from p_disc group by col1 order by 1, 2;
select col1, percentile_disc(0.3) within group(order by '2013-12-24 15:55:55') p_disc from p_disc group by col1 order by 1, 2;
select col1, percentile_disc(0.6) within group(order by '2013-12-24 15:55:55.555') p_disc from p_disc group by col1 order by 1, 2;

--test: pass date/time type columns to the second param
select col1, percentile_disc(0.1) within group(order by col1) p_disc from p_disc group by col1 order by 1, 2;
select col1, percentile_disc(0.8) within group(order by col2) p_disc from p_disc group by col1 order by 1, 2;
select col1, percentile_disc(0.6) within group(order by col3) p_disc from p_disc group by col1 order by 1, 2;
select col1, percentile_disc(0.9) within group(order by col4) p_disc from p_disc group by col1 order by 1, 2;

--test: [er] pass more than 1 columns to the second param
select col1, percentile_disc(0.8) within group(order by col2, col4) p_disc from p_disc group by col1 order by 1, 2;
select col1, percentile_disc(0.6) within group(order by col3, col2, col1) p_disc from p_disc group by col1 order by 1, 2;
select col1, col2, col3, percentile_disc(0.6) within group(order by 3, 2, 1) p_disc from p_disc group by col1, col2, col3 order by 1, 2;


drop table p_disc;
