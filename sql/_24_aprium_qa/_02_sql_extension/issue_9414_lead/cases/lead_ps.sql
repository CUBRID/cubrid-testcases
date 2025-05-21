--TEST: test with character string data types and normal syntax 


create table lead_str(
	col1 char(20),
	col2 varchar(100), 
	col3 nchar(10),
	col4 nchar varying,
	col5 string
);


insert into lead_str values('aaaaa', 'This is a dog.', n'1990-1-1 1', n'cubrid', 'character');
insert into lead_str values('aaaaa', 'This is a cat.', n'1991-1-1 1', n'cubrid', 'character');
insert into lead_str values('aaaaa', 'This is a dog.', n'1992-1-1 1', n'cubrid', 'character');
insert into lead_str values('aaaaa', 'This is a cat.', n'1993-1-1 1', n'mysql', 'character');
insert into lead_str values('aaaaa', 'This is a dog.', n'1994-1-1 1', n'mysql', 'character');
insert into lead_str values('eeeee', 'This is a cat.', n'1995-1-1 1', n'mysql', 'character');
insert into lead_str values('eeeee', 'This is a dog.', n'1996-1-1 1', n'mysql', 'character');
insert into lead_str values('eeeee', 'This is a dog.', n'1997-1-1 1', n'mysql', 'character');
insert into lead_str values('eeeee', 'This is a rabbit.', n'1998-1-1 1', n'mysql', 'character');
insert into lead_str values('ccccc', 'This is a dog.', n'1999-1-1 1', n'mysql', 'character');
insert into lead_str values('ccccc', 'This is a dog.', n'2000-1-1 1', n'cubrid', 'string');
insert into lead_str values('ccccc', 'This is a rabbit.', n'2001-1-1 1', n'cubrid', 'string');
insert into lead_str values('zzzzz', 'This is a dog.', n'2002-1-1 1', n'cubrid', 'string');
insert into lead_str values('bbbbb', 'This is a dog.', n'2003-1-1 1', n'cubrid', 'string');
insert into lead_str values('bbbbb', 'This is a cat.', n'2004-1-1 1', n'oracle', 'string');
insert into lead_str values('bbbbb', 'This is a dog.', n'2005-1-1 1', n'oracle', 'string');
insert into lead_str values('bbbbb', 'This is a dog.', n'2006-1-1 1', n'oracle', 'string');
insert into lead_str values('bbbbb', 'This is a rabbit.', n'2007-1-1 1', n'oracle', 'string');
insert into lead_str values('bbbbb', 'This is a dog.', n'2008-1-1 1', n'cubrid', 'string');
insert into lead_str values('bbbbb', 'This is a dog.', n'2009-1-1 1', n'cubrid', 'string');


--TEST: over() clause, with where clause
prepare st from 'select  *, lead(col1, ?, ?) over() next_v from lead_str where col2 = ? order by 1';
execute st using 2, 'This is a dog.';
deallocate prepare st;

--TEST: OVER(PARTITION BY) clause
prepare st from 'select new.col1, new.col2, new.col3, new.col4, new.col5, lead(new.col2, ?) over(partition by new.col1) next_v from (select * from lead_str order by 1,2,3,4,5) new order by 1';
execute st using 3;
deallocate prepare st;

--TEST: OVER(ORDER BY) clause
prepare st from 'select col2, lead(col3, ?, ?) over(order by 1) next_v from lead_str where col5 in (?) order by 1, 2';
execute st using 4, n'string';
deallocate prepare st;

--TEST: OVER(PARTITION BY ORDER BY) clause
prepare st from 'select col1, col2, col3, lead(col4, ?) over(partition by col1 order by col1, col2, col3) next_v from lead_str order by 1, 2, 3, 4';
execute st using 3;
deallocate prepare st;


drop table lead_str; 















