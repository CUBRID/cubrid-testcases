--test implicit type conversion of date type



create table date_conversion(
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


insert into date_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit    (col22),clob_to_char(col23) from date_conversion;


--[ok]datetime
update date_conversion set col1 = date'2010-11-08';
--[nr]date
update date_conversion set col2 = date'2010-11-08';
--[er]time
update date_conversion set col3 = date'2010-11-08';
--[ok]timestamp
update date_conversion set col4 = date'2010-11-08';
select col1, col2, col3, col4 from date_conversion;

--[er]double
update date_conversion set col5 = date'2010-11-08';
--[er]float
update date_conversion set col6 = date'2010-11-08';
--[er]numeric
update date_conversion set col7 = date'2010-11-08';
--[er]bigint
update date_conversion set col8 = date'2010-11-08';
--[er]int
update date_conversion set col9 = date'2010-11-08';
--[er]short
update date_conversion set col10 = date'2010-11-08';
--[er]monetary
update date_conversion set col11 = date'2010-11-08';
--[er]bit
update date_conversion set col12 = date'2010-11-08';
--[er]varbit
update date_conversion set col13 = date'2010-11-08';

--[ok]char
update date_conversion set col14 = date'2010-11-08';
--[ok]varchar
update date_conversion set col15 = date'2010-11-08';
--[ok]nchar
update date_conversion set col16 = date'2010-11-08';
--[ok]varnchar
update date_conversion set col17 = date'2010-11-08';
select col14, col15, col16, col17 from date_conversion;

--[er]set
update date_conversion set col18 = date'2010-11-08';
--[er]multiset
update date_conversion set col19 = date'2010-11-08';
--[er]list
update date_conversion set col20 = date'2010-11-08';
--[er]sequence
update date_conversion set col21 = date'2010-11-08';
--[er]blob
update date_conversion set col22 = date'2010-11-08';
--[er]clob
update date_conversion set col23 = date'2010-11-08';


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit        (col22),clob_to_char(col23) from date_conversion;


delete from date_conversion;
drop table date_conversion;
	
