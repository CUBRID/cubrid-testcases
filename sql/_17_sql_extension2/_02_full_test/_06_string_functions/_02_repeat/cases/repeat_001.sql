--test all kinds of string types for the 1st and the 4th param



create table soo(
	col1 char(26),
	col2 varchar(25),
	col3 nchar(29),
	col4 nchar varying(30),
	col5 string
);



insert into soo values ('aaa,', 'bbb,', n'ccc,', n'ddd,', 'eee,');

--char(n)
select repeat(col1, 1) from soo;
--varchar(n)
select repeat(col2, 2) from soo;
--nchar(n)
select repeat(col3, 3) from soo;
--nchar varying(n)
select repeat(col4, 4) from soo;
--string
select repeat(col5, 5) from soo;


drop table soo;
