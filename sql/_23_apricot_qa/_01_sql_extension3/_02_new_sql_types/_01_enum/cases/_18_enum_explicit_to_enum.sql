--explicit conversion from other types to enum type.


create table conv(
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


insert into conv values (
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


--TEST: explicitly convert enum type 
select cast(col1 as enum('11/09/2010 14:40:22.222', 'aaa', 'bbb')) from conv;
select cast(col2 as enum('1', '2010-11-9', 'a', 'b')) from conv;
select cast(col3 as enum('a', 'b', '14:40:44', 'c')) from conv;
select cast(col4 as enum('bb', 'aa', '11/09/2010 14:40:22 PM', 'ddd')) from conv;
select cast(col5 as enum('1', '2', '1234.56789')) from conv;
select cast(col6 as enum('1234.567', 'd', 'fff')) from conv;
select cast(col7 as enum('b', '1234.55555', 'c')) from conv;
select cast(col8 as enum('12345678999', 'abc', 'hello')) from conv;
select cast(col9 as enum('12345', 'aaa')) from conv;
select cast(col10 as enum('yes', '123', 'no', 'cancel')) from conv;
select cast(col11 as enum('12345.67', '111', '222')) from conv;
select cast(col12 as enum('abc', '1010111')) from conv;
select cast(col13 as enum('111', '1100101', '101')) from conv;
select cast(col14 as enum('aaa', 'bbb', 'abc')) from conv;
select cast(col15 as enum('aabbcc', 'abc')) from conv;
select cast(col16 as enum('abc', 'a', 'b', 'cc')) from conv;
select cast(col17 as enum('ddd', 'uuuu', 'aabbcc')) from conv;
select cast(col18 as enum('1', '2', '3', '4', '5')) from conv;
select cast(col19 as enum('1', '2', '3', '4', '5')) from conv;
select cast(col20 as enum('1', '2', '3', '4', '5')) from conv;
select cast(col21 as enum('1', '2', '3', '4', '5')) from conv;
select cast(col22 as enum('a', 'aabbc')) from conv;
select cast(col23 as enum('a', 'aabbcc', 'b')) from conv;


--TEST: [er] conversion error, unexisted enum value.
select cast(col1 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col2 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col3 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col4 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col5 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col6 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col7 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col8 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col9 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col10 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col11 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col12 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col13 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col14 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col15 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col16 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col17 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col18 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col19 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col20 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col21 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col22 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;
select cast(col23 as enum('aaaaaaaaaaaaaaaaaaaaaaaaaaaa')) from conv;


--TEST: cast numeric values to enum index
update conv set col5=1, col6=1, col7=1, col8=1, col9=2, col10=2, col11=2;
select cast(col5 as enum('1', '2', '1234.56789')) from conv;
select cast(col6 as enum('1234.567', 'd', 'fff')) from conv;
select cast(col7 as enum('b', '1234.55555', 'c')) from conv;
select cast(col8 as enum('12345678999', 'abc', 'hello')) from conv;
select cast(col9 as enum('12345', 'aaa')) from conv;
select cast(col10 as enum('yes', '123', 'no', 'cancel')) from conv;
select cast(col11 as enum('12345.67', '111', '222')) from conv;



drop table conv;
