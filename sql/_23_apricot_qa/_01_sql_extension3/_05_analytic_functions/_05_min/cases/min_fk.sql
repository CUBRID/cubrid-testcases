--TEST: test with columns with a foreign key


create table min_pk(
	col1 date not null,
	col2 time default '10:10:10', 
	col3 timestamp default SYS_TIMESTAMP primary key,
	col4 datetime,
	col5 float
);

--create a table with a column referncing a column in another table
create table min_fk(
	col1 bigint default 2000000,
	col2 char(20) not null,
	col3 timestamp,
	constraint pk_col3 primary key(col3),
	constraint fk_col3 foreign key(col3) references min_pk(col3)
	on delete cascade on update restrict
);
	


--insert into the table with pk
insert into min_pk values('2000-12-12', '11:11:11', '1990-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 111.111);
insert into min_pk values('2000-12-12', '12:12:12', '1991-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 222.222);
insert into min_pk values('2000-12-12', '11:11:11', '1992-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 333.333);
insert into min_pk values('2000-12-12', '12:12:12', '1993-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 444.444);
insert into min_pk values('2000-12-12', '11:11:11', '1994-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 555.555);
insert into min_pk values(date'1999-11-11', '12:12:12', '1995-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 111.111);
insert into min_pk values(date'1999-11-11', '11:11:11', '1996-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 666.666);
insert into min_pk values(date'1999-11-11', '11:11:11', '1997-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 777.777);
insert into min_pk values(date'1999-11-11', '13:13:13', '1998-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 888.888);
insert into min_pk values('10/10/2001', '11:11:11', '1999-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 999.999);
insert into min_pk values('10/10/2001', '11:11:11', '2000-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 222.222);
insert into min_pk values('10/10/2001', '13:13:13', '2001-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 333.333);
insert into min_pk values('2011-11-23', '11:11:11', '2002-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 444.444);
insert into min_pk values(date'1888-09-09', '11:11:11', '2003-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 555.555);
insert into min_pk values(date'1888-09-09', '12:12:12', '2004-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 333.333);
insert into min_pk values(date'1888-09-09', '11:11:11', '2005-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 666.666);
insert into min_pk values(date'1888-09-09', '11:11:11', '2006-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 777.777);
insert into min_pk values(date'1888-09-09', '13:13:13', '2007-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 888.888);
insert into min_pk values(date'1888-09-09', '11:11:11', '2008-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 999.999);
insert into min_pk values(date'1888-09-09', '11:11:11', '2009-1-1 11:11:11', datetime'2011-11-11 11:11:11.111', 555.555);


--insert into the table with fk
insert into min_fk values(100000, 'fk1', '2009-1-1 11:11:11');
insert into min_fk values(100000, 'fk2', '2007-1-1 11:11:11');
insert into min_fk values(null, 'fk3', '2005-1-1 11:11:11');
insert into min_fk values(100000, 'fk4', '2003-1-1 11:11:11');
insert into min_fk values(null, 'fk1', '2001-1-1 11:11:11');
insert into min_fk values(300000, 'fk2', '2000-1-1 11:11:11');
insert into min_fk values(100000, 'fk3', '1999-1-1 11:11:11');
insert into min_fk values(null, 'fk4', '1997-1-1 11:11:11');
insert into min_fk values(100000, 'fk1', '1995-1-1 11:11:11');
insert into min_fk values(300000, 'fk5', '1993-1-1 11:11:11');
insert into min_fk values(200000, 'fk4', '1991-1-1 11:11:11');


--TEST: OVER() clause, table with pk
--TEST: date 
select col1, col2, min(col5) over() from min_pk order by 1, 2;
--TEST: time, with alias+all
select col2, col3, min(all col4) over() minimum from min_pk order by 1, 2;
--TEST: timestamp, with where clause
select col3, col4, min(col3) over() minimum from min_pk where col1 > '2000-12-12' order by col3, col4;
--TEST: datetime, distinct
select col4, col1, min(distinct col2) over() minimum from min_pk order by 1, 2;
--TEST: syntax error
select minimum from (select *, min(col5) over() minimum from min_pk);
select col1, col3, col4, min(col5) over minimum from min_pk;
select col1, col3, col2, min(col5) over(1) minimum from min_pk;

--TEST: OVER() clause, table with fk
--TEST: int 
select col1, col2, min(col1) over() from min_fk order by 1, 2;
--TEST: char(n), with alias+all
select col2, col3, min(all col2) over() minimum from min_fk order by 1, 2;
--TEST: timestamp, with where clause
select col3, col1, min(unique col3) over() minimum from min_fk where col1 > 200000 order by col3, col1;
--TEST: syntax error
select minimum from (select *, min(col1) over() minimum from min_fk);
select col1, col3, min(col1) over minimum from min_fk;
select col1, col3, col2, min(col1) over(1) minimum from min_fk;



--TEST: OVER(PARTITION BY) clause, table with pk
--TEST: partition by date
select col1, col2, col3, col4, min(unique col5) over(partition by col1) minimum from min_pk order by 1, 2, 3, 4;
--TEST: partition by time
select col1, col2, col3, col4, min(distinctrow col4) over(partition by col2) minimum from min_pk order by 2, 1, 3, 4;
--TEST: partition by timestamp
select col1, col2, col3, col4, min(col2) over(partition by col3) minimum from min_pk order by 3, 1, 2, 4;
--TEST: partition by datetime
select col1, col2, col3, col4, min(all col1) over(partition by col4) minimum from min_pk order by 4, 1, 2, 3, 5;

--TEST: OVER(PARTITION BY) clause, table with fk
--TEST: partition by int
select col1, col2, col3, min(col1) over(partition by col1) minimum from min_fk order by 1, 2, 3, 4;
--TEST: partition by char(n)
select col1, col2, col3, min(distinctrow col3) over(partition by col2) minimum from min_fk order by 2, 1, 3, 4;
--TEST: partition by timestamp
select col1, col2, col3, min(unique col2) over(partition by col3) minimum from min_fk order by 3, 1, 2, 4;




--TEST: OVER(ORDER BY) clause, table with pk
--TEST: order by 1 column name
select col1, min(col5) over(order by col1) minimum from min_pk order by 1, 2;
--TEST: order by 2 column names
select col2, col3, min(all col4) over(order by col2, col3 asc) minimum from min_pk order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, min(unique col3) over(order by col1, col2 desc, col3, col4 asc) minimum from min_pk order by 1, 2, 3, 4, 5;
--TEST: order by columns not selected
select col3, min(distinct col2) over(order by col4 desc, col2, col1 asc) minimum from min_pk order by 1, 2;
--TEST: order by 1 position
select col4, min(all col1) over(order by 1) minimum from min_pk order by 1, 2;
--TEST: order by 3 positions
select col3, col2, min(distinctrow col5) over(order by 1, 2 desc, 3 asc) minimum from min_pk order by 1, 2, 3;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, min(col5) over(order by 3, 2 asc, 1 desc, 4) minimum from min_pk order by 1, 2, 3, 4, 5;
--TEST: order by positions not existed
select col2, min(distinct col5) over(order by 2) minimum from min_pk order by 1, 2;
select col1, min(all col4) over(order by 3, 4, 1 desc) minimum, col2, col4 from min_pk order by 1, 2;
select col3, col4, min(col3) over(order by 5) minimum from min_pk order by 1, 2;
select col3, col1, min(col2) over(order by 100) minimum from min_pk order by 1, 2;
--TEST: order by column names and positions
select col1, col2, col3, col4, min(col5) over(order by 1, col2 desc, 3, col4 asc) minimum from min_pk order by 1, 2, 3, 4, 5;

--TEST: OVER(ORDER BY) clause, table with fk
--TEST: order by 1 column name
select col1, min(col1) over(order by col1) minimum from min_fk order by 1, 2;
--TEST: order by 2 column names
select col2, col3, min(all col3) over(order by col2, col3 asc) minimum from min_fk order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, min(unique col2) over(order by col1, col2 desc, col3 asc) minimum from min_fk order by 1, 2, 3, 4;
--TEST: order by columns not selected
select col3, min(distinctrow col1) over(order by col2, col1 asc) minimum from min_fk order by 1, 2;
--TEST: order by 1 position
select col3, min(all col2) over(order by 1) minimum from min_fk order by 1, 2;
--TEST: order by 3 positions
select col3, col2, min(col3) over(order by 1, 2 desc, 3 asc) minimum from min_fk order by 1, 2, 3;
--TEST: order by positions not existed
select col2, min(distinct col1) over(order by 2) minimum from min_fk order by 1, 2;
select col1, min(all col3) over(order by 3, 4, 1 desc) minimum, col2, col3 from min_fk order by 1, 2;
select col3, col1, min(col2) over(order by 100) minimum from min_fk order by 1, 2;
--TEST: order by column names and positions
select col1, col2, col3, min(col1) over(order by 1, col2 desc, 3) minimum from min_fk order by 1, 2, 3, 4;





--TEST: OVER(PARTITION BY ORDER BY) clause, table with pk
--TEST: partition by date
select col1, col2, col3, min(distinct col5) over(partition by col1 order by 1, 2, 3) from min_pk order by 1, 2, 3, 4;
--TEST: partition by time
select col2, col4, col1, min(col4) over(partition by col2 order by col2, col4, col1 desc) from min_pk order by 1, 2, 3, 4;
--TEST: partition by timestamp
select col3, min(all col3) over(partition by col3 order by 1, 2, 3) minimum, col2 from min_pk order by 1, 2;
--TEST: partition by datetime
select col4, col1, min(col2) over(partition by col4 order by 1, 2 desc) minimum from min_pk order by 1, 2, 3;
--TEST: syntax error
select col1, col2, min(distinctrow col1) over(order by col1, col2 partition by col2) from min_pk order by 1, 2;

--TEST: OVER(PARTITION BY ORDER BY) clause, table with fk
--TEST: partition by int
select col1, col2, col3, min(distinct col1) over(partition by col1 order by 1, 2, 3) from min_fk order by 1, 2, 3, 4;
--TEST: partition by char(n)
select col2, col3, col1, min(col2) over(partition by col2 order by col2, col3, col1 desc) from min_fk order by 1, 2, 3, 4;
--TEST: partition by timestamp
select col3, min(all col3) over(partition by col3 order by 1, 2, 3) minimum, col2 from min_fk order by 1, 2;
--TEST: syntax error
select col1, col2, min(unique col3) over(order by col1, col2 partition by col2) from min_fk order by 1, 2;




drop table min_fk; 
drop table min_pk; 















