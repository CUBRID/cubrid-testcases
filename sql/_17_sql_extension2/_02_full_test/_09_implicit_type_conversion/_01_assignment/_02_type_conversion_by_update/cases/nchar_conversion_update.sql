--test implicit type conversion of char type



create table nchar_conversion(
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


insert into nchar_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from nchar_conversion;


--[ok]datetime
update nchar_conversion set col1 = cast(n'11/08/2010 16:10:22.123' as nchar(30));
--[ok]date
update nchar_conversion set col2 = cast(n'11/08/2010 16:10:22' as nchar(30));
--[ok]time
update nchar_conversion set col3 = cast(n'11/08/2010 16:10:22' as nchar(30));
--[ok]timestamp
update nchar_conversion set col4 = cast(n'11/08/2010 16:10:22' as nchar(30));
select col1, col2, col3, col4 from nchar_conversion;

--[ok]double
update nchar_conversion set col5 = cast(n'1234654345.78623871' as nchar(30));
--[ok]float
update nchar_conversion set col6 = cast(n'23423.3423423' as nchar(30));
--[ok]numeric
update nchar_conversion set col7 = cast(n'754.123' as nchar(30));
--[ok]bigint
update nchar_conversion set col8 = cast(n'779238429347230' as nchar(30));
--[ok]int
update nchar_conversion set col9 = cast(n'7383724' as nchar(30));
--[ok]short
update nchar_conversion set col10 = cast(n'6372' as nchar(30));
--[ok]monetary
update nchar_conversion set col11 = cast(n'12342.9380' as nchar(30));
select col5, col6, col7, col8, col9, col10, col11 from nchar_conversion;

--[ok]bit
update nchar_conversion set col12 = cast(n'0b1010111' as nchar(30));
--[ok]varbit
update nchar_conversion set col13 = cast(n'0b1010111' as nchar(30));
select col12, col13 from nchar_conversion;

--[nr]char
update nchar_conversion set col14 = cast(n'11/08/2010 16:10:22.123' as nchar(30));
--[ok]varchar
update nchar_conversion set col15 = cast(n'11/08/2010 16:10:22.123' as nchar(30));
--[ok]nchar
update nchar_conversion set col16 = cast(n'11/08/2010 16:10:22.123' as nchar(30));
--[ok]varnchar
update nchar_conversion set col17 = cast(n'11/08/2010 16:10:22.123' as nchar(30));
select col14, col15, col16, col17 from nchar_conversion;

--[er]set
update nchar_conversion set col18 = cast(n'11/08/2010 16:10:22.123' as nchar(30));
--[er]multiset
update nchar_conversion set col19 = cast(n'11/08/2010 16:10:22.123' as nchar(30));
--[er]list
update nchar_conversion set col20 = cast(n'11/08/2010 16:10:22.123' as nchar(30));
--[er]sequence
update nchar_conversion set col21 = cast(n'11/08/2010 16:10:22.123' as nchar(30));
--[ok]blob
update nchar_conversion set col22 = cast(n'11/08/2010 16:10:22.123' as nchar(30));
select blob_to_bit(col22) from nchar_conversion;
--[ok]clob
update nchar_conversion set col23 = cast(n'11/08/2010 16:10:22.123' as nchar(30));
select clob_to_char(col23) from nchar_conversion;

select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from nchar_conversion;


delete from nchar_conversion;
drop table nchar_conversion;
	
