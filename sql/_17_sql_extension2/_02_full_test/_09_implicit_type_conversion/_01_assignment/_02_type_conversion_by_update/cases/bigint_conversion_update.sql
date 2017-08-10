--test implicit type conversion of bigint type



create table bigint_conversion(
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


insert into bigint_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from bigint_conversion;


--[er]datetime
update bigint_conversion set col1 = cast(12345678901 as bigint);
--[er]date
update bigint_conversion set col2 = cast(12345678901 as bigint);
--[er]time
update bigint_conversion set col3 = cast(12345678901 as bigint);
--[er]timestamp
update bigint_conversion set col4 = cast(12345678901 as bigint);

--[ok]double
update bigint_conversion set col5 = cast(12345678901 as bigint);
--[ok]float
update bigint_conversion set col6 = cast(12345678901 as bigint);
--[ok]numeric
update bigint_conversion set col7 = cast(12345678901 as bigint);
--[nr]bigint
update bigint_conversion set col8 = cast(12345678901 as bigint);
--[ok]int
update bigint_conversion set col9 = cast(12345678901 as bigint);
--[ok]short
update bigint_conversion set col10 = cast(12345678901 as bigint);
--[ok]monetary
update bigint_conversion set col11 = cast(12345678901 as bigint);
select col5, col6, col7, col8, col9, col10, col11 from bigint_conversion;

--[er]bit
update bigint_conversion set col12 = cast(12345678901 as bigint);
--[er]varbit
update bigint_conversion set col13 = cast(12345678901 as bigint);

--[ok]char
update bigint_conversion set col14 = cast(12345678901 as bigint);
--[ok]varchar
update bigint_conversion set col15 = cast(12345678901 as bigint);
--[ok]nchar
update bigint_conversion set col16 = cast(12345678901 as bigint);
--[ok]varnchar
update bigint_conversion set col17 = cast(12345678901 as bigint);
select col14, col15, col16, col17 from bigint_conversion;

--[er]set
update bigint_conversion set col18 = cast(12345678901 as bigint);
--[er]multiset
update bigint_conversion set col19 = cast(12345678901 as bigint);
--[er]list
update bigint_conversion set col20 = cast(12345678901 as bigint);
--[er]sequence
update bigint_conversion set col21 = cast(12345678901 as bigint);
--[er]blob
update bigint_conversion set col22 = cast(12345678901 as bigint);
--[er]clob
update bigint_conversion set col23 = cast(12345678901 as bigint);


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit        (col22),clob_to_char(col23) from bigint_conversion;

delete from bigint_conversion;
drop table bigint_conversion;
	
