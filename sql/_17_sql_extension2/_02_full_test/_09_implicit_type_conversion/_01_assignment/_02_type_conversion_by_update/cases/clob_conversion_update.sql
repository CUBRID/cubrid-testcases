--test implicit type conversion of clob type



create table clob_conversion(
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


insert into clob_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from clob_conversion;


--[er]datetime
update clob_conversion set col1 = char_to_clob('aabbcc');
--[er]date
update clob_conversion set col2 = char_to_clob('aabbcc');
--[er]time
update clob_conversion set col3 = char_to_clob('aabbcc');
--[er]timestamp
update clob_conversion set col4 = char_to_clob('aabbcc');
--[er]double
update clob_conversion set col5 = char_to_clob('aabbcc');
--[er]float
update clob_conversion set col6 = char_to_clob('aabbcc');
--[er]numeric
update clob_conversion set col7 = char_to_clob('aabbcc');
--[er]bigint
update clob_conversion set col8 = char_to_clob('aabbcc');
--[er]int
update clob_conversion set col9 = char_to_clob('aabbcc');
--[er]short
update clob_conversion set col10 = char_to_clob('aabbcc');
--[er]monetary
update clob_conversion set col11 = char_to_clob('aabbcc');
--[er]bit
update clob_conversion set col12 = char_to_clob('aabbcc');
--[er]varbit
update clob_conversion set col13 = char_to_clob('aabbcc');

--[er]char
update clob_conversion set col14 = char_to_clob('aabbcc');
--[er]varchar
update clob_conversion set col15 = char_to_clob('aabbcc');
--[er]nchar
update clob_conversion set col16 = char_to_clob('aabbcc');
--[er]varnchar
update clob_conversion set col17 = char_to_clob('aabbcc');
select col14, col15, col16, col17 from clob_conversion;

--[er]set
update clob_conversion set col18 = char_to_clob('aabbcc');
--[er]multiset
update clob_conversion set col19 = char_to_clob('aabbcc');
--[er]list
update clob_conversion set col20 = char_to_clob('aabbcc');
--[er]sequence
update clob_conversion set col21 = char_to_clob('aabbcc');
--[er]blob
update clob_conversion set col22 = char_to_clob('aabbcc');
--[nr]clob
update clob_conversion set col23 = char_to_clob('aabbcc');
select clob_to_char(col23) from clob_conversion;

select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from clob_conversion;


delete from clob_conversion;
drop table clob_conversion;
	
