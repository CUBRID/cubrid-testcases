--test implicit type conversion of char type



create table varnchar_conversion(
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
	col15 char varying(30),
	col16 nchar(30),
	col17 nchar varying(30),
	col18 set,
	col19 multiset,
	col20 list,
	col21 sequence,
	col22 blob,
	col23 clob
);


insert into varnchar_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from varnchar_conversion;


--[ok]datetime
update varnchar_conversion set col1 = cast(n'11/08/2010 16:10:22.123' as nchar varying);
--[ok]date
update varnchar_conversion set col2 = cast(n'11/08/2010 16:10:22' as nchar varying);
--[ok]time
update varnchar_conversion set col3 = cast(n'11/08/2010 16:10:22' as nchar varying);
--[ok]timestamp
update varnchar_conversion set col4 = cast(n'11/08/2010 16:10:22' as nchar varying);
select col1, col2, col3, col4 from varnchar_conversion;

--[ok]double
update varnchar_conversion set col5 = cast(n'1234654345.78623871' as nchar varying);
--[ok]float
update varnchar_conversion set col6 = cast(n'23423.3423423' as nchar varying);
--[ok]numeric
update varnchar_conversion set col7 = cast(n'754.123' as nchar varying);
--[ok]bigint
update varnchar_conversion set col8 = cast(n'779238429347230' as nchar varying);
--[ok]int
update varnchar_conversion set col9 = cast(n'7383724' as nchar varying);
--[ok]short
update varnchar_conversion set col10 = cast(n'6372' as nchar varying);
--[ok]monetary
update varnchar_conversion set col11 = cast(n'12342.9380' as nchar varying);
select col5, col6, col7, col8, col9, col10, col11 from varnchar_conversion;

--[ok]bit
update varnchar_conversion set col12 = cast(n'0b10101' as nchar varying);
--[ok]varbit
update varnchar_conversion set col13 = cast(n'0b1010111' as nchar varying);
select col12, col13 from varnchar_conversion;

--[nr]char
update varnchar_conversion set col14 = cast(n'11/08/2010 16:10:22.123' as nchar varying);
--[ok]varchar
update varnchar_conversion set col15 = cast(n'11/08/2010 16:10:22.123' as nchar varying);
--[ok]nchar
update varnchar_conversion set col16 = cast(n'11/08/2010 16:10:22.123' as nchar varying);
--[ok]varnchar
update varnchar_conversion set col17 = cast(n'11/08/2010 16:10:22.123' as nchar varying);
select col14, col15, col16, col17 from varnchar_conversion;

--[er]set
update varnchar_conversion set col18 = cast(n'11/08/2010 16:10:22.123' as nchar varying);
--[er]multiset
update varnchar_conversion set col19 = cast(n'11/08/2010 16:10:22.123' as nchar varying);
--[er]list
update varnchar_conversion set col20 = cast(n'11/08/2010 16:10:22.123' as nchar varying);
--[er]sequence
update varnchar_conversion set col21 = cast(n'11/08/2010 16:10:22.123' as nchar varying);
--[ok]blob
update varnchar_conversion set col22 = cast(n'11/08/2010 16:10:22.123' as nchar varying);
select blob_to_bit(col22) from varnchar_conversion;
--[ok]clob
update varnchar_conversion set col23 = cast(n'11/08/2010 16:10:22.123' as nchar varying);
select clob_to_char(col23) from varnchar_conversion;

select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from varnchar_conversion;


delete from varnchar_conversion;
drop table varnchar_conversion;
	
