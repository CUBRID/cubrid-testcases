--TEST: test with collection data types and normal syntax


create table count_collection(
	col1 set(int, char(1)),
	col2 multiset(char(2), smallint), 
	col3 list(timestamp, bigint),
	col4 sequence(varchar, datetime)
);


--create subclasses
create table count_sub1 under count_collection(col5 int, col6 char(10));
create table count_sub2 under count_collection(col5 bigint, col8 float, col10 blob);
create table count_sub3 under count_collection(col5 double, col6 varchar, col7 list(timestamp));


insert into count_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1990-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({1, 2, 3}, {'d', 4, 'd', 4, 'd'}, {'1991-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1992-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({1, 2, 3}, {'d', 4, 'd', 4, 'd'}, {'1993-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1994-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({3, 5, 'a', 'b'}, {'d', 4, 'd', 4, 'd'}, {'1995-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({3, 5, 'a', 'b'}, {1, 1, 3, 'a'}, {'1996-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({3, 5, 'a', 'b'}, {1, 1, 3, 'a'}, {'1997-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({3, 5, 'a', 'b'}, {'r', 8, 'r', 10}, {'1998-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({'c', 3, 'd'}, {1, 1, 3, 'a'}, {'1999-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({'c', 3, 'd'}, {1, 1, 3, 'a'}, {'2000-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({'c', 3, 'd'}, {'r', 8, 'r', 10}, {'2001-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into count_collection values({'e', 'f', 'g'}, {1, 1, 3, 'a'}, {'2002-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into count_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2003-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into count_collection values({11, 12, 'k', 'g'}, {'d', 4, 'd', 4, 'd'}, {'2004-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into count_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2005-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into count_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2006-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into count_collection values({11, 12, 'k', 'g'}, {'r', 8, 'r', 10}, {'2007-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into count_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2008-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into count_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2009-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});


--TEST: OVER() clause
--TEST: set 
select col1, col2, count(col1) over() from count_collection order by 1, 2;
--TEST: multiset, with alias+all
select col2, col3, count(all col2) over() cnt from count_collection order by 1, 2;
--TEST: list, with where clause
select col3, col4, count(col3) over() cnt from count_collection where col1 > {1, 2, 3} order by col3, col4;
--TEST: sequence, distinct
select col4, col1, count(distinct col4) over() cnt from count_collection order by 1, 2;
--TEST: syntax error
select col1, col3, col4, count(*) over cnt from count_collection;
select col1, col3, col2, count(*) over(1) cnt from count_collection;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by set
select col1, col2, col3, col4, count(*) over(partition by col1) cnt from count_collection order by 1, 2, 3, 4;
--TEST: partition by multiset
select col1, col2, col3, col4, count(distinct col4) over(partition by col2) cnt from count_collection order by 2, 1, 3, 4;
--TEST: partition by list
select col1, col2, col3, col4, count(*) over(partition by col3) cnt from count_collection order by 3, 1, 2, 4;
--TEST: partition by sequence
select col1, col2, col3, col4, count(all col2) over(partition by col4) cnt from count_collection order by 4, 1, 2, 3, 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, count(col2) over(order by col1) cnt from count_collection;
--TEST: order by 2 column names
select col2, col3, count(all col4) over(order by col2, col3 asc) cnt from count_collection;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, count(*) over(order by col1, col2 desc, col3, col4 asc) cnt from count_collection;
--TEST: order by columns not selected
select col3, count(distinct col2) over(order by col4 desc, col2, col1 asc) cnt from count_collection;
--TEST: order by 1 position
select col4, count(all col2) over(order by 1) cnt from count_collection;
--TEST: order by 3 positions
select col3, col2, count(*) over(order by 1, 2 desc, 3 asc) cnt from count_collection;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, count(*) over(order by 3, 2 asc, 1 desc, 4) cnt from count_collection;
--TEST: order by positions not existed
select col2, count(distinct col1) over(order by 2) cnt from count_collection;
select col1, count(all col3) over(order by 3, 4, 1 desc) cnt, col2, col4 from count_collection;
select col3, col4, count(*) over(order by 5) cnt from count_collection;
select col3, col1, count(*) over(order by 100) cnt from count_collection;
--TEST: order by column names and positions
select col1, col2, col3, col4, count(*) over(order by 1, col2 desc, 3, col4 asc) cnt from count_collection;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by set
select col1, col2, col3, count(distinct col4) over(partition by col1 order by 1, 2, 3) from count_collection;
--TEST: partition by multiset
select col2, col4, col1, count(col3) over(partition by col2 order by col2, col4, col1 desc) from count_collection;
--TEST: partition by list
select col3, count(all col4) over(partition by col3 order by 1, 2, 3) cnt, col2 from count_collection;
--TEST: partition by sequence
select col4, col1, count(*) over(partition by col4 order by 1, 2 desc) cnt from count_collection;
--TEST: syntax error
select col1, col2, count(distinct col3) over(order by col1, col2 partition by col2) from count_collection;



drop table count_collection; 
drop count_sub1, count_sub2, count_sub3;















