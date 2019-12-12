--test all kinds of numeric types for the first 2 params



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
			3, 2, 123, 2.1234, 3.1, -12, 2);


--combination of integer and all the numeric types
select substring_index(col1, col8, 1) from soo;
select substring_index(col1, col9, 2) from soo;
select substring_index(col1, col10, -1) from soo;
select substring_index(col1, col11, -2) from soo;
select substring_index(col1, col12, 1) from soo;
select substring_index(col1, col13, 2) from soo;
select substring_index(col1, col14, -1) from soo;


--combination of smallint and all the numeric types
select substring_index(col2, col8, 1) from soo;
select substring_index(col2, col9, 2) from soo;
select substring_index(col2, col10, -1) from soo;
select substring_index(col2, col11, -2) from soo;
select substring_index(col2, col12, 1) from soo;
select substring_index(col2, col13, 2) from soo;
select substring_index(col2, col14, -1) from soo;


--combination of bigint and all the numeric types
select substring_index(col3, col8, 1) from soo;
select substring_index(col3, col9, 2) from soo;
select substring_index(col3, col10, -1) from soo;
select substring_index(col3, col11, -2) from soo;
select substring_index(col3, col12, 1) from soo;
select substring_index(col3, col13, 2) from soo;
select substring_index(col3, col14, -1) from soo;


--combination of numeric and all the numeric types
select substring_index(col4, col8, 1) from soo;
select substring_index(col4, col9, 2) from soo;
select substring_index(col4, col10, -1) from soo;
select substring_index(col4, col11, -2) from soo;
select substring_index(col4, col12, 1) from soo;
select substring_index(col4, col13, 2) from soo;
select substring_index(col4, col14, -1) from soo;


--combination of folat and all the numeric types
select substring_index(col5, col8, 1) from soo;
select substring_index(col5, col9, 2) from soo;
select substring_index(col5, col10, -1) from soo;
select substring_index(col5, col11, -2) from soo;
select substring_index(col5, col12, 1) from soo;
select substring_index(col5, col13, 2) from soo;
select substring_index(col5, col14, -1) from soo;


--combination of double and all the numeric types
select substring_index(col6, col8, 1) from soo;
select substring_index(col6, col9, 2) from soo;
select substring_index(col6, col10, -1) from soo;
select substring_index(col6, col11, -2) from soo;
select substring_index(col6, col12, 1) from soo;
select substring_index(col6, col13, 2) from soo;
select substring_index(col6, col14, -1) from soo;


--combination of monetary and all the numeric types
select substring_index(col7, col8, 1) from soo;
select substring_index(col7, col9, 2) from soo;
select substring_index(col7, col10, -1) from soo;
select substring_index(col7, col11, -2) from soo;
select substring_index(col7, col12, 1) from soo;
select substring_index(col7, col13, 2) from soo;
select substring_index(col7, col14, -1) from soo;


drop table soo;
