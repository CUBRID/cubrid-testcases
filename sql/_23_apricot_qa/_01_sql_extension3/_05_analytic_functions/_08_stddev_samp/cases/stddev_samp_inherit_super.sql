--TEST: test with a table with a superclass 


create table stddev_samp_collection(
	col1 set(int, char(1)),
	col2 multiset(char(2), smallint), 
	col3 list(timestamp, bigint),
	col4 sequence(varchar, datetime),
	col5 int
);


--create subclasses
create table stddev_samp_sub1 under stddev_samp_collection(col7 int, col6 char(10));
create table stddev_samp_sub2 under stddev_samp_collection(col6 bigint, col8 float, col10 blob);
create table stddev_samp_sub3 under stddev_samp_collection(col8 double, col6 varchar, col7 list(timestamp));


insert into stddev_samp_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1990-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 1234.5678);
insert into stddev_samp_collection values({1, 2, 3}, {'d', 4, 'd', 4, 'd'}, {'1991-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 2345.6789);
insert into stddev_samp_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1992-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 3456.7891);
insert into stddev_samp_collection values({1, 2, 3}, {'d', 4, 'd', 4, 'd'}, {'1993-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 4567.8912);
insert into stddev_samp_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1994-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 5678.9123);
insert into stddev_samp_collection values({3, 5, 'a', 'b'}, {'d', 4, 'd', 4, 'd'}, {'1995-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 6789.1234);
insert into stddev_samp_collection values({3, 5, 'a', 'b'}, {1, 1, 3, 'a'}, {'1996-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 7890.1234);
insert into stddev_samp_collection values({3, 5, 'a', 'b'}, {1, 1, 3, 'a'}, {'1997-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 8901.2345);
insert into stddev_samp_collection values({3, 5, 'a', 'b'}, {'r', 8, 'r', 10}, {'1998-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 9012.3456);
insert into stddev_samp_collection values({'c', 3, 'd'}, {1, 1, 3, 'a'}, {'1999-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 1234.5678);
insert into stddev_samp_collection values({'c', 3, 'd'}, {1, 1, 3, 'a'}, {'2000-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 2345.6789);
insert into stddev_samp_collection values({'c', 3, 'd'}, {'r', 8, 'r', 10}, {'2001-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'}, 3456.7891);
insert into stddev_samp_collection values({'e', 'f', 'g'}, {1, 1, 3, 'a'}, {'2002-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 4567.8901);
insert into stddev_samp_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2003-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 5678.9012);
insert into stddev_samp_collection values({11, 12, 'k', 'g'}, {'d', 4, 'd', 4, 'd'}, {'2004-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 6789.0123);
insert into stddev_samp_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2005-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 7890.1234);
insert into stddev_samp_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2006-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 8901.2345);
insert into stddev_samp_collection values({11, 12, 'k', 'g'}, {'r', 8, 'r', 10}, {'2007-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 9012.3456);
insert into stddev_samp_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2008-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 1234.5678);
insert into stddev_samp_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2009-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'}, 2345.6789);


--TEST: OVER() clause
--TEST: set 
select trunc(stddev_samp, 5) from (select  col1, col2, stddev_samp(col5) over() stddev_samp from stddev_samp_collection) order by 1;
--TEST: multiset, with alias+all
select trunc(stddev_samp, 5) from (select  col2, col3, stddev_samp(all col5) over() stddev_samp from stddev_samp_collection) order by 1;
--TEST: list, with where clause
select trunc(stddev_samp, 5) from (select  col3, col4, stddev_samp(col5) over() stddev_samp from stddev_samp_collection where col1 > {1, 2, 3}) order by 1;
--TEST: sequence, distinct
select trunc(stddev_samp, 5) from (select  col4, col1, stddev_samp(distinct col5) over() stddev_samp from stddev_samp_collection) order by 1;
--TEST: syntax error
select trunc(stddev_samp, 5) from (select  col5, stddev_samp(unique col5) over() stddev_samp from stddev_samp_collection) order by 1;
select trunc(stddev_samp, 5) from (select  col1, col3, col4, stddev_samp(col5) over stddev_samp from stddev_samp_collection;
select trunc(stddev_samp, 5) from (select  col1, col3, col2, stddev_samp(col5) over(1) stddev_samp from stddev_samp_collection;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by set
select trunc(stddev_samp, 5) from (select  col1, col2, col3, col4, stddev_samp(unique col5) over(partition by col1) stddev_samp from stddev_samp_collection) order by 1;
--TEST: partition by multiset
select trunc(stddev_samp, 5) from (select  col1, col2, col3, col4, stddev_samp(distinct col5) over(partition by col2) stddev_samp from stddev_samp_collection) order by 1;
--TEST: partition by list
select trunc(stddev_samp, 5) from (select  col1, col2, col3, col4, stddev_samp(col5) over(partition by col3) stddev_samp from stddev_samp_collection) order by 1;
--TEST: partition by sequence
select trunc(stddev_samp, 5) from (select  col1, col2, col3, col4, stddev_samp(all col5) over(partition by col4) stddev_samp from stddev_samp_collection) order by 1;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select trunc(stddev_samp, 5) from (select  col1, stddev_samp(unique col5) over(order by col5) stddev_samp from stddev_samp_collection) order by 1;
--TEST: order by 2 column names
select trunc(stddev_samp, 5) from (select  col2, col3, stddev_samp(all col5) over(order by col2, col3 asc) stddev_samp from stddev_samp_collection) order by 1;
--TEST: order by more than 2 column names
select trunc(stddev_samp, 5) from (select  col1, col2, col3, col4, stddev_samp(col5) over(order by col1, col2 desc, col3, col4 asc) stddev_samp from stddev_samp_collection) order by 1;
--TEST: order by columns not select trunc(stddev_samp, 5) from (select ed
select trunc(stddev_samp, 5) from (select  col3, stddev_samp(distinctrow col5) over(order by col4 desc, col2, col1 asc) stddev_samp from stddev_samp_collection) order by 1;
--TEST: order by 1 position
select trunc(stddev_samp, 5) from (select  col4, stddev_samp(unique col5) over(order by 1) stddev_samp from stddev_samp_collection) order by 1;
--TEST: order by 3 positions
select trunc(stddev_samp, 5) from (select  col3, col2, stddev_samp(col5) over(order by 1, 2 desc, 3 asc) stddev_samp from stddev_samp_collection) order by 1;
--TEST: order by more than 3 positions
select trunc(stddev_samp, 5) from (select  col1, col2, col3, col4, stddev_samp(col5) over(order by 3, 2 asc, 1 desc, 4) stddev_samp from stddev_samp_collection) order by 1;
--TEST: order by positions not existed
select trunc(stddev_samp, 5) from (select  col2, stddev_samp(distinct col5) over(order by 2) stddev_samp from stddev_samp_collection) order by 1;
select trunc(stddev_samp, 5) from (select  col1, stddev_samp(all col5) over(order by 3, 4, 1 desc) stddev_samp, col2, col4 from stddev_samp_collection) order by 1;
select trunc(stddev_samp, 5) from (select  col3, col4, stddev_samp(col5) over(order by 5) stddev_samp from stddev_samp_collection) order by 1;
select trunc(stddev_samp, 5) from (select  col3, col1, stddev_samp(col5) over(order by 100) stddev_samp from stddev_samp_collection) order by 1;
--TEST: order by column names and positions
select trunc(stddev_samp, 5) from (select  col1, col2, col3, col4, stddev_samp(col5) over(order by 1, col2 desc, 3, col4 asc) stddev_samp from stddev_samp_collection) order by 1;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by set
select trunc(stddev_samp, 5) from (select  col1, col2, col3, stddev_samp(distinct col5) over(partition by col1 order by 1, 2, 3) stddev_samp from stddev_samp_collection) order by 1;
--TEST: partition by multiset
select trunc(stddev_samp, 5) from (select  col2, col4, col1, stddev_samp(col5) over(partition by col2 order by col2, col4, col1 desc) stddev_samp from stddev_samp_collection) order by 1;
--TEST: partition by list
select trunc(stddev_samp, 5) from (select  col3, stddev_samp(all col5) over(partition by col3 order by 1, 2, 3) stddev_samp, col2 from stddev_samp_collection) order by 1;
--TEST: partition by sequence
select trunc(stddev_samp, 5) from (select  col4, col1, stddev_samp(col5) over(partition by col4 order by 1, 2 desc) stddev_samp from stddev_samp_collection) order by 1;
--TEST: syntax error
select trunc(stddev_samp, 5) from (select  col1, col2, stddev_samp(distinct col5) over(order by col1, col2 partition by col2) from stddev_samp_collection) order by 1;



drop table stddev_samp_collection; 
drop table stddev_samp_sub1;
drop table stddev_samp_sub2;
drop table stddev_samp_sub3;














