--test implicit type conversion of char type



create table varchar_conversion(
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


insert into varchar_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from varchar_conversion;


--[ok]datetime
update varchar_conversion set col1 = cast('11/08/2010 16:10:22.123' as char varying);
--[ok]date
update varchar_conversion set col2 = cast('11/08/2010 16:10:22' as char varying);
--[ok]time
update varchar_conversion set col3 = cast('11/08/2010 16:10:22' as char varying);
--[ok]timestamp
update varchar_conversion set col4 = cast('11/08/2010 16:10:22' as char varying);
select col1, col2, col3, col4 from varchar_conversion;

--[ok]double
update varchar_conversion set col5 = cast('1234654345.78623871' as char varying);
--[ok]float
update varchar_conversion set col6 = cast('23423.3423423' as char varying);
--[ok]numeric
update varchar_conversion set col7 = cast('754.123' as char varying);
--[ok]bigint
update varchar_conversion set col8 = cast('779238429347230' as char varying);
--[ok]int
update varchar_conversion set col9 = cast('7383724' as char varying);
--[ok]short
update varchar_conversion set col10 = cast('6372' as char varying);
--[ok]monetary
update varchar_conversion set col11 = cast('12342.9380' as char varying);
select col5, col6, col7, col8, col9, col10, col11 from varchar_conversion;

--[ok]bit
update varchar_conversion set col12 = cast('0b1010111' as char varying);
--[ok]varbit
update varchar_conversion set col13 = cast(B'1010111' as char varying);
select col12, col13 from varchar_conversion;

--[nr]char
update varchar_conversion set col14 = cast('11/08/2010 16:10:22.123' as char varying);
--[ok]varchar
update varchar_conversion set col15 = cast('11/08/2010 16:10:22.123' as char varying);
--[ok]nchar
update varchar_conversion set col16 = cast('11/08/2010 16:10:22.123' as char varying);
--[ok]varnchar
update varchar_conversion set col17 = cast('11/08/2010 16:10:22.123' as char varying);
select col14, col15, col16, col17 from varchar_conversion;

--[er]set
update varchar_conversion set col18 = cast('11/08/2010 16:10:22.123' as char varying);
--[er]multiset
update varchar_conversion set col19 = cast('11/08/2010 16:10:22.123' as char varying);
--[er]list
update varchar_conversion set col20 = cast('11/08/2010 16:10:22.123' as char varying);
--[er]sequence
update varchar_conversion set col21 = cast('11/08/2010 16:10:22.123' as char varying);
--[ok]blob
update varchar_conversion set col22 = cast('11/08/2010 16:10:22.123' as char varying);
select blob_to_bit(col22) from varchar_conversion;
--[ok]clob
update varchar_conversion set col23 = cast('11/08/2010 16:10:22.123' as char varying);
select clob_to_char(col23) from varchar_conversion;

select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from varchar_conversion;


delete from varchar_conversion;
drop table varchar_conversion;
	
