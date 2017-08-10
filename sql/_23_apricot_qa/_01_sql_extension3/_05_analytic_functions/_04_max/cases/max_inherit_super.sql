--TEST: test with a table with a superclass 


create table max_collection(
	col1 set(int, char(1)),
	col2 multiset(char(2), smallint), 
	col3 list(timestamp, bigint),
	col4 sequence(varchar, datetime),
	col5 numeric(8, 4)
);


--create subclasses
create table max_sub1 under max_collection(col7 int, col6 char(10));
create table max_sub2 under max_collection(col6 bigint, col8 float, col10 blob);
create table max_sub3 under max_collection(col8 double, col6 varchar, col7 list(timestamp));


insert into max_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1990-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 1234.5678);
insert into max_collection values({1, 2, 3}, {'d', 4, 'd', 4, 'd'}, {'1991-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 2345.6789);
insert into max_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1992-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 3456.7891);
insert into max_collection values({1, 2, 3}, {'d', 4, 'd', 4, 'd'}, {'1993-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 4567.8912);
insert into max_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1994-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 5678.9123);
insert into max_collection values({3, 5, 'a', 'b'}, {'d', 4, 'd', 4, 'd'}, {'1995-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 6789.1234);
insert into max_collection values({3, 5, 'a', 'b'}, {1, 1, 3, 'a'}, {'1996-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 7890.1234);
insert into max_collection values({3, 5, 'a', 'b'}, {1, 1, 3, 'a'}, {'1997-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 8901.2345);
insert into max_collection values({3, 5, 'a', 'b'}, {'r', 8, 'r', 10}, {'1998-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 9012.3456);
insert into max_collection values({'c', 3, 'd'}, {1, 1, 3, 'a'}, {'1999-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 1234.5678);
insert into max_collection values({'c', 3, 'd'}, {1, 1, 3, 'a'}, {'2000-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 2345.6789);
insert into max_collection values({'c', 3, 'd'}, {'r', 8, 'r', 10}, {'2001-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 3456.7891);
insert into max_collection values({'e', 'f', 'g'}, {1, 1, 3, 'a'}, {'2002-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 4567.8901);
insert into max_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2003-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 5678.9012);
insert into max_collection values({11, 12, 'k', 'g'}, {'d', 4, 'd', 4, 'd'}, {'2004-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 6789.0123);
insert into max_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2005-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 7890.1234);
insert into max_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2006-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 8901.2345);
insert into max_collection values({11, 12, 'k', 'g'}, {'r', 8, 'r', 10}, {'2007-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 9012.3456);
insert into max_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2008-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 1234.5678);
insert into max_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2009-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 2345.6789);


--TEST: OVER() clause
--TEST: set 
select col1, col2, max(col5) over() from max_collection order by 1, 2;
--TEST: multiset, with alias+all
select col2, col3, max(all col5) over() maximum from max_collection order by 1, 2;
--TEST: list, with where clause
select col3, col4, max(col5) over() maximum from max_collection where col1 > {1, 2, 3} order by col3, col4;
--TEST: sequence, distinct
select col4, col1, max(distinct col5) over() maximum from max_collection order by 1, 2;
--TEST: syntax error
select col5, max(unique col5) over() maximum from max_collection order by 1, 2;
select col1, col3, col4, max(col5) over maximum from max_collection;
select col1, col3, col2, max(col5) over(1) maximum from max_collection;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by set
select col1, col2, col3, col4, max(unique col5) over(partition by col1) maximum from max_collection order by 1, 2, 3, 4;
--TEST: partition by multiset
select col1, col2, col3, col4, max(distinct col5) over(partition by col2) maximum from max_collection order by 2, 1, 3, 4;
--TEST: partition by list
select col1, col2, col3, col4, max(col5) over(partition by col3) maximum from max_collection order by 3, 1, 2, 4;
--TEST: partition by sequence
select col1, col2, col3, col4, max(all col5) over(partition by col4) maximum from max_collection order by 4, 1, 2, 3, 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, max(unique col5) over(order by col5) maximum from max_collection order by 1, 2;
--TEST: order by 2 column names
select col2, col3, max(all col5) over(order by col2, col3 asc) maximum from max_collection order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, max(col5) over(order by col1, col2 desc, col3, col4 asc) maximum from max_collection;
--TEST: order by columns not selected
select col3, max(unique col5) over(order by col4 desc, col2, col1 asc) maximum from max_collection;
--TEST: order by 1 position
select col4, max(unique col5) over(order by 1) maximum from max_collection;
--TEST: order by 3 positions
select col3, col2, max(col5) over(order by 1, 2 desc, 3 asc) maximum from max_collection;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, max(col5) over(order by 3, 2 asc, 1 desc, 4) maximum from max_collection;
--TEST: order by positions not existed
select col2, max(distinct col5) over(order by 2) maximum from max_collection;
select col1, max(all col5) over(order by 3, 4, 1 desc) maximum, col2, col4 from max_collection;
select col3, col4, max(col5) over(order by 5) maximum from max_collection;
select col3, col1, max(col5) over(order by 100) maximum from max_collection;
--TEST: order by column names and positions
select col1, col2, col3, col4, max(col5) over(order by 1, col2 desc, 3, col4 asc) maximum from max_collection;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by set
select col1, col2, col3, max(distinct col5) over(partition by col1 order by 1, 2, 3) from max_collection;
--TEST: partition by multiset
select col2, col4, col1, max(col5) over(partition by col2 order by col2, col4, col1 desc) from max_collection;
--TEST: partition by list
select col3, max(all col5) over(partition by col3 order by 1, 2, 3) maximum, col2 from max_collection;
--TEST: partition by sequence
select col4, col1, max(col5) over(partition by col4 order by 1, 2 desc) maximum from max_collection;
--TEST: syntax error
select col1, col2, max(distinct col5) over(order by col1, col2 partition by col2) from max_collection;



drop table max_collection; 
drop table max_sub1;
drop table max_sub2;
drop table max_sub3;














