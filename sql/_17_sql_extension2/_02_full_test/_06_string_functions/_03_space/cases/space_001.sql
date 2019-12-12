--test all kinds of numeric types



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


--int
select space(col1) from soo;
--smallint
select space(col2) from soo;
--bigint
select space(col3) from soo;
--numeric
select space(col4) from soo;
--float
select space(col5) from soo;
--double
select space(col6) from soo;
--monetary
select space(col7) from soo;


drop table soo;
