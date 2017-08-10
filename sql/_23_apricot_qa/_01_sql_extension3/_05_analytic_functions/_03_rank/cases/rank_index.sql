--TEST: test with columns with indexes 


create table rank_index(
	col1 char(20),
	col2 varchar(100), 
	col3 nchar(10),
	col4 nchar varying,
	col5 string
);

--create indexes
create index col1_idx on rank_index(col1);
create reverse index col5_idx on rank_index(col5);
create index col2_col3_idx on rank_index(col2, col3);


insert into rank_index values('aaaaa', 'This is a dog.', n'1990-1-1 11:11:11', n'cubrid', 'character');
insert into rank_index values('aaaaa', 'This is a cat.', n'1991-1-1 11:11:11', n'cubrid', 'character');
insert into rank_index values('aaaaa', 'This is a dog.', n'1992-1-1 11:11:11', n'cubrid', 'character');
insert into rank_index values('aaaaa', 'This is a cat.', n'1993-1-1 11:11:11', n'mysql', 'character');
insert into rank_index values('aaaaa', 'This is a dog.', n'1994-1-1 11:11:11', n'mysql', 'character');
insert into rank_index values('eeeee', 'This is a cat.', n'1995-1-1 11:11:11', n'mysql', 'character');
insert into rank_index values('eeeee', 'This is a dog.', n'1996-1-1 11:11:11', n'mysql', 'character');
insert into rank_index values('eeeee', 'This is a dog.', n'1997-1-1 11:11:11', n'mysql', 'character');
insert into rank_index values('eeeee', 'This is a rabbit.', n'1998-1-1 11:11:11', n'mysql', 'character');
insert into rank_index values('ccccc', 'This is a dog.', n'1999-1-1 11:11:11', n'mysql', 'character');
insert into rank_index values('ccccc', 'This is a dog.', n'2000-1-1 11:11:11', n'cubrid', 'string');
insert into rank_index values('ccccc', 'This is a rabbit.', n'2001-1-1 11:11:11', n'cubrid', 'string');
insert into rank_index values('zzzzz', 'This is a dog.', n'2002-1-1 11:11:11', n'cubrid', 'string');
insert into rank_index values('bbbbb', 'This is a dog.', n'2003-1-1 11:11:11', n'cubrid', 'string');
insert into rank_index values('bbbbb', 'This is a cat.', n'2004-1-1 11:11:11', n'oracle', 'string');
insert into rank_index values('bbbbb', 'This is a dog.', n'2005-1-1 11:11:11', n'oracle', 'string');
insert into rank_index values('bbbbb', 'This is a dog.', n'2006-1-1 11:11:11', n'oracle', 'string');
insert into rank_index values('bbbbb', 'This is a rabbit.', n'2007-1-1 11:11:11', n'oracle', 'string');
insert into rank_index values('bbbbb', 'This is a dog.', n'2008-1-1 11:11:11', n'cubrid', 'string');
insert into rank_index values('bbbbb', 'This is a dog.', n'2009-1-1 11:11:11', n'cubrid', 'string');


--TEST: OVER() clause
--TEST: no alias
select col1, col2, rank() over() from rank_index order by 1, 2;
--TEST: varchar(n), with alias
select col2, col3, rank() over() rank from rank_index order by 1, 2;
--TEST: with where clause
select col3, col4, rank() over() rank from rank_index where col1 > 'aaaaa' order by col3, col4;
--TEST: nchar varying
select col4, col1, rank() over() rank from rank_index order by 1, 2;
--TEST: string
select col5, col3, rank() over() rank from rank_index order by 1, 2;
--TEST: syntax error
select *, rank() over() rank from rank_index order by 1, 2, 3, 4, 5, 6;
select col1, col3, col4, rank() over rank from rank_index;
select col1, col3, col2, rank() over(1) rank from rank_index;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by char(n)
select col1, col2, col3, col4, col5, rank() over(partition by col1) rank from rank_index order by 1, 2, 3;
--TEST: partition by varchar(n)
select col1, col2, col3, col4, col5, rank() over(partition by col2) rank from rank_index order by 2, 1, 3;
--TEST: partition by nchar(n)
select col1, col2, col3, col4, col5, rank() over(partition by col3) rank from rank_index order by 3;
--TEST: partition by nchar varying
select col1, col2, col3, col4, col5, rank() over(partition by col4) rank from rank_index order by 4, 1, 2, 3;
--TEST: partition by string
select col1, col2, col3, col4, col5, rank() over(partition by col5) rank from rank_index order by 4, 1, 2, 3, 5;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, rank() over(order by col1) rank from rank_index order by 1, 2;
--TEST: order by 2 column names
select col2, col3, rank() over(order by col2, col3 asc) rank from rank_index order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, col5, rank() over(order by col1, col2 desc, col3, col4 asc, col5) rank from rank_index order by 1, 2, 3, 4, 5, 6;
--TEST: order by columns not selected
select col3, rank() over(order by col4 desc, col2, col1 asc) rank from rank_index order by 1, 2;
--TEST: order by 1 position
select col4, rank() over(order by 1) rank from rank_index order by 1, 2;
--TEST: order by 3 positions
select col3, col2, rank() over(order by 1, 2 desc, 3 asc) rank from rank_index order by 1, 2, 3;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, col5, rank() over(order by 3, 2 asc, 5 desc, 1 desc, 4) rank from rank_index order by 1, 2, 3, 4, 5, 6;
--TEST: order by positions not existed
select col2, rank() over(order by 2) rank from rank_index order by 1, 2;
select col1, rank() over(order by 3, 4, 1 desc) rank, col2, col4 from rank_index order by 1, 2;
select col3, col4, rank() over(order by 5) rank from rank_index order by 1, 2;
select col3, col1, rank() over(order by 100) rank from rank_index order by 1, 2;
--TEST: order by column names and positions
select col1, col2, col3, col4, col5, rank() over(order by 1, col2 desc, 3, col4 asc, 5 desc) rank from rank_index order by 1, 2, 3, 4, 5, 6;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by char(n)
select col1, col2, col3, rank() over(partition by col1 order by col1, col2, col3) from rank_index order by 1, 2, 3, 4;
--TEST: partition by varchar(n)
select col2, col4, col1, rank() over(partition by col2 order by col2, col4, col1 desc) from rank_index order by 1, 2, 3, 4;
--TEST: partition by nchar(n)
select col3, rank() over(partition by col3 order by col3) rank, col2 from rank_index order by 1, 2;
--TEST: partition by nchar varying
select col4, col1, rank() over(partition by col4 order by col1, col2 desc) rank from rank_index order by 1, 2, 3;
--TEST: partition by string
select col5, col2, col4, rank() over(partition by col5 order by col4, 1, 2 asc) from rank_index order by 1, 2, 3, 4;
--TEST: syntax error
select col1, col2, rank() over(order by col1, col2 partition by col2) from rank_index;



drop table rank_index; 















