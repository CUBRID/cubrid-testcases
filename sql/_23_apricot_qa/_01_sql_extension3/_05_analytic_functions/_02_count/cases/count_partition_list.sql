--TEST: test with tables with list partition 


create table count_p_list(
	col1 char(20),
	col2 varchar(100), 
	col3 nchar(10),
	col4 nchar varying,
	col5 string
)
partition by list (col2) (
partition p1 values in ('This is a dog.'),
partition p2 values in ('This is a rabbit.'),
partition p3 values in ('This is a cat.')
);


insert into count_p_list values('aaaaa', 'This is a dog.', n'1990-1-1 1', n'cubrid', 'character');
insert into count_p_list values('aaaaa', 'This is a cat.', n'1991-1-1 1', n'cubrid', 'character');
insert into count_p_list values('aaaaa', 'This is a dog.', n'1992-1-1 1', n'cubrid', 'character');
insert into count_p_list values('aaaaa', 'This is a cat.', n'1993-1-1 1', n'mysql', 'character');
insert into count_p_list values('aaaaa', 'This is a dog.', n'1994-1-1 1', n'mysql', 'character');
insert into count_p_list values('eeeee', 'This is a cat.', n'1995-1-1 1', n'mysql', 'character');
insert into count_p_list values('eeeee', 'This is a dog.', n'1996-1-1 1', n'mysql', 'character');
insert into count_p_list values('eeeee', 'This is a dog.', n'1997-1-1 1', n'mysql', 'character');
insert into count_p_list values('eeeee', 'This is a rabbit.', n'1998-1-1 1', n'mysql', 'character');
insert into count_p_list values('ccccc', 'This is a dog.', n'1999-1-1 1', n'mysql', 'character');
insert into count_p_list values('ccccc', 'This is a dog.', n'2000-1-1 1', n'cubrid', 'string');
insert into count_p_list values('ccccc', 'This is a rabbit.', n'2001-1-1 1', n'cubrid', 'string');
insert into count_p_list values('zzzzz', 'This is a dog.', n'2002-1-1 1', n'cubrid', 'string');
insert into count_p_list values('bbbbb', 'This is a dog.', n'2003-1-1 1', n'cubrid', 'string');
insert into count_p_list values('bbbbb', 'This is a cat.', n'2004-1-1 1', n'oracle', 'string');
insert into count_p_list values('bbbbb', 'This is a dog.', n'2005-1-1', n'oracle', 'string');
insert into count_p_list values('bbbbb', 'This is a dog.', n'2006-1-1 1', n'oracle', 'string');
insert into count_p_list values('bbbbb', 'This is a rabbit.', n'2007-1-1 1', n'oracle', 'string');
insert into count_p_list values('bbbbb', 'This is a dog.', n'2008-1-1 1', n'cubrid', 'string');
insert into count_p_list values('bbbbb', 'This is a dog.', n'2009-1-1 1', n'cubrid', 'string');


--TEST: select from partition
select col1, col2, col4, count(col4) over(partition by col2) from count_p_list__p__p1;
select col1, col2, col4, count(distinct col2) over(order by col4) from count_p_list__p__p2;
select col1, col2, col5, count(unique col2) over(partition by col1 order by col2, col5) from count_p_list__p__p3;

--TEST: OVER() clause
--TEST: char(n) 
select col1, col2, count(col1) over() from count_p_list order by 1, 2;
--TEST: varchar(n), with alias+all
select col2, col3, count(all col2) over() cnt from count_p_list order by 1, 2;
--TEST: nchar(n), with where clause
select col3, col4, count(col3) over() cnt from count_p_list where col1 > 'aaaaa' order by col3, col4;
--TEST: nchar varying, distinct
select col4, col1, count(distinct col4) over() cnt from count_p_list order by 1, 2;
--TEST: string
select col5, col3, count(all col5) over() cnt from count_p_list order by 1, 2;
--TEST: syntax error
select col1, col3, col4, count(*) over cnt from count_p_list;
select col1, col3, col2, count(*) over(1) cnt from count_p_list;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by char(n)
select col1, col2, col3, col4, col5, count(*) over(partition by col1) cnt from count_p_list order by 1, 2, 3, 4, 5;
--TEST: partition by varchar(n)
select col1, col2, col3, col4, col5, count(distinct col4) over(partition by col2) cnt from count_p_list order by 2, 1, 3, 4, 5;
--TEST: partition by nchar(n)
select col1, col2, col3, col4, col5, count(*) over(partition by col3) cnt from count_p_list order by 3, 1, 2, 4, 5;
--TEST: partition by nchar varying
select col1, col2, col3, col4, col5, count(all col2) over(partition by col4) cnt from count_p_list order by 4, 1, 2, 3, 5;
--TEST: partition by string
select col1, col2, col3, col4, col5, count(col5) over(partition by col5) cnt from count_p_list order by 4, 1, 2, 3, 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, count(col2) over(order by col1) cnt from count_p_list;
--TEST: order by 2 column names
select col2, col3, count(all col4) over(order by col2, col3 asc) cnt from count_p_list;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, col5, count(*) over(order by col1, col2 desc, col3, col4 asc, col5) cnt from count_p_list;
--TEST: order by columns not selected
select col3, count(distinct col2) over(order by col4 desc, col2, col1 asc) cnt from count_p_list;
--TEST: order by 1 position
select col4, count(all col2) over(order by 1) cnt from count_p_list;
--TEST: order by 3 positions
select col3, col2, count(*) over(order by 1, 2 desc, 3 asc) cnt from count_p_list;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, col5, count(*) over(order by 3, 2 asc, 5 desc, 1 desc, 4) cnt from count_p_list;
--TEST: order by positions not existed
select col2, count(distinct col1) over(order by 2) cnt from count_p_list;
select col1, count(all col3) over(order by 3, 4, 1 desc) cnt, col2, col4 from count_p_list;
select col3, col4, count(*) over(order by 5) cnt from count_p_list;
select col3, col1, count(*) over(order by 100) cnt from count_p_list;
--TEST: order by column names and positions
select col1, col2, col3, col4, col5, count(*) over(order by 1, col2 desc, 3, col4 asc, 5 desc) cnt from count_p_list;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by char(n)
select col1, col2, col3, count(distinct col4) over(partition by col1 order by 1, 2, 3) from count_p_list;
--TEST: partition by varchar(n)
select col2, col4, col1, count(col3) over(partition by col2 order by col2, col4, col1 desc) from count_p_list;
--TEST: partition by nchar(n)
select col3, count(all col4) over(partition by col3 order by 1, 2, 3) cnt, col2 from count_p_list;
--TEST: partition by nchar varying
select col4, col1, count(*) over(partition by col4 order by 1, 2 desc) cnt from count_p_list;
--TEST: partition by string
select col5, col2, col4, count(all col5) over(partition by col5 order by col4, 1, 2 asc) from count_p_list;
--TEST: syntax error
select col1, col2, count(distinct col3) over(order by col1, col2 partition by col2) from count_p_list;



drop table count_p_list; 















