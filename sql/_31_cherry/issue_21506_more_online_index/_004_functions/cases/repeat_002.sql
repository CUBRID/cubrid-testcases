--test all kinds of numeric types for the 1st parameter



create table soo(
	col1 int,
	col2 smallint,
	col3 bigint,
	col4 numeric(7, 4),
	col5 float,
	col6 double,
	col7 monetary
);

create index aa on soo(col1,col2,col3,col4,col5,col6,col7) with online;

insert into soo values (112, 223, -334, 444.4445, 555.56, 6666.667, 888.89);


--int
select repeat(col1, 3) from soo;
--smallint
select repeat(col2, 3) from soo;
--bigint
select repeat(col3, 3) from soo;
--numeric
select repeat(col4, 3) from soo;
--float
select repeat(col5, 3) from soo;
--double
select repeat(col6, 3) from soo;
--monetary
select repeat(col7, 3) from soo;


drop table soo;
