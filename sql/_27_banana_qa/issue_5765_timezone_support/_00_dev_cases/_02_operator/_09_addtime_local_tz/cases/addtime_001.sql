--TEST: pass unmatched types or formats of values to the 1st parameter

set timezone '+9:00';

create class coo(
        col1 char(20),
        col2 nchar(20),
        col3 nchar varying(20),
        col4 bit(8),
        col5 bit varying(8),
        col6 numeric,
        col7 integer,
        col8 smallint,
        col9 monetary,
        col10 float,
        col11 double,
        col12 date,
        col13 time,
        col14 timestampltz,
        col15 set(int),
        col16 multiset(char(10)),
        col17 sequence(short),
        col18 blob,
        col19 clob,
	col20 datetimeltz,
	col21 varchar
);

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21)
 values('aaa', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'), '2010-10-01 1:10:11', 'aaa');

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21)
 values('bbb', n'bbb', n'bbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'), '2022-11-12 12:12:12', 'bbb');

show columns in coo;

--TEST: error, unmatched format
select addtime(col1, '12:12:12') from coo order by 1;
--TEST: error, unmatched format
select addtime(col21, '12:12:12') from coo order by 1;
--TEST: error, unmatched format
select addtime(col2, '12:12:12') from coo order by 1;
--TEST: error, unmatched format
select addtime(col3, '12:12:12') from coo order by 1;
--TEST: error, unmatched type
select addtime(col4, '12:12:12') from coo order by 1;
--TEST: error, unmatched type
select addtime(col5, '12:12:12') from coo order by 1;
--TEST: normal, numeric
select addtime(col6, '12:12:12') from coo order by 1;
--TEST: normal, int
select addtime(col7, '12:12:12') from coo order by 1;
--TEST: numeric, smallint
select addtime(col8, '12:12:12') from coo order by 1;
--TEST: numeric, monetary
select addtime(col9, '12:12:12') from coo order by 1;
--TEST: numeric, float
select addtime(col10, '12:12:12') from coo order by 1;
--TEST: numeric, double
select addtime(col11, '12:12:12') from coo order by 1;
--TEST: normal, date argument
select addtime(col12, '12:12:12') from coo order by 1;
--TEST: normal, time type
select addtime(col13, '12:12:12') from coo order by 1;
--TEST: normal, timestampltz argument
select addtime(col14, '12:12:12') from coo order by 1;
--TEST: error, unmatched type
select addtime(col15, '12:12:12') from coo order by 1;
--TEST: error, unmatched type
select addtime(col16, '12:12:12') from coo order by 1;
--TEST: error, unmatched type
select addtime(col17, '12:12:12') from coo order by 1;
--TEST: error, unmatched type
select addtime(col18, '12:12:12') from coo order by 1;
--TEST: error, unmatched type
select addtime(col19, '12:12:12') from coo order by 1;
--TEST: normal, datetimeltz type argument
select addtime(col20, '12:12:12') from coo order by 1;


delete from coo;
drop table coo;

set timezone 'Asia/Seoul';
