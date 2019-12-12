--test implicit type conversion of time type



create table time_conversion(
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


insert into time_conversion values (
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


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from time_conversion;


--[er]datetime
update time_conversion set col1 = time'16:47:22';
--[er]date
update time_conversion set col2 = time'16:47:22';
--[nr]time
update time_conversion set col3 = time'16:47:22';
select col3 from time_conversion;
--[er]timestamp
update time_conversion set col4 = time'16:47:22';

--[er]double
update time_conversion set col5 = time'16:47:22';
--[er]float
update time_conversion set col6 = time'16:47:22';
--[er]numeric
update time_conversion set col7 = time'16:47:22';
--[er]bigint
update time_conversion set col8 = time'16:47:22';
--[er]int
update time_conversion set col9 = time'16:47:22';
--[er]short
update time_conversion set col10 = time'16:47:22';
--[er]monetary
update time_conversion set col11 = time'16:47:22';
--[er]bit
update time_conversion set col12 = time'16:47:22';
--[er]varbit
update time_conversion set col13 = time'16:47:22';

--[ok]char
update time_conversion set col14 = time'16:47:22';
--[ok]varchar
update time_conversion set col15 = time'16:47:22';
--[ok]nchar
update time_conversion set col16 = time'16:47:22';
--[ok]varnchar
update time_conversion set col17 = time'16:47:22';
select col14, col15, col16, col17 from time_conversion;

--[er]set
update time_conversion set col18 = time'16:47:22';
--[er]multiset
update time_conversion set col19 = time'16:47:22';
--[er]list
update time_conversion set col20 = time'16:47:22';
--[er]sequence
update time_conversion set col21 = time'16:47:22';
--[er]blob
update time_conversion set col22 = time'16:47:22';
--[er]clob
update time_conversion set col23 = time'16:47:22';


select col1,col2,col3,col4,col5,col6,col7,col8,col9,col10,col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,blob_to_bit(col22),clob_to_char(col23) from time_conversion;


delete from time_conversion;
drop table time_conversion;
	
