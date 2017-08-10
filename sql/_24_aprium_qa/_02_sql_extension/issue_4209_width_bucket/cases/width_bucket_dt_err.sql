--TEST: error and special cases with date/time types


create table wb_date_time(
	col1 date,
	col2 time, 
	col3 timestamp,
	col4 datetime,
	col5 smallint
);


insert into wb_date_time values('2000-12-12', '11:11:11', '1990-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 1);
insert into wb_date_time values('2000-12-12', '12:12:12', '1991-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 2);
insert into wb_date_time values('2000-12-12', '11:11:11', '1992-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 3);
insert into wb_date_time values('2000-12-12', '12:12:12', '1993-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 1);
insert into wb_date_time values('2000-12-12', '11:11:11', '1994-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 4);
insert into wb_date_time values(date'1999-11-11', '12:12:12', '1995-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 5);
insert into wb_date_time values(date'1999-11-11', '11:11:11', '1996-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 6);
insert into wb_date_time values(date'1999-11-11', '11:11:11', '1997-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 4);
insert into wb_date_time values(date'1999-11-11', '13:13:13', '1998-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 7);
insert into wb_date_time values('10/10/2001', '11:11:11', '1999-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 8);
insert into wb_date_time values('10/10/2001', '11:11:11', '2000-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 9);
insert into wb_date_time values('10/10/2001', '13:13:13', '2001-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 4);
insert into wb_date_time values('2011-11-23', '11:11:11', '2002-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 2);
insert into wb_date_time values(date'1888-09-09', '11:11:11', '2003-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 3);
insert into wb_date_time values(date'1888-09-09', '12:12:12', '2004-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 9);
insert into wb_date_time values(date'1888-09-09', '11:11:11', '2005-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 8);
insert into wb_date_time values(date'1888-09-09', '11:11:11', '2006-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 9);
insert into wb_date_time values(date'1888-09-09', '13:13:13', '2007-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 1);
insert into wb_date_time values(date'1888-09-09', '11:11:11', '2008-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 2);
insert into wb_date_time values(date'1888-09-09', '11:11:11', '2009-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 5);


--TEST: exp[all] < min 
select col1, col2, width_bucket(col1, '2012-12-29', '2013-11-23', 5) from wb_date_time order by 1, 2;
--TEST: exp[all] > max
select col2, col3, width_bucket(col2, '10:10:10', '10:13:13', 3) wb from wb_date_time order by 1, 2;

--TEST: [er] exp:date  min/max:time
select col1, col3, width_bucket(col1, '11:11:11', '13:13:13', 3) wb from wb_date_time order by 1, 2;
--TEST: exp:date min/max:timestamp
select col1, col4, width_bucket(col1, '1990-1-1 11:11:11', '2009-1-1 11:11:11', 20) wb from wb_date_time order by 1, 2;
--TEST: exp:datetime, min/max:date
select col4, col2, width_bucket(col4, '1888-09-09', '2011-11-24', 5) from wb_date_time order by 1, 2;

--TEST: constant as exp
select col4, col1, width_bucket('2011-11-11 11:11:11.111', '2011-11-11 11:11:11.001', '2011-11-11 11:11:11.112', 10) wb from wb_date_time order by 1, 2;

--TEST: [er] min = max
select col2, col3, width_bucket(col2, '11:11:11', '11:11:11', 3) wb from wb_date_time order by 1, 2;
--TEST: [er] min > max
select col3, col4, width_bucket(col3, '2010-1-1 11:11:11', '2000-1-1 11:11:11', 20) wb from wb_date_time where col1 > '2000-12-12' order by col3, col4;
--TEST: [er] count <= 0
select col4, col1, width_bucket(col4, '2011-11-11 11:11:11.111', '2011-11-11 11:11:11.112', -1) wb from wb_date_time order by 1, 2;

--TEST: zero date/time as min
select col1, col2, width_bucket(col1, '0000-00-00', '2011-11-24', 5) from wb_date_time order by 1, 2;
select col2, col3, width_bucket(col2, '0:0:0', '13:13:13', 3) wb from wb_date_time order by 1, 2;
select col3, col4, width_bucket(col3, '0000-00-00 00:00:00', '2009-1-1 11:11:11', 20) wb from wb_date_time order by 1, 2;

--TEST: marginal values of min and max
select col1, col2, width_bucket(col1, '0001-01-01', '9999-12-31', 100) from wb_date_time order by 1, 2;
select col2, col3, width_bucket(col2, '00:00:00', '23:59:59', 60) wb from wb_date_time order by 1, 2;
select col3, col4, width_bucket(col3, '1970-1-1 0:0:1', '2038-1-19 3:14:7', 20) wb from wb_date_time order by 1, 2;
select col4, col1, width_bucket(col4, '0001-1-1 0:0:0.000', '9999-12-31 23:59:59.999', 500) wb from wb_date_time order by 1, 2;

--TEST: big/marginal values to count
select col3, col4, width_bucket(col3, '1990-1-1 11:11:11', '2009-1-1 11:11:11', 200000000000000) wb from wb_date_time order by 1, 2;

--TEST: [er] out-of-range values of min and max
select col1, col2, width_bucket(col1, '0001-01-01', '10000-12-31', 100) from wb_date_time order by 1, 2;
select col3, col4, width_bucket(col3, '1958-1-1 0:0:1', '2039-1-19 3:14:7', 20) wb from wb_date_time order by 1, 2;

--TEST: [er] invalid date/time valeus
select col2, col3, width_bucket(col2, '11:11:11', '25:13:13', 3) wb from wb_date_time order by 1, 2;
select col3, col4, width_bucket(col3, '1990-13-1 11:11:11', '2009-1-1 11:11:11', 20) wb from wb_date_time where col1 > '2000-12-12' order by col3, col4;

--TEST: null values
select col1, col2, width_bucket(null, '1888-09-09', '2011-11-24', 5) from wb_date_time order by 1, 2;
select col2, col3, width_bucket(col2, null, '13:13:14', 3) wb from wb_date_time order by 1, 2;
select col3, col4, width_bucket(col3, '1990-1-1 11:11:11', null, 20) wb from wb_date_time where col1 > '2000-12-12' order by col3, col4;
select col4, col1, width_bucket(col4, '2011-11-11 11:11:11.111', '2011-11-11 11:11:11.112', null) wb from wb_date_time order by 1, 2;



drop table wb_date_time; 















