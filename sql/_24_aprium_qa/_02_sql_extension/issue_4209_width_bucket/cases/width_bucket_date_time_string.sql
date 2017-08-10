--TEST: normal cases with string types of date/time format


create table wb_dts(
	col1 char(20),
	col2 varchar, 
	col3 varchar,
	col4 string,
	col5 char(5)
);


insert into wb_dts values('2000-12-12', '11:11:11', '1990-1-1 11:11:11', '2011-11-11 11:11:11.111', '1');
insert into wb_dts values('2000-12-12', '12:12:12', '1991-1-1 11:11:11', '2011-11-11 11:11:11.111', '2');
insert into wb_dts values('2000-12-12', '11:11:11', '1992-1-1 11:11:11', '2011-11-11 11:11:11.111', '3');
insert into wb_dts values('2000-12-12', '12:12:12', '1993-1-1 11:11:11', '2011-11-11 11:11:11.111', '1');
insert into wb_dts values('2000-12-12', '11:11:11', '1994-1-1 11:11:11', '2011-11-11 11:11:11.111', '4');
insert into wb_dts values('1999-11-11', '12:12:12', '1995-1-1 11:11:11', '2011-11-11 11:11:11.111', '5');
insert into wb_dts values('1999-11-11', '11:11:11', '1996-1-1 11:11:11', '2011-11-11 11:11:11.111', '6');
insert into wb_dts values('1999-11-11', '11:11:11', '1997-1-1 11:11:11', '2011-11-11 11:11:11.111', '4');
insert into wb_dts values('1999-11-11', '13:13:13', '1998-1-1 11:11:11', '2011-11-11 11:11:11.111', '7');
insert into wb_dts values('10/10/2001', '11:11:11', '1999-1-1 11:11:11', '2011-11-11 11:11:11.111', '8');
insert into wb_dts values('10/10/2001', '11:11:11', '2000-1-1 11:11:11', '2011-11-11 11:11:11.111', '9');
insert into wb_dts values('10/10/2001', '13:13:13', '2001-1-1 11:11:11', '2011-11-11 11:11:11.111', '4');
insert into wb_dts values('2011-11-23', '11:11:11', '2002-1-1 11:11:11', '2011-11-11 11:11:11.111', '2');
insert into wb_dts values('1888-09-09', '11:11:11', '2003-1-1 11:11:11', '2011-11-11 11:11:11.111', '3');
insert into wb_dts values('1888-09-09', '12:12:12', '2004-1-1 11:11:11', '2011-11-11 11:11:11.111', '9');
insert into wb_dts values('1888-09-09', '11:11:11', '2005-1-1 11:11:11', '2011-11-11 11:11:11.111', '8');
insert into wb_dts values('1888-09-09', '11:11:11', '2006-1-1 11:11:11', '2011-11-11 11:11:11.111', '9');
insert into wb_dts values('1888-09-09', '13:13:13', '2007-1-1 11:11:11', '2011-11-11 11:11:11.111', '1');
insert into wb_dts values('1888-09-09', '11:11:11', '2008-1-1 11:11:11', '2011-11-11 11:11:11.111', '2');
insert into wb_dts values('1888-09-09', '11:11:11', '2009-1-1 11:11:11', '2011-11-11 11:11:11.111', '5');


--TEST: date 
select col1, col2, width_bucket(col1, '1888-09-09', '2011-11-23', 5) from wb_dts order by 1, 2;
select col1, col2, width_bucket(col1, '1888-09-09', '2011-11-24', 5) from wb_dts order by 1, 2;
--TEST: time
select col2, col3, width_bucket(col2, '11:11:11', '13:13:13', 3) wb from wb_dts order by 1, 2;
select col2, col3, width_bucket(col2, '11:11:11', '13:13:14', 3) wb from wb_dts order by 1, 2;
--TEST: timestamp
select col3, col4, width_bucket(col3, '1990-1-1 11:11:11', '2009-1-1 11:11:11', 20) wb from wb_dts where col1 > '2000-12-12' order by col3, col4;
select col3, col4, width_bucket(col3, '1990-1-1 11:11:11', '2009-1-1 11:11:12', 20) wb from wb_dts where col1 > '2000-12-12' order by col3, col4;
--TEST: datetime
select col4, col1, width_bucket(col4, '2011-11-11 11:11:11.111', '2011-11-11 11:11:11.112', 1) wb from wb_dts order by 1, 2;
select col4, col1, width_bucket(col4, '2011-11-11 11:11:11.111', '2011-11-11 11:11:11.112', 2) wb from wb_dts order by 1, 2;


--TEST: pass column name into max/min param
select col1, col2, width_bucket(col1, col1-24, '2011-11-23', 5) from wb_dts order by 1, 2;
select col2, col3, width_bucket(col2, '11:11:11', col2+12, 3) wb from wb_dts order by 1, 2;
select col2, col3, width_bucket(col3, col3-3600*24*10, col2+3600*24*20, 20) wb from wb_dts order by 1, 2;
--TEST: pass column name into count param
select col4, col5, width_bucket(col4, '2011-11-11 11:11:11.111', '2011-11-11 11:11:11.112', col5) wb from wb_dts order by 1, 2;


drop table wb_dts; 















