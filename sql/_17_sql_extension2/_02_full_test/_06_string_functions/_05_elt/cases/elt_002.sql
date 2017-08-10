--test all kinds of string types for the 2nd and more parameters


create table soo(
	col1 char(26),
	col2 varchar(25),
	col3 nchar(29),
	col4 nchar varying(30),
	col5 string
);



insert into soo values ('aaa,', 'bbb,', n'ccc,', n'ddd,', 'eee,');

select elt(1, col1, col2, col3, col4, col5) from soo;
select elt(2, col1, col2, col3, col4, col5) from soo;
select elt(3, col1, col2, col3, col4, col5) from soo;
select elt(4, col1, col2, col3, col4, col5) from soo;
select elt(5, col1, col2, col3, col4, col5) from soo;


select elt(1, col1, col2, col5) from soo;
select elt(3, col3, col4, col5) from soo;


drop table soo;
