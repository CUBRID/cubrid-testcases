--TEST: test with a table with a superclass 


create table min_collection(
	col1 set(int, char(1)),
	col2 multiset(char(2), smallint), 
	col3 list(timestamp, bigint),
	col4 sequence(varchar, datetime),
	col5 numeric(8, 4)
);


--create subclasses
create table min_sub1 under min_collection(col7 int, col6 char(10));
create table min_sub2 under min_collection(col6 bigint, col8 float, col10 blob);
create table min_sub3 under min_collection(col8 double, col6 varchar, col7 list(timestamp));


insert into min_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1990-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 1234.5678);
insert into min_collection values({1, 2, 3}, {'d', 4, 'd', 4, 'd'}, {'1991-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 2345.6789);
insert into min_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1992-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 3456.7891);
insert into min_collection values({1, 2, 3}, {'d', 4, 'd', 4, 'd'}, {'1993-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 4567.8912);
insert into min_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1994-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 5678.9123);
insert into min_collection values({3, 5, 'a', 'b'}, {'d', 4, 'd', 4, 'd'}, {'1995-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 6789.1234);
insert into min_collection values({3, 5, 'a', 'b'}, {1, 1, 3, 'a'}, {'1996-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 7890.1234);
insert into min_collection values({3, 5, 'a', 'b'}, {1, 1, 3, 'a'}, {'1997-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 8901.2345);
insert into min_collection values({3, 5, 'a', 'b'}, {'r', 8, 'r', 10}, {'1998-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 9012.3456);
insert into min_collection values({'c', 3, 'd'}, {1, 1, 3, 'a'}, {'1999-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 1234.5678);
insert into min_collection values({'c', 3, 'd'}, {1, 1, 3, 'a'}, {'2000-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 2345.6789);
insert into min_collection values({'c', 3, 'd'}, {'r', 8, 'r', 10}, {'2001-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 3456.7891);
insert into min_collection values({'e', 'f', 'g'}, {1, 1, 3, 'a'}, {'2002-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 4567.8901);
insert into min_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2003-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 5678.9012);
insert into min_collection values({11, 12, 'k', 'g'}, {'d', 4, 'd', 4, 'd'}, {'2004-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 6789.0123);
insert into min_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2005-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 7890.1234);
insert into min_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2006-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 8901.2345);
insert into min_collection values({11, 12, 'k', 'g'}, {'r', 8, 'r', 10}, {'2007-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 9012.3456);
insert into min_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2008-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 1234.5678);
insert into min_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2009-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 2345.6789);


--TEST: OVER() clause
--TEST: set 
select col1, col2, min(col5) over() from min_collection order by 1, 2;
--TEST: multiset, with alias+all
select col2, col3, min(all col5) over() minimum from min_collection order by 1, 2;
--TEST: list, with where clause
select col3, col4, min(col5) over() minimum from min_collection where col1 > {1, 2, 3} order by col3, col4;
--TEST: sequence, distinct
select col4, col1, min(distinct col5) over() minimum from min_collection order by 1, 2;
--TEST: syntax error
select col5, min(unique col5) over() minimum from min_collection order by 1, 2;
select col1, col3, col4, min(col5) over minimum from min_collection;
select col1, col3, col2, min(col5) over(1) minimum from min_collection;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by set
select col1, col2, col3, col4, min(unique col5) over(partition by col1) minimum from min_collection order by 1, 2, 3, 4;
--TEST: partition by multiset
select col1, col2, col3, col4, min(distinct col5) over(partition by col2) minimum from min_collection order by 2, 1, 3, 4;
--TEST: partition by list
select col1, col2, col3, col4, min(col5) over(partition by col3) minimum from min_collection order by 3, 1, 2, 4;
--TEST: partition by sequence
select col1, col2, col3, col4, min(all col5) over(partition by col4) minimum from min_collection order by 4, 1, 2, 3, 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select minimum from (select col1, min(unique col5) over(order by col5) minimum from min_collection) order by 1;
--TEST: order by 2 column names
select col2, col3, min(all col5) over(order by col2, col3 asc) minimum from min_collection;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, min(col5) over(order by col1, col2 desc, col3, col4 asc) minimum from min_collection;
--TEST: order by columns not selected
select col3, min(distinctrow col5) over(order by col4 desc, col2, col1 asc) minimum from min_collection;
--TEST: order by 1 position
select col4, min(unique col5) over(order by 1) minimum from min_collection;
--TEST: order by 3 positions
select col3, col2, min(col5) over(order by 1, 2 desc, 3 asc) minimum from min_collection;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, min(col5) over(order by 3, 2 asc, 1 desc, 4) minimum from min_collection;
--TEST: order by positions not existed
select col2, min(distinct col5) over(order by 2) minimum from min_collection;
select col1, min(all col5) over(order by 3, 4, 1 desc) minimum, col2, col4 from min_collection;
select col3, col4, min(col5) over(order by 5) minimum from min_collection;
select col3, col1, min(col5) over(order by 100) minimum from min_collection;
--TEST: order by column names and positions
select col1, col2, col3, col4, min(col5) over(order by 1, col2 desc, 3, col4 asc) minimum from min_collection;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by set
select col1, col2, col3, min(distinct col5) over(partition by col1 order by 1, 2, 3) from min_collection;
--TEST: partition by multiset
select col2, col4, col1, min(col5) over(partition by col2 order by col2, col4, col1 desc) from min_collection;
--TEST: partition by list
select col3, min(all col5) over(partition by col3 order by 1, 2, 3) minimum, col2 from min_collection;
--TEST: partition by sequence
select col4, col1, min(col5) over(partition by col4 order by 1, 2 desc) minimum from min_collection;
--TEST: syntax error
select col1, col2, min(distinct col5) over(order by col1, col2 partition by col2) from min_collection;



drop table min_collection; 
drop table min_sub1;
drop table min_sub2;
drop table min_sub3;














