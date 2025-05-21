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


--TEST: over() clause, with where clause
prepare st from 'select  new.*, ntile(?) over() b_num from (select * from ntile_str order by 1,2,3,4,5) new where new.col2 = ? order by 1';
execute st using 6, 'This is a dog.';
deallocate prepare st;

--TEST: OVER(PARTITION BY) clause
prepare st from 'select new.col1, new.col2, new.col3, new.col4, new.col5, ntile(?) over(partition by new.col1) b_num from (select * from ntile_str order by 1,2,3,4,5) new order by 1';
execute st using 5;
deallocate prepare st;

--TEST: OVER(ORDER BY) clause
prepare st from 'select col2, ntile(?) over(order by 1) b_num from ntile_str where col5 in (?) order by 1, 2';
execute st using 4, 'string';
deallocate prepare st;

--TEST: OVER(PARTITION BY ORDER BY) clause
prepare st from 'select col1, col2, col3, ntile(?) over(partition by col1 order by col1, col2, col3) b_num from ntile_str order by 1, 2, 3, 4';
execute st using 3;
deallocate prepare st;


drop table ntile_str; 















