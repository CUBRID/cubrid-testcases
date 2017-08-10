--test all kinds of numeric types for the 3rd parameter


create table soo(
	col1 int,
	col2 smallint,
	col3 bigint,
	col4 numeric(6, 4),
	col5 float,
	col6 double,
	col7 monetary
);

insert into soo values (-2, 2, -2, 2.1234, 2.123123123123, -2.12341234, 2);


--combination of integer and all the numeric types
select substring_index('123123123', 2, col1) from soo;
select substring_index('123123123', 2, col2) from soo;
select substring_index('123123123', 2, col3) from soo;
select substring_index('123123123', 2, col4) from soo;
select substring_index('123123123', 2, col5) from soo;
select substring_index('123123123', 2, col6) from soo;
select substring_index('123123123', 2, col7) from soo;


drop table soo;
