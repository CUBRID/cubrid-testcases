--TEST: test with columns with a foreign key 


create table dense_rank_pk(
	col1 date not null,
        col2 time default '10:10:10',
        col3 timestamp default SYS_TIMESTAMP primary key,
        col4 datetime
);

--create a table with a column referncing a column in another table
create table dense_rank_fk(
        col1 bigint default 2000000,
        col2 char(20) not null,
        col3 timestamp,
        constraint pk_col3 primary key(col3),
        constraint fk_col3 foreign key(col3) references dense_rank_pk(col3)
        on delete cascade on update restrict
);


insert into dense_rank_pk values('2000-12-12', '11:11:11', '1990-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values('2000-12-12', '12:12:12', '1991-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values('2000-12-12', '11:11:11', '1992-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values('2000-12-12', '12:12:12', '1993-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values('2000-12-12', '11:11:11', '1994-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values(date'1999-11-11', '12:12:12', '1995-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values(date'1999-11-11', '11:11:11', '1996-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values(date'1999-11-11', '11:11:11', '1997-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values(date'1999-11-11', '13:13:13', '1998-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values('10/10/2001', '11:11:11', '1999-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values('10/10/2001', '11:11:11', '2000-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values('10/10/2001', '13:13:13', '2001-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values('2011-11-23', '11:11:11', '2002-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values(date'1888-09-09', '11:11:11', '2003-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values(date'1888-09-09', '12:12:12', '2004-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values(date'1888-09-09', '11:11:11', '2005-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values(date'1888-09-09', '11:11:11', '2006-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values(date'1888-09-09', '13:13:13', '2007-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values(date'1888-09-09', '11:11:11', '2008-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');
insert into dense_rank_pk values(date'1888-09-09', '11:11:11', '2009-1-1 11:11:11', datetime'2011-11-11 11:11:11.111');


--insert into the table with fk
insert into dense_rank_fk values(100000, 'fk1', '2009-1-1 11:11:11');
insert into dense_rank_fk values(100000, 'fk2', '2007-1-1 11:11:11');
insert into dense_rank_fk values(null, 'fk3', '2005-1-1 11:11:11');
insert into dense_rank_fk values(100000, 'fk4', '2003-1-1 11:11:11');
insert into dense_rank_fk values(null, 'fk1', '2001-1-1 11:11:11');
insert into dense_rank_fk values(300000, 'fk2', '2000-1-1 11:11:11');
insert into dense_rank_fk values(100000, 'fk3', '1999-1-1 11:11:11');
insert into dense_rank_fk values(null, 'fk4', '1997-1-1 11:11:11');
insert into dense_rank_fk values(100000, 'fk1', '1995-1-1 11:11:11');
insert into dense_rank_fk values(300000, 'fk5', '1993-1-1 11:11:11');
insert into dense_rank_fk values(200000, 'fk4', '1991-1-1 11:11:11');


--TEST: OVER() clause, table with pk
--TEST: no alias 
select col1, col2, dense_rank() over() from dense_rank_pk order by 1, 2;
--TEST: with alias
select col2, col3, dense_rank() over() d_rank from dense_rank_pk order by 1, 2;
--TEST: with where clause
select col3, col4, dense_rank() over() d_rank from dense_rank_pk where col1 > '2000-12-12' order by col3;
--TEST:
select col4, col1, dense_rank() over() d_rank from dense_rank_pk order by 1, 2;
--TEST: syntax error
select d_rank from (select *, dense_rank() over() d_rank from dense_rank_pk) order by 1;
select col1, col3, col4, dense_rank() over d_rank from dense_rank_pk;
select col1, col3, col2, dense_rank() over(1) d_rank from dense_rank_pk;

--TEST: OVER() clause, table with fk
--TEST: no alias 
select col1, col2, dense_rank() over() from dense_rank_fk order by 1, 2;
--TEST: with alias
select col2, col3, dense_rank() over() d_rank from dense_rank_fk order by 1, 2;
--TEST: with where clause
select col3, col1, dense_rank() over() d_rank from dense_rank_fk where col1 > 30000 order by col3;
--TEST: syntax error
select d_rank from (select *, dense_rank() over() d_rank from dense_rank_fk) order by 1;
select col1, col3, dense_rank() over d_rank from dense_rank_fk;
select col1, col3, col2, dense_rank() over(1) d_rank from dense_rank_fk;




--TEST: OVER(PARTITION BY) clause, table with pk
--TEST: partition by date
select col1, col2, col3, col4, dense_rank() over(partition by col1) d_rank from dense_rank_pk order by 1, 2, 3, 4;
--TEST: partition by time
select col1, col2, col3, col4, dense_rank() over(partition by col2) d_rank from dense_rank_pk order by 2, 1, 3, 4;
--TEST: partition by timestamp
select col1, col2, col3, col4, dense_rank() over(partition by col3) d_rank from dense_rank_pk order by 3, 1, 2, 4;
--TEST: partition by datetime
select col1, col2, col3, col4, dense_rank() over(partition by col4) d_rank from dense_rank_pk order by 4, 1, 2, 3, 5;

--TEST: OVER(PARTITION BY) clause, table with fk
--TEST: partition by int
select col1, col2, col3, dense_rank() over(partition by col1) d_rank from dense_rank_fk order by 1, 2, 3, 4;
--TEST: partition by char(n)
select col1, col2, col3, dense_rank() over(partition by col2) d_rank from dense_rank_fk order by 2, 1, 3, 4;
--TEST: partition by timestamp
select col1, col2, col3, dense_rank() over(partition by col3) d_rank from dense_rank_fk order by 3, 1, 2, 4;
--TEST: partition by datetime
select col1, col2, col3, dense_rank() over(partition by col4) d_rank from dense_rank_fk order by 4, 1, 2, 3;


--TEST: OVER(ORDER BY) clause, table with pk
--TEST: order by 1 column name
select col1, dense_rank() over(order by col1) d_rank from dense_rank_pk order by 1, 2;
--TEST: order by 2 column names
select col2, col3, dense_rank() over(order by col2, col3 asc) d_rank from dense_rank_pk order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, dense_rank() over(order by col1, col2 desc, col3, col4 asc) d_rank from dense_rank_pk order by 1, 2, 3, 4, 5;
--TEST: order by columns not selected
select col3, dense_rank() over(order by col4 desc, col2, col1 asc) d_rank from dense_rank_pk order by 1, 2;
--TEST: order by 1 position
select col4, dense_rank() over(order by 1) d_rank from dense_rank_pk order by 1, 2;
--TEST: order by 3 positions
select col3, col2, dense_rank() over(order by 1, 2 desc, 3 asc) d_rank from dense_rank_pk order by 1, 2, 3;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, dense_rank() over(order by 3, 2 asc, 1 desc, 4) d_rank from dense_rank_pk order by 1, 2, 3, 4, 5;
--TEST: order by positions not existed
select col2, dense_rank() over(order by 2) d_rank from dense_rank_pk order by 1, 2;
select col1, dense_rank() over(order by 3, 4, 1 desc) rank, col2, col4 from dense_rank_pk order by 1, 2;
select col3, col4, dense_rank() over(order by 5) d_rank from dense_rank_pk;
select col3, col1, dense_rank() over(order by 100) d_rank from dense_rank_pk;
--TEST: order by column names and positions
select col1, col2, col3, col4, dense_rank() over(order by 1, col2 desc, 3, col4 asc) d_rank from dense_rank_pk order by 1, 2, 3, 4, 5;

--TEST: OVER(ORDER BY) clause, table with fk
--TEST: order by 1 column name
select col1, dense_rank() over(order by col1) d_rank from dense_rank_fk order by 1, 2;
--TEST: order by 2 column names
select col2, col3, dense_rank() over(order by col2, col3 asc) d_rank from dense_rank_fk order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, dense_rank() over(order by col1, col2 desc, col3 asc) d_rank from dense_rank_fk order by 1, 2, 3, 4;
--TEST: order by columns not selected
select col3, dense_rank() over(order by col2, col1 asc) d_rank from dense_rank_fk order by 1, 2;
--TEST: order by 1 position
select col2, dense_rank() over(order by 1) d_rank from dense_rank_fk order by 1, 2;
--TEST: order by 3 positions
select col3, col2, dense_rank() over(order by 1, 2 desc, 3 asc) d_rank from dense_rank_fk order by 1, 2, 3;
--TEST: order by positions not existed
select col2, dense_rank() over(order by 2) d_rank from dense_rank_fk order by 1, 2;
select col1, dense_rank() over(order by 3, 4, 1 desc) rank, col2 from dense_rank_fk order by 1, 2;
select col3, col1, dense_rank() over(order by 100) d_rank from dense_rank_fk;
--TEST: order by column names and positions
select col1, col2, col3, dense_rank() over(order by 1, col2 desc, 3) d_rank from dense_rank_fk order by 1, 2, 3, 4;




--TEST: OVER(PARTITION BY ORDER BY) clause, table with pk
--TEST: partition by date
select col1, col2, col3, dense_rank() over(partition by col1 order by col1, col2, col3) from dense_rank_pk;
--TEST: partition by time
select col2, col4, col1, dense_rank() over(partition by col2 order by col2, col4, col1 desc) from dense_rank_pk;
--TEST: partition by timestamp
select col3, dense_rank() over(partition by col3 order by col3) rank, col2 from dense_rank_pk;
--TEST: partition by datetime
select col4, col1, dense_rank() over(partition by col4 order by 1, 2 desc) d_rank from dense_rank_pk;
--TEST: syntax error
select col1, col2, dense_rank() over(order by col1, col2 partition by col2) from dense_rank_pk;

--TEST: OVER(PARTITION BY ORDER BY) clause, table with fk
--TEST: partition by int
select col1, col2, col3, dense_rank() over(partition by col1 order by col1, col2, col3) from dense_rank_fk;
--TEST: partition by char(n)
select col2, col3, col1, dense_rank() over(partition by col2 order by col2, col3, col1 desc) from dense_rank_fk;
--TEST: partition by timestamp
select col3, dense_rank() over(partition by col3 order by col3) rank, col2 from dense_rank_fk;
--TEST: syntax error
select col1, col2, dense_rank() over(order by col1, col2 partition by col2) from dense_rank_fk;



drop table dense_rank_fk; 
drop table dense_rank_pk; 















