--test all kinds of numeric types for the 1st and the 4th parameter



create table soo(
	col1 int,
	col2 smallint,
	col3 bigint,
	col4 numeric(6, 4),
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



insert into soo values (3, 3, 3, 3.2222, 2.78917289483, 3.1234556, 3,
			6, 6, 6, 6.3214, 5.66666666666, 6.2341123, 6);


--combination of integer and all the numeric types
select insert('aaa-bbb-ccc-ddd', col1, col8, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col1, col9, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col1, col10, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col1, col11, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col1, col12, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col1, col13, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col1, col14, 'XXXXXXXXXX') from soo;


--combination of smallint and all the numeric types
select insert('aaa-bbb-ccc-ddd', col2, col8, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col2, col9, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col2, col10, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col2, col11, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col2, col12, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col2, col13, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col2, col14, 'XXXXXXXXXX') from soo;


--combination of bigint and all the numeric types
select insert('aaa-bbb-ccc-ddd', col3, col8, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col3, col9, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col3, col10, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col3, col11, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col3, col12, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col3, col13, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col3, col14, 'XXXXXXXXXX') from soo;


--combination of numeric and all the numeric types
select insert('aaa-bbb-ccc-ddd', col4, col8, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col4, col9, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col4, col10, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col4, col11, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col4, col12, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col4, col13, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col4, col14, 'XXXXXXXXXX') from soo;


--combination of folat and all the numeric types
select insert('aaa-bbb-ccc-ddd', col5, col8, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col5, col9, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col5, col10, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col5, col11, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col5, col12, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col5, col13, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col5, col14, 'XXXXXXXXXX') from soo;


--combination of double and all the numeric types
select insert('aaa-bbb-ccc-ddd', col6, col8, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col6, col9, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col6, col10, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col6, col11, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col6, col12, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col6, col13, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col6, col14, 'XXXXXXXXXX') from soo;


--combination of monetary and all the numeric types
select insert('aaa-bbb-ccc-ddd', col7, col8, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col7, col9, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col7, col10, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col7, col11, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col7, col12, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col7, col13, 'XXXXXXXXXX') from soo;
select insert('aaa-bbb-ccc-ddd', col7, col14, 'XXXXXXXXXX') from soo;


drop table soo;
