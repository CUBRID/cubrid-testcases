--TEST: test with views 


create table rank_collection(
	col1 set(int, char(1)),
	col2 multiset(char(2), smallint), 
	col3 list(timestamp, bigint),
	col4 sequence(varchar, datetime)
);


insert into rank_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1990-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({1, 2, 3}, {'d', 4, 'd', 4, 'd'}, {'1991-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1992-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({1, 2, 3}, {'d', 4, 'd', 4, 'd'}, {'1993-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({1, 2, 3}, {1, 1, 3, 'a'}, {'1994-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({3, 5, 'a', 'b'}, {'d', 4, 'd', 4, 'd'}, {'1995-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({3, 5, 'a', 'b'}, {1, 1, 3, 'a'}, {'1996-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({3, 5, 'a', 'b'}, {1, 1, 3, 'a'}, {'1997-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({3, 5, 'a', 'b'}, {'r', 8, 'r', 10}, {'1998-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({'c', 3, 'd'}, {1, 1, 3, 'a'}, {'1999-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({'c', 3, 'd'}, {1, 1, 3, 'a'}, {'2000-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({'c', 3, 'd'}, {'r', 8, 'r', 10}, {'2001-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'cubrid', 'mysql'});
insert into rank_collection values({'e', 'f', 'g'}, {1, 1, 3, 'a'}, {'2002-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into rank_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2003-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into rank_collection values({11, 12, 'k', 'g'}, {'d', 4, 'd', 4, 'd'}, {'2004-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into rank_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2005-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into rank_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2006-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into rank_collection values({11, 12, 'k', 'g'}, {'r', 8, 'r', 10}, {'2007-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into rank_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2008-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});
insert into rank_collection values({11, 12, 'k', 'g'}, {1, 1, 3, 'a'}, {'2009-1-1 11:11:11', 12, 10000000, 234234234234}, {datetime'2011-11-11 11:11:11.111', 'mysql', 'cubrid'});


--create view
create view rank_view as select * from rank_collection where 12.89 > 12.87;


--TEST: OVER() clause
--TEST: no alias
select col1, col2, rank() over() from rank_view order by 1, 2;
--TEST: with alias
select col2, col3, rank() over() rank from rank_view order by 1, 2;
--TEST: with where clause
select col3, col4, rank() over() rank from rank_view where col1 > {1, 2, 3} order by col3, col4;
--TEST: sequence
select col4, col1, rank() over() rank from rank_view order by 1, 2;
--TEST: syntax error
select *, rank() over() rank from count)numeric;
select col1, col3, col4, rank() over rank from rank_view;
select col1, col3, col2, rank() over(1) rank from rank_view;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by set
select col1, col2, col3, col4, rank() over(partition by col1) rank from rank_view order by 1, 2, 3, 4;
--TEST: partition by multiset
select col1, col2, col3, col4, rank() over(partition by col2) rank from rank_view order by 2, 1, 3, 4;
--TEST: partition by list
select col1, col2, col3, col4, rank() over(partition by col3) rank from rank_view order by 3, 1, 2, 4;
--TEST: partition by sequence
select col1, col2, col3, col4, rank() over(partition by col4) rank from rank_view order by 4, 1, 2, 3, 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, rank() over(order by col1) rank from rank_view;
--TEST: order by 2 column names
select col2, col3, rank() over(order by col2, col3 asc) rank from rank_view;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, rank() over(order by col1, col2 desc, col3, col4 asc) rank from rank_view;
--TEST: order by columns not selected
select col3, rank() over(order by col4 desc, col2, col1 asc) rank from rank_view;
--TEST: order by 1 position
select col4, rank() over(order by 1) rank from rank_view;
--TEST: order by 3 positions
select col3, col2, rank() over(order by 1, 2 desc, 3 asc) rank from rank_view;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, rank() over(order by 3, 2 asc, 1 desc, 4) rank from rank_view;
--TEST: order by positions not existed
select col2, rank() over(order by 2) rank from rank_view;
select col1, rank() over(order by 3, 4, 1 desc) rank, col2, col4 from rank_view;
select col3, col4, rank() over(order by 5) rank from rank_view;
select col3, col1, rank() over(order by 100) rank from rank_view;
--TEST: order by column names and positions
select col1, col2, col3, col4, rank() over(order by 1, col2 desc, 3, col4 asc) rank from rank_view;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by set
select col1, col2, col3, rank() over(partition by col1 order by col1, col2, col3) from rank_view;
--TEST: partition by multiset
select col2, col4, col1, rank() over(partition by col2 order by col2, col4, col1 desc) from rank_view;
--TEST: partition by list
select col3, rank() over(partition by col3 order by col3 desc) rank, col2 from rank_view;
--TEST: partition by sequence
select col4, col1, rank() over(partition by col4 order by 1, 2 desc) rank from rank_view;
--TEST: syntax error
select col1, col2, rank() over(order by col1, col2 partition by col2) from rank_view;



drop view rank_view; 
drop table rank_collection;















