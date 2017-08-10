--test all kinds of numeric types for the 2nd parameter



create table soo(
	col1 int,
	col2 smallint,
	col3 bigint,
	col4 numeric(7777777, 4),
	col5 float,
	col6 double,
	col7 monetary
);



insert into soo values (112, 223, -334, 444.4445, 555.56, 6666.667, 888.89);


--int
select repeat('aaa,', col1) from soo;
--smallint
select repeat('aaa,', col2) from soo;
--bigint
select repeat('aaa,', col3) from soo;
--numeric, TBD
select repeat('aaa,', col4) from soo;
--float, TBD
select repeat('aaa,', col5) from soo;
--double, TBD
select repeat('aaa,', col6) from soo;
--monetary
select repeat('aaa,', col7) from soo;


drop table soo;
