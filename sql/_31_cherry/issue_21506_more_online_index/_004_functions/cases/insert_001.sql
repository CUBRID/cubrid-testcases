--test all kinds of string types for the 1st and the 4th param

drop table if exists soo;

create table soo(
	col1 char(26),
	col2 varchar(25),
	col3 nchar(29),
	col4 nchar varying(30),
	col5 string,
	col6 char(22),
	col7 varchar(28),
	col8 nchar(12),
	col9 nchar varying(18),
	col10 string
);

create index aa on soo(col1,col2,col3,col4,col5,col6,col7,col8,col9,col10) with online;

insert into soo values ('aaa,bbb,ccc,ddd,eee,fff', 'aaa,bbb,ccc,ddd,eee,fff', n'aaa,bbb,ccc,ddd,eee,fff', n'aaa,bbb,ccc,ddd,eee,fff', 'aaa,bbb,ccc,ddd,eee,fff',
			'VVVVVVVVVV', 'VVVVVVVVVV', n'VVVVVVVVVV', n'VVVVVVVVVV', 'VVVVVVVVVV');


--combination of char(n) and all the character string types
select insert(col1, 4, 4, col6) from soo;
select insert(col1, 4, 4, col7) from soo;
select insert(col1, 4, 4, col8) from soo;
select insert(col1, 4, 4, col9) from soo;
select insert(col1, 4, 4, col10) from soo;


--combination of varchar(n) and all the character string types
select insert(col2, 4, 8, col6) from soo;
select insert(col2, 4, 8, col7) from soo;
select insert(col2, 4, 8, col8) from soo;
select insert(col2, 4, 8, col9) from soo;
select insert(col2, 4, 8, col10) from soo;


--combination of nchar(n) and all the character string types
select insert(col3, 1, 10, col6) from soo;
select insert(col3, 1, 10, col7) from soo;
select insert(col3, 1, 10, col8) from soo;
select insert(col3, 1, 10, col9) from soo;
select insert(col3, 1, 10, col10) from soo;


--combination of nchar varying(n) and all the character string types
select insert(col4, 8, 0, col6) from soo;
select insert(col4, 8, 0, col7) from soo;
select insert(col4, 8, 0, col8) from soo;
select insert(col4, 8, 0, col9) from soo;
select insert(col4, 8, 0, col10) from soo;


--combination of string and all the character string types
select insert(col5, 10, 2, col6) from soo;
select insert(col5, 10, 2, col7) from soo;
select insert(col5, 10, 2, col8) from soo;
select insert(col5, 10, 2, col9) from soo;
select insert(col5, 10, 2, col10) from soo;


drop table soo;
