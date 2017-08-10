--test implicit type conversion of bit type



create table bit_conversion(
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


insert into bit_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from bit_conversion;


--[er]datetime
update bit_conversion set col1 = cast(B'1010111' as bit(10));
--[er]date
update bit_conversion set col2 = cast(B'1010111' as bit(10));
--[er]time
update bit_conversion set col3 = cast(B'1010111' as bit(10));
--[er]timestamp
update bit_conversion set col4 = cast(B'1010111' as bit(10));

--[er]double
update bit_conversion set col5 = cast(B'1010111' as bit(10));
--[er]float
update bit_conversion set col6 = cast(B'1010111' as bit(10));
--[er]numeric
update bit_conversion set col7 = cast(B'1010111' as bit(10));
--[er]bigint
update bit_conversion set col8 = cast(B'1010111' as bit(10));
--[er]int
update bit_conversion set col9 = cast(B'1010111' as bit(10));
--[er]short
update bit_conversion set col10 = cast(B'1010111' as bit(10));
--[er]monetary
update bit_conversion set col11 = cast(B'1010111' as bit(10));

--[nr]bit
update bit_conversion set col12 = cast(B'1010111' as bit(10));
--[ok]varbit
update bit_conversion set col13 = cast(B'1010111' as bit(10));
select col12, col13 from bit_conversion;

--[ok]char
update bit_conversion set col14 = cast(B'1010111' as bit(10));
--[ok]varchar
update bit_conversion set col15 = cast(B'1010111' as bit(10));
--[ok]nchar
update bit_conversion set col16 = cast(B'1010111' as bit(10));
--[ok]varnchar
update bit_conversion set col17 = cast(B'1010111' as bit(10));
select col14, col15, col16, col17 from bit_conversion;

--[er]set
update bit_conversion set col18 = cast(B'1010111' as bit(10));
--[er]multiset
update bit_conversion set col19 = cast(B'1010111' as bit(10));
--[er]list
update bit_conversion set col20 = cast(B'1010111' as bit(10));
--[er]sequence
update bit_conversion set col21 = cast(B'1010111' as bit(10));
--[er]blob
update bit_conversion set col22 = cast(B'1010111' as bit(10));
select blob_to_bit(col22) from bit_conversion;
--[er]clob
update bit_conversion set col23 = cast(B'1010111' as bit(10));


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from bit_conversion;


delete from bit_conversion;
drop table bit_conversion;
	
