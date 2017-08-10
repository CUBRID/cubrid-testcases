--test all kinds of numeric types for the 2nd and more parameters


create table soo(
	col1 int,
	col2 smallint,
	col3 bigint,
	col4 numeric(7, 4),
	col5 float,
	col6 double,
	col7 monetary
);



insert into soo values (112, 223, -334, 444.4445, 555.56, 6666.667, 888.89);


select elt(1, col1, col2, col3, col4, col5, col6, col7) from soo;
select elt(2, col1, col2, col3, col4, col5, col6, col7) from soo;
select elt(3, col1, col2, col3, col4, col5, col6, col7) from soo;
select elt(4, col1, col2, col3, col4, col5, col6, col7) from soo;
select elt(5, col1, col2, col3, col4, col5, col6, col7) from soo;
select elt(6, col1, col2, col3, col4, col5, col6, col7) from soo;
select elt(7, col1, col2, col3, col4, col5, col6, col7) from soo;


drop table soo;
