--test all kinds of numeric types for the 1st and the 4th parameter



create table soo(
	col1 int,
	col2 smallint,
	col3 bigint,
	col4 numeric(9, 4),
	col5 float,
	col6 double,
	col7 monetary,
	col8 integer,
	col9 short,
	col10 bigint,
	col11 decimal,
	col12 real,
	col13 double precision,
	col14 monetary
);



insert into soo values (-123123123, 12312, -123123123123123123, 12312.1234, 123.123123123123, -123123.12341234, 123123123,
			44444, -4444, 44444, 4.4444, 44.44, -4444, 44444);


--combination of integer and all the numeric types
select insert(col1, 3, 6, col8) from soo;
select insert(col1, 3, 6, col9) from soo;
select insert(col1, 3, 6, col10) from soo;
select insert(col1, 3, 6, col11) from soo;
select insert(col1, 3, 6, col12) from soo;
select insert(col1, 3, 6, col13) from soo;
select insert(col1, 3, 6, col14) from soo;


--combination of smallint and all the numeric types
select insert(col2, 3, 6, col8) from soo;
select insert(col2, 3, 6, col9) from soo;
select insert(col2, 3, 6, col10) from soo;
select insert(col2, 3, 6, col11) from soo;
select insert(col2, 3, 6, col12) from soo;
select insert(col2, 3, 6, col13) from soo;
select insert(col2, 3, 6, col14) from soo;


--combination of bigint and all the numeric types
select insert(col3, 3, 6, col8) from soo;
select insert(col3, 3, 6, col9) from soo;
select insert(col3, 3, 6, col10) from soo;
select insert(col3, 3, 6, col11) from soo;
select insert(col3, 3, 6, col12) from soo;
select insert(col3, 3, 6, col13) from soo;
select insert(col3, 3, 6, col14) from soo;


--combination of numeric and all the numeric types
select insert(col4, 3, 6, col8) from soo;
select insert(col4, 3, 6, col9) from soo;
select insert(col4, 3, 6, col10) from soo;
select insert(col4, 3, 6, col11) from soo;
select insert(col4, 3, 6, col12) from soo;
select insert(col4, 3, 6, col13) from soo;
select insert(col4, 3, 6, col14) from soo;


--combination of folat and all the numeric types
select insert(col5, 3, 6, col8) from soo;
select insert(col5, 3, 6, col9) from soo;
select insert(col5, 3, 6, col10) from soo;
select insert(col5, 3, 6, col11) from soo;
select insert(col5, 3, 6, col12) from soo;
select insert(col5, 3, 6, col13) from soo;
select insert(col5, 3, 6, col14) from soo;


--combination of double and all the numeric types
select insert(col6, 3, 6, col8) from soo;
select insert(col6, 3, 6, col9) from soo;
select insert(col6, 3, 6, col10) from soo;
select insert(col6, 3, 6, col11) from soo;
select insert(col6, 3, 6, col12) from soo;
select insert(col6, 3, 6, col13) from soo;
select insert(col6, 3, 6, col14) from soo;


--combination of monetary and all the numeric types
select insert(col7, 3, 6, col8) from soo;
select insert(col7, 3, 6, col9) from soo;
select insert(col7, 3, 6, col10) from soo;
select insert(col7, 3, 6, col11) from soo;
select insert(col7, 3, 6, col12) from soo;
select insert(col7, 3, 6, col13) from soo;
select insert(col7, 3, 6, col14) from soo;


drop table soo;
