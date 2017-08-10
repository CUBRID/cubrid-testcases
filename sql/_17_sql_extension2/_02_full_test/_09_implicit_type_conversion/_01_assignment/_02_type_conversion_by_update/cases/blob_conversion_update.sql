--test implicit type conversion of blob type



create table blob_conversion(
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



insert into blob_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from blob_conversion;


--[er]datetime
update blob_conversion set col1 = bit_to_blob(B'1010111');
--[er]date
update blob_conversion set col2 = bit_to_blob(B'1010111');
--[er]time
update blob_conversion set col3 = bit_to_blob(B'1010111');
--[er]timestamp
update blob_conversion set col4 = bit_to_blob(B'1010111');
--[er]double
update blob_conversion set col5 = bit_to_blob(B'1010111');
--[er]float
update blob_conversion set col6 = bit_to_blob(B'1010111');
--[er]numeric
update blob_conversion set col7 = bit_to_blob(B'1010111');
--[er]bigint
update blob_conversion set col8 = bit_to_blob(B'1010111');
--[er]int
update blob_conversion set col9 = bit_to_blob(B'1010111');
--[er]short
update blob_conversion set col10 = bit_to_blob(B'1010111');
--[er]monetary
update blob_conversion set col11 = bit_to_blob(B'1010111');

--[er]bit
update blob_conversion set col12 = bit_to_blob(B'1010111');
--[er]varbit
update blob_conversion set col13 = bit_to_blob(B'1010111');
select col12, col13 from blob_conversion;

--[er]char
update blob_conversion set col14 = bit_to_blob(B'1010111');
--[er]varchar
update blob_conversion set col15 = bit_to_blob(B'1010111');
--[er]nchar
update blob_conversion set col16 = bit_to_blob(B'1010111');
--[er]varnchar
update blob_conversion set col17 = bit_to_blob(B'1010111');
--[er]set
update blob_conversion set col18 = bit_to_blob(B'1010111');
--[er]multiset
update blob_conversion set col19 = bit_to_blob(B'1010111');
--[er]list
update blob_conversion set col20 = bit_to_blob(B'1010111');
--[er]sequence
update blob_conversion set col21 = bit_to_blob(B'1010111');

--[nr]blob
update blob_conversion set col22 = bit_to_blob(B'1010111');
select blob_to_bit(col22) from blob_conversion;

--[er]clob
update blob_conversion set col23 = bit_to_blob(B'1010111');


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from blob_conversion;


delete from blob_conversion;
drop table blob_conversion;
	
