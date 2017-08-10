--test implicit type conversion of timestamp type



create table timestamp_conversion(
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
	col15 varchar(30),
	col16 nchar(30),
	col17 nchar varying(30),
	col18 set,
	col19 multiset,
	col20 list,
	col21 sequence,
	col22 blob,
	col23 clob
);


insert into timestamp_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from timestamp_conversion;


--[ok]datetime
update timestamp_conversion set col1 = timestamp'2010-11-08 16:47:22 PM';
--[ok]date
update timestamp_conversion set col2 = timestamp'2010-11-08 16:47:22 PM';
--[ok]time
update timestamp_conversion set col3 = timestamp'2010-11-08 16:47:22 PM';
--[nr]timestamp
update timestamp_conversion set col4 = timestamp'2010-11-08 16:47:22 PM';
select col1, col2, col3, col4 from timestamp_conversion;

--[er]double
update timestamp_conversion set col5 = timestamp'2010-11-08 16:47:22 PM';
--[er]float
update timestamp_conversion set col6 = timestamp'2010-11-08 16:47:22 PM';
--[er]numeric
update timestamp_conversion set col7 = timestamp'2010-11-08 16:47:22 PM';
--[er]bigint
update timestamp_conversion set col8 = timestamp'2010-11-08 16:47:22 PM';
--[er]int
update timestamp_conversion set col9 = timestamp'2010-11-08 16:47:22 PM';
--[er]short
update timestamp_conversion set col10 = timestamp'2010-11-08 16:47:22 PM';
--[er]monetary
update timestamp_conversion set col11 = timestamp'2010-11-08 16:47:22 PM';
--[er]bit
update timestamp_conversion set col12 = timestamp'2010-11-08 16:47:22 PM';
--[er]varbit
update timestamp_conversion set col13 = timestamp'2010-11-08 16:47:22 PM';

--[ok]char
update timestamp_conversion set col14 = timestamp'2010-11-08 16:47:22 PM';
--[ok]varchar
update timestamp_conversion set col15 = timestamp'2010-11-08 16:47:22 PM';
--[ok]nchar
update timestamp_conversion set col16 = timestamp'2010-11-08 16:47:22 PM';
--[ok]varnchar
update timestamp_conversion set col17 = timestamp'2010-11-08 16:47:22 PM';
select col14, col15, col16, col17 from timestamp_conversion; 

--[er]set
update timestamp_conversion set col18 = timestamp'2010-11-08 16:47:22 PM';
--[er]multiset
update timestamp_conversion set col19 = timestamp'2010-11-08 16:47:22 PM';
--[er]list
update timestamp_conversion set col20 = timestamp'2010-11-08 16:47:22 PM';
--[er]sequence
update timestamp_conversion set col21 = timestamp'2010-11-08 16:47:22 PM';
--[er]blob
update timestamp_conversion set col22 = timestamp'2010-11-08 16:47:22 PM';
--[er]clob
update timestamp_conversion set col23 = timestamp'2010-11-08 16:47:22 PM';


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from timestamp_conversion;


delete from timestamp_conversion;
drop table timestamp_conversion;
	
