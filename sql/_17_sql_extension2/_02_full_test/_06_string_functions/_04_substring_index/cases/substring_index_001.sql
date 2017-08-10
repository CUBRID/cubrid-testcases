--test all kinds of string types for the first 2 params



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



insert into soo values ('aaa,bbb,ccc,ddd,eee,fff', 'aaa,bbb,ccc,ddd,eee,fff', n'aaa,bbb,ccc,ddd,eee,fff', n'aaa,bbb,ccc,ddd,eee,fff', 'aaa,bbb,ccc,ddd,eee,fff',
			',', ',', n',', n',', ',');


--combination of char(n) and all the character string types
select substring_index(col1, col6, 1) from soo;
select substring_index(col1, col7, 2) from soo;
select substring_index(col1, col8, 3) from soo;
select substring_index(col1, col9, 4) from soo;
select substring_index(col1, col10, 5) from soo;


--combination of varchar(n) and all the character string types
select substring_index(col2, col6, -1) from soo;
select substring_index(col2, col7, -2) from soo;
select substring_index(col2, col8, -3) from soo;
select substring_index(col2, col9, -4) from soo;
select substring_index(col2, col10, -5) from soo;


--combination of nchar(n) and all the character string types
select substring_index(col3, col6, 1) from soo;
select substring_index(col3, col7, 2) from soo;
select substring_index(col3, col8, 3) from soo;
select substring_index(col3, col9, 4) from soo;
select substring_index(col3, col10, 5) from soo;


--combination of nchar varying(n) and all the character string types
select substring_index(col4, col6, -1) from soo;
select substring_index(col4, col7, -2) from soo;
select substring_index(col4, col8, -3) from soo;
select substring_index(col4, col9, -4) from soo;
select substring_index(col4, col10, -5) from soo;


--combination of string and all the character string types
select substring_index(col5, col6, 1) from soo;
select substring_index(col5, col7, 2) from soo;
select substring_index(col5, col8, 3) from soo;
select substring_index(col5, col9, 4) from soo;
select substring_index(col5, col10, 5) from soo;


drop table soo;
