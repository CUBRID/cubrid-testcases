--TEST: test with character string data types and normal syntax 


create table lag_string(
	col1 char(20),
	col2 varchar(100), 
	col3 nchar(10),
	col4 nchar varying,
	col5 string,
	col6 int
);


insert into lag_string values('aaaaa', 'This is a dog.', n'1990-1-1 1', n'1234', 'character', 1234);
insert into lag_string values('aaaaa', 'This is a cat.', n'1991-1-1 1', n'22222', 'character', 2345) ;
insert into lag_string values('aaaaa', 'This is a dog.', n'1992-1-1 1', n'87', 'character', 1111);
insert into lag_string values('aaaaa', 'This is a cat.', n'1993-1-1 1', n'888', 'character', 9999);
insert into lag_string values('aaaaa', 'This is a dog.', n'1994-1-1 1', n'999', 'character', 2345);
insert into lag_string values('eeeee', 'This is a cat.', n'1995-1-1 1', n'1222', 'character', 5678);
insert into lag_string values('eeeee', 'This is a dog.', n'1996-1-1 1', n'1234', 'character', 2345);
insert into lag_string values('eeeee', 'This is a dog.', n'1997-1-1 1', n'563', 'character', 1111);
insert into lag_string values('eeeee', 'This is a rabbit.', n'1998-1-1 1', n'111', 'character', 9999);
insert into lag_string values('ccccc', 'This is a dog.', n'1999-1-1 1', n'777', 'character', 5676);
insert into lag_string values('ccccc', 'This is a dog.', n'2000-1-1 1', n'9898', 'string', 5678);
insert into lag_string values('ccccc', 'This is a rabbit.', n'2001-1-1 1', n'1234', 'string', 2345);
insert into lag_string values('zzzzz', 'This is a dog.', n'2002-1-1 1', n'111', 'string', 1111);
insert into lag_string values('bbbbb', 'This is a dog.', n'2003-1-1 1', n'87', 'string', 9999);
insert into lag_string values('bbbbb', 'This is a cat.', n'2004-1-1 1', n'12356', 'string', 3333);
insert into lag_string values('bbbbb', 'This is a dog.', n'2005-1-1 1', n'3232', 'string', 1234);
insert into lag_string values('bbbbb', 'This is a dog.', n'2006-1-1 1', n'22222', 'string', 9999);
insert into lag_string values('bbbbb', 'This is a rabbit.', n'2007-1-1 1', n'999', 'string', 2345);
insert into lag_string values('bbbbb', 'This is a dog.', n'2008-1-1 1', n'87', 'string', 3456);
insert into lag_string values('bbbbb', 'This is a dog.', n'2009-1-1 1', n'111', 'string', 1818);

--TEST: OVER() clause
--TEST: char(n) 
select col3, lag(col3, 2) over() from (select * from lag_string order by 3);
--TEST: varchar(n), with alias+all
select col3, col5, lag(col5) over() from (select * from lag_string order by 3);
--TEST: nchar(n), with where clause
select col3, col1, lag(col1, 3, 'default') over() from (select * from lag_string where col1 > 'aaaaa' order by 3);
--TEST: nchar varying, distinct
select col3, col2, lag(col2) over() from (select * from lag_string order by 3);
--TEST: string
select col3, col4, lag(col4, 4, n'aaa') over() from (select * from lag_string order by 3);
select col3, col5, lag(col5) over() from (select * from  lag_string order by 3);
--TEST: syntax error
select col1, col3, col4, lag(col5) over from lag_string;
select col1, col3, col2, lag(col6) over(1) from lag_string;



--TEST: OVER(PARTITION BY) clause
--TEST: partition by char(n)
select col3, col1, col6, lag(col6, 1, 1000) over(partition by col1) from (select * from lag_string order by 3);
--TEST: partition by varchar(n)
select col3, col2, col5, lag(col5) over(partition by col2) from (select * from lag_string order by 3);
--TEST: partition by nchar(n)
select col3, col1, lag(col1, 3, 'zzz') over(partition by col3) from (select * from lag_string order by 3);
--TEST: partition by nchar varying
select col3, col4, col2, lag(col2, 10) over(partition by col4) from (select * from lag_string order by 3);
--TEST: partition by string
select col5, col3, lag(col3, 3, 'default') over(partition by col5) from (select * from lag_string order by 3);



--TEST: OVER(ORDER BY) clause
--TEST: order by 1 column name
select col1, lag(col3, 5) over(order by col1) from lag_string order by 1, 2;
--TEST: order by 2 column names
select col2, col3, lag(col5) over(order by col2, col3 asc) from lag_string order by 1, 2, 3;
--TEST: order by more than 2 column names
select col1, col2, col3, col4, col5, lag(col1, 3, 'aaa') over(order by col1, col2 desc, col3, col4 asc, col5) from lag_string order by 1, 2, 3, 4, 5, 6;
--TEST: order by columns not selected
select col3, lag(col2, 6, 'abc') over(order by col4 desc, col2, col1 asc) from lag_string order by 1, 2;
--TEST: order by 1 position
select col4, lag(col4, 20) over(order by 1) from lag_string order by 1, 2;
--TEST: order by 3 positions
select col3, col2, lag(col3, 3, n'aaa') over(order by 1, 2 desc, 3 asc) from lag_string order by 1, 2, 3;
--TEST: order by more than 3 positions
select col1, col2, col3, col4, col5, lag(col6) over(order by 3, 2 asc, 5 desc, 1 desc, 4) from lag_string order by 1, 2, 3, 4, 5, 6;
--TEST: order by positions not existed
select col2, lag(col5, 2, 'aaa') over(order by 2) from lag_string order by 1, 2;
select col1, lag(col6) over(order by 3, 4, 1 desc), col2, col4 from lag_string order by 1, 2;
select col3, col4, lag(col5) over(order by 5) from lag_string order by 1, 2;
select col3, col1, lag(col6) over(order by 100) from lag_string order by 1, 2;
--TEST: order by column names and positions
select col1, col2, col3, col4, col5, lag(col2, 3, 'zzz') over(order by 1, col2 desc, 3, col4 asc, 5 desc) from lag_string order by 1, 2, 3, 4, 5, 6;




--TEST: OVER(PARTITION BY ORDER BY) clause
--TEST: partition by char(n)
select col1, col2, col3, lag(col2) over(partition by col1 order by 1, 2, 3) from lag_string order by 1, 2, 3, 4;
--TEST: partition by varchar(n)
select col2, col4, col1, lag(col5, 10, '333') over(partition by col2 order by col2, col4, col1 desc) from lag_string order by 1, 2, 3, 4;
--TEST: partition by nchar(n)
select col3, lag(col1) over(partition by col3 order by 1, 3), col2 from lag_string order by 1, 2;
--TEST: partition by nchar varying
select col4, col1, lag(col2) over(partition by col4 order by 1, 2 desc) from lag_string order by 1, 2, 3;
--TEST: partition by string
select col5, col2, col4, lag(col3, 22, n'AAAA') over(partition by col5 order by col4, 1, 2 asc) from lag_string order by 1, 2, 3, 4;
--TEST: syntax error
select col1, col2, lag(col4) over(order by col1, col2 partition by col2) from lag_string;



drop table lag_string; 















