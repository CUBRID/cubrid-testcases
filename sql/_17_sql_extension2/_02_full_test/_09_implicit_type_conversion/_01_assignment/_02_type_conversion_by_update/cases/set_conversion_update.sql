--test implicit type conversion of set type



create table set_conversion(
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


insert into set_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from set_conversion;


--[er]datetime
update set_conversion set col1 = cast({1, 2, 3, 4, 5} as set);
--[er]date
update set_conversion set col2 = cast({1, 2, 3, 4, 5} as set);
--[er]time
update set_conversion set col3 = cast({1, 2, 3, 4, 5} as set);
--[er]timestamp
update set_conversion set col4 = cast({1, 2, 3, 4, 5} as set);

--[er]double
update set_conversion set col5 = cast({1, 2, 3, 4, 5} as set);
--[er]float
update set_conversion set col6 = cast({1, 2, 3, 4, 5} as set);
--[er]numeric
update set_conversion set col7 = cast({1, 2, 3, 4, 5} as set);
--[er]bigint
update set_conversion set col8 = cast({1, 2, 3, 4, 5} as set);
--[er]int
update set_conversion set col9 = cast({1, 2, 3, 4, 5} as set);
--[er]short
update set_conversion set col10 = cast({1, 2, 3, 4, 5} as set);
--[er]monetary
update set_conversion set col11 = cast({1, 2, 3, 4, 5} as set);

--[er]bit
update set_conversion set col12 = cast({1, 2, 3, 4, 5} as set);
--[er]varbit
update set_conversion set col13 = cast({1, 2, 3, 4, 5} as set);

--[er]char
update set_conversion set col14 = cast({1, 2, 3, 4, 5} as set);
--[er]varchar
update set_conversion set col15 = cast({1, 2, 3, 4, 5} as set);
--[er]nchar
update set_conversion set col16 = cast({1, 2, 3, 4, 5} as set);
--[er]varnchar
update set_conversion set col17 = cast({1, 2, 3, 4, 5} as set);

--[nr]set
update set_conversion set col18 = cast({1, 2, 3, 4, 5} as set);
--[er]multiset
update set_conversion set col19 = cast({1, 2, 3, 4, 5} as set);
--[er]list
update set_conversion set col20 = cast({1, 2, 3, 4, 5} as set);
--[er]sequence
update set_conversion set col21 = cast({1, 2, 3, 4, 5} as set);
select col18, col19, col20, col21 from set_conversion;

--[er]blob
update set_conversion set col22 = cast({1, 2, 3, 4, 5} as set);
--[er]clob
update set_conversion set col23 = cast({1, 2, 3, 4, 5} as set);


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from set_conversion;


delete from set_conversion;
drop table set_conversion;
	
