--test implicit type conversion of short type



create table short_conversion(
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


insert into short_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from short_conversion;


--[er]datetime
update short_conversion set col1 = cast(1234 as short);
--[er]date
update short_conversion set col2 = cast(1234 as short);
--[er]time
update short_conversion set col3 = cast(1234 as short);
--[er]timestamp
update short_conversion set col4 = cast(1234 as short);

--[ok]double
update short_conversion set col5 = cast(1234 as short);
--[ok]float
update short_conversion set col6 = cast(1234 as short);
--[ok]numeric
update short_conversion set col7 = cast(1234 as short);
--[ok]bigint
update short_conversion set col8 = cast(1234 as short);
--[ok]int
update short_conversion set col9 = cast(1234 as short);
--[nr]short
update short_conversion set col10 = cast(1234 as short);
--[ok]monetary
update short_conversion set col11 = cast(1234 as short);
select col5, col6, col7, col8, col9, col10, col11 from short_conversion;

--[er]bit
update short_conversion set col12 = cast(1234 as short);
--[er]varbit
update short_conversion set col13 = cast(1234 as short);

--[ok]char
update short_conversion set col14 = cast(1234 as short);
--[ok]varchar
update short_conversion set col15 = cast(1234 as short);
--[ok]nchar
update short_conversion set col16 = cast(1234 as short);
--[ok]varnchar
update short_conversion set col17 = cast(1234 as short);
select col14, col15, col16, col17 from short_conversion;

--[er]set
update short_conversion set col18 = cast(1234 as short);
--[er]multiset
update short_conversion set col19 = cast(1234 as short);
--[er]list
update short_conversion set col20 = cast(1234 as short);
--[er]sequence
update short_conversion set col21 = cast(1234 as short);
--[er]blob
update short_conversion set col22 = cast(1234 as short);
--[er]clob
update short_conversion set col23 = cast(1234 as short);


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from short_conversion;


delete from short_conversion;
drop table short_conversion;
	
