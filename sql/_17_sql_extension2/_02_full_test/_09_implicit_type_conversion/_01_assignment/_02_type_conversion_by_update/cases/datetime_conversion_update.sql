--test implicit type conversion of datetime type



create table datetime_conversion(
	col1 datetime,
	col2 date,
	col3 time,
	col4 timestamp,
	col5 double,
	col6 float,
	col7 numeric,
	col8 bigint,
	col9 int,
	col10 short,
	col11 monetary,
	col12 bit(30),
	col13 bit varying,
	col14 char(30),
	col15 varchar,
	col16 nchar(30),
	col17 nchar varying,
	col18 set,
	col19 multiset,
	col20 list,
	col21 sequence,
	col22 blob,
	col23 clob
);


insert into datetime_conversion values (
	datetime'11/09/2010 14:40:22.222',
	date'2010-11-9',
	time'14:40:44',
	timestamp'11/09/2010 14:40:22 PM',
	1234.56789,
	1234.567,
	1234.55555,
	12345678999,
	12345,
	123,
	12345.67,
	B'1010111',
	b'1100101',
	'abc',
	'aabbcc',
	n'abc',
	n'aabbcc',
	{1,2,3,4,5},
	{1,2,3,4,5},
	{1,2,3,4,5},
	{1,2,3,4,5},
	bit_to_blob(X'aabbc'),
	char_to_clob('aabbcc')
);


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit    (col22),clob_to_char(col23) from datetime_conversion;


--[nr]datetime
update datetime_conversion set col1 = datetime'11/08/2010 16:10:22.123';
--[ok]date
update datetime_conversion set col2 = datetime'11/08/2010 16:10:22.123';
--[ok]time
update datetime_conversion set col3 = datetime'11/08/2010 16:10:22.123';
--[ok]timestamp
update datetime_conversion set col4 = datetime'11/08/2010 16:10:22.123';
select col1, col2, col3, col4 from datetime_conversion;

--[er]double
update datetime_conversion set col5 = datetime'11/08/2010 16:10:22.123';
--[er]float
update datetime_conversion set col6 = datetime'11/08/2010 16:10:22.123';
--[er]numeric
update datetime_conversion set col7 = datetime'11/08/2010 16:10:22.123';
--[er]bigint
update datetime_conversion set col8 = datetime'11/08/2010 16:10:22.123';
--[er]int
update datetime_conversion set col9 = datetime'11/08/2010 16:10:22.123';
--[er]short
update datetime_conversion set col10 = datetime'11/08/2010 16:10:22.123';
--[er]monetary
update datetime_conversion set col11 = datetime'11/08/2010 16:10:22.123';
--[er]bit
update datetime_conversion set col12 = datetime'11/08/2010 16:10:22.123';
--[er]varbit
update datetime_conversion set col13 = datetime'11/08/2010 16:10:22.123';

--[ok]char
update datetime_conversion set col14 = datetime'11/08/2010 16:10:22.123';
--[ok]varchar
update datetime_conversion set col15 = datetime'11/08/2010 16:10:22.123';
--[ok]nchar
update datetime_conversion set col16 = datetime'11/08/2010 16:10:22.123';
--[ok]varnchar
update datetime_conversion set col17 = datetime'11/08/2010 16:10:22.123';
select col14, col15, col16, col17 from datetime_conversion;

--[er]set
update datetime_conversion set col18 = datetime'11/08/2010 16:10:22.123';
--[er]multiset
update datetime_conversion set col19 = datetime'11/08/2010 16:10:22.123';
--[er]list
update datetime_conversion set col20 = datetime'11/08/2010 16:10:22.123';
--[er]sequence
update datetime_conversion set col21 = datetime'11/08/2010 16:10:22.123';
--[er]blob
update datetime_conversion set col22 = datetime'11/08/2010 16:10:22.123';
--[er]clob
update datetime_conversion set col23 = datetime'11/08/2010 16:10:22.123';


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from datetime_conversion;


delete from datetime_conversion;
drop table datetime_conversion;
	
