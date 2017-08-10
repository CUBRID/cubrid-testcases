--TEST: test with date/time data types and normal syntax

set timezone '+9:00';
create table wb_date_time(
	col1 date,
	col2 time, 
	col3 timestampltz,
	col4 datetimeltz,
	col5 smallint
);


insert into wb_date_time values('2000-12-12', '11:11:11', '1990-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 1);
insert into wb_date_time values('2000-12-12', '12:12:12', '1991-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 2);
insert into wb_date_time values('2000-12-12', '11:11:11', '1992-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 3);
insert into wb_date_time values('2000-12-12', '12:12:12', '1993-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 1);
insert into wb_date_time values('2000-12-12', '11:11:11', '1994-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 4);
insert into wb_date_time values(date'1999-11-11', '12:12:12', '1995-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 5);
insert into wb_date_time values(date'1999-11-11', '11:11:11', '1996-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 6);
insert into wb_date_time values(date'1999-11-11', '11:11:11', '1997-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 4);
insert into wb_date_time values(date'1999-11-11', '13:13:13', '1998-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 7);
insert into wb_date_time values('10/10/2001', '11:11:11', '1999-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 8);
insert into wb_date_time values('10/10/2001', '11:11:11', '2000-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 9);
insert into wb_date_time values('10/10/2001', '13:13:13', '2001-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 4);
insert into wb_date_time values('2011-11-23', '11:11:11', '2002-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 2);
insert into wb_date_time values(date'1888-09-09', '11:11:11', '2003-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 3);
insert into wb_date_time values(date'1888-09-09', '12:12:12', '2004-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 9);
insert into wb_date_time values(date'1888-09-09', '11:11:11', '2005-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 8);
insert into wb_date_time values(date'1888-09-09', '11:11:11', '2006-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 9);
insert into wb_date_time values(date'1888-09-09', '13:13:13', '2007-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 1);
insert into wb_date_time values(date'1888-09-09', '11:11:11', '2008-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 2);
insert into wb_date_time values(date'1888-09-09', '11:11:11', '2009-1-1 11:11:11', datetimeltz'2011-11-11 11:11:11.111', 5);


--TEST: date 
select col1, col2, width_bucket(col1, '1888-09-09', '2011-11-23', 5) from wb_date_time order by 1, 2;
select col1, col2, width_bucket(col1, '1888-09-09', '2011-11-24', 5) from wb_date_time order by 1, 2;
--TEST: time
select col2, col3, width_bucket(col2, '11:11:11', '13:13:13', 3) wb from wb_date_time order by 1, 2;
select col2, col3, width_bucket(col2, '11:11:11', '13:13:14', 3) wb from wb_date_time order by 1, 2;
--TEST: timestampltz
select col3, col4, width_bucket(col3, '1990-1-1 11:11:11', '2009-1-1 11:11:11', 20) wb from wb_date_time where col1 > '2000-12-12' order by col3, col4;
select col3, col4, width_bucket(col3, '1990-1-1 11:11:11', '2009-1-1 11:11:12', 20) wb from wb_date_time where col1 > '2000-12-12' order by col3, col4;
--TEST: datetimeltz
select col4, col1, width_bucket(col4, '2011-11-11 11:11:11.111', '2011-11-11 11:11:11.112', 1) wb from wb_date_time order by 1, 2;
select col4, col1, width_bucket(col4, '2011-11-11 11:11:11.111', '2011-11-11 11:11:11.112', 2) wb from wb_date_time order by 1, 2;


--TEST: pass column name into max/min param
select col1, col2, width_bucket(col1, col1-3600*24, '2011-11-23', 5) from wb_date_time order by 1, 2;
select col2, col3, width_bucket(col2, '11:11:11', col2+3600*12, 3) wb from wb_date_time order by 1, 2;
select col2, col3, width_bucket(col3, col3-3600*24*10, col3+3600*24*20, 20) wb from wb_date_time order by 1, 2;
--TEST: pass column name into count param
select col4, col5, width_bucket(col4, '2011-11-11 11:11:11.111', '2011-11-11 11:11:11.112', col5) wb from wb_date_time order by 1, 2;


drop table wb_date_time; 
set timezone 'Asia/Seoul';














