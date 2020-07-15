--TEST: test with character string data types and normal syntax 


create table ntile_str(
	col1 char(20),
	col2 varchar(100), 
	col3 nchar(10),
	col4 nchar varying,
	col5 string
);


insert into ntile_str values('aaaaa', 'This is a dog.', n'1990-1-1 1', n'cubrid', 'character');
insert into ntile_str values('aaaaa', 'This is a cat.', n'1991-1-1 1', n'cubrid', 'character');
insert into ntile_str values('aaaaa', 'This is a dog.', n'1992-1-1 1', n'cubrid', 'character');
insert into ntile_str values('aaaaa', 'This is a cat.', n'1993-1-1 1', n'mysql', 'character');
insert into ntile_str values('aaaaa', 'This is a dog.', n'1994-1-1 1', n'mysql', 'character');
insert into ntile_str values('eeeee', 'This is a cat.', n'1995-1-1 1', n'mysql', 'character');
insert into ntile_str values('eeeee', 'This is a dog.', n'1996-1-1 1', n'mysql', 'character');
insert into ntile_str values('eeeee', 'This is a dog.', n'1997-1-1 1', n'mysql', 'character');
insert into ntile_str values('eeeee', 'This is a rabbit.', n'1998-1-1 1', n'mysql', 'character');
insert into ntile_str values('ccccc', 'This is a dog.', n'1999-1-1 1', n'mysql', 'character');
insert into ntile_str values('ccccc', 'This is a dog.', n'2000-1-1 1', n'cubrid', 'string');
insert into ntile_str values('ccccc', 'This is a rabbit.', n'2001-1-1 1', n'cubrid', 'string');
insert into ntile_str values('zzzzz', 'This is a dog.', n'2002-1-1 1', n'cubrid', 'string');
insert into ntile_str values('bbbbb', 'This is a dog.', n'2003-1-1 1', n'cubrid', 'string');
insert into ntile_str values('bbbbb', 'This is a cat.', n'2004-1-1 1', n'oracle', 'string');
insert into ntile_str values('bbbbb', 'This is a dog.', n'2005-1-1 1', n'oracle', 'string');
insert into ntile_str values('bbbbb', 'This is a dog.', n'2006-1-1 1', n'oracle', 'string');
insert into ntile_str values('bbbbb', 'This is a rabbit.', n'2007-1-1 1', n'oracle', 'string');
insert into ntile_str values('bbbbb', 'This is a dog.', n'2008-1-1 1', n'cubrid', 'string');
insert into ntile_str values('bbbbb', 'This is a dog.', n'2009-1-1 1', n'cubrid', 'string');


--TEST: OVER() clause
--TEST: no alias
select  new.col1, new.col2, ntile(5) over() b_num from (select * from ntile_str order by 1,2,3,4,5) new order by 1;
--TEST: with where clause
select  new.col3, new.col4, ntile(6) over() b_num from (select * from ntile_str order by 1,2,3,4,5) new where new.col1 > 'aaaaa' order by 1;
select  new.*, ntile(9) over() b_num from (select * from ntile_str order by 1,2,3,4,5) new where new.col2 = 'This is a dog.' order by 1;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by char(n)
select new.col1, new.col2, new.col3, new.col4, new.col5, ntile(6) over(partition by new.col1) b_num from (select * from ntile_str order by 1,2,3,4,5) new order by 1, 2, 3, 4;
--TEST: partition by varchar(n)
select new.col1, new.col2, new.col3, new.col4, new.col5, ntile(4) over(partition by new.col2) b_num from (select * from ntile_str order by 1,2,3,4,5) new order by 1, 2, 3, 4;
--TEST: partition by nchar(n)
select col1, col2, col3, col4, col5, ntile(10) over(partition by col3) b_num from ntile_str order by 1, 2, 3, 4;
--TEST: partition by nchar varying
select new.col1, new.col2, new.col3, new.col4, new.col5, ntile(2) over(partition by new.col4) b_num from (select * from ntile_str order by 1,2,3,4,5) new order by 1, 2, 3, 4;
--TEST: partition by string
select new.col1, new.col2, new.col3, new.col4, new.col5, ntile(5) over(partition by new.col5) b_num from (select * from ntile_str order by 1,2,3,4,5) new order by 1, 2, 3, 4;



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, ntile(22) over(order by col1) b_num from ntile_str order by 1, 2;
--TEST: order by 2 column names
select col2, col3, ntile(12) over(order by col2, col3 asc) b_num from ntile_str order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, col5, ntile(2) over(order by col1, col2 desc, col3, col4 asc, col5) b_num from ntile_str order by 1, 2, 3, 4, 5, 6;
--TEST: order by columns not selected
select col3, ntile(3) over(order by col4 desc, col2, col1 asc) b_num from ntile_str order by 1, 2;
--TEST: order by 1 position
select col4, ntile(8) over(order by 1) b_num from ntile_str order by 1, 2;
--TEST: order by 3 positions
select col3, col2, ntile(14) over(order by 1, 2 desc, 3 asc) b_num from ntile_str order by 1, 2, 3;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, col5, ntile(88) over(order by 3, 2 asc, 5 desc, 1 desc, 4) b_num from ntile_str order by 1, 2, 3, 4, 5, 6;
--TEST: order by positions not existed
select col2, ntile(4) over(order by 2) b_num from ntile_str order by 1, 2;
select col1, ntile(3) over(order by 3, 4, 1 desc) b_num, col2, col4 from ntile_str order by 1, 2;
select col3, col4, ntile(2) over(order by 5) b_num from ntile_str order by 1, 2;
select col3, col1, ntile(1) over(order by 100) b_num from ntile_str order by 1, 2;
--TEST: order by column names and positions
select col1, col2, col3, col4, col5, ntile(5) over(order by 1, col2 desc, 3, col4 asc, 5 desc) b_num from ntile_str order by 1, 2, 3, 4, 5, 6;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by char(n)
select col1, col2, col3, ntile(3) over(partition by col1 order by col1, col2, col3) from ntile_str order by 1, 2, 3, 4;
--TEST: partition by varchar(n)
select col2, col4, col1, ntile(3) over(partition by col2 order by col2, col4, col1 desc) from ntile_str order by 1, 2, 3, 4;
--TEST: partition by nchar(n)
select col3, ntile(4) over(partition by col3 order by col4) b_num, col2 from ntile_str order by 1, 2;
--TEST: partition by nchar varying
select col4, col1, ntile(3) over(partition by col4 order by col1, col2 desc) b_num from ntile_str order by 1, 2, 3;
--TEST: partition by string
select col5, col2, col4, ntile(2) over(partition by col5 order by col4, 1, 2 asc) from ntile_str order by 1, 2, 3, 4;
--TEST: syntax error
select col1, col2, ntile(10) over(order by col1, col2 partition by col2) from ntile_str;



drop table ntile_str; 















