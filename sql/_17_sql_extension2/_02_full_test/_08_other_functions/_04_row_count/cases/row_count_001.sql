--pass unmatched types or formats of values


create class coo(
        col1 char(20),
	col2 varchar(20),
	col3 nchar(20),
	col4 nchar varying(20),
	col5 string,
	col6 bit(20),
	col7 bit varying(20),
	col8 int,
	col9 smallint,
	col10 bigint,
	col11 numeric,
	col12 float,
	col13 double,
	col14 monetary,
	col15 date,
	col16 time,
	col17 timestamp,
	col18 datetime,
	col19 set,
	col20 multiset,
	col21 sequence,
	col22 blob,
	col23 clob
);


insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21, col22, col23)
 values('aaa', 'aaa', n'aaa', n'aaa', 'aaaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, 16, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', '2010-10-01 1:10:11.123', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21, col22, col23)
 values('bbb', 'bbb', n'bbb', n'bbb', 'bbbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, 26, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', '2022-11-12 12:12:12.12', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

show columns in coo;


--error, unmatched param number
select row_count(col1) from coo order by 1;
--error, unmatched param number
select row_count(col2) from coo order by 1;
--error, unmatched param number
select row_count(col3) from coo order by 1;
--error, unmatched param number
select row_count(col4) from coo order by 1;
--error, unmatched param number
select row_count(col5) from coo order by 1;
--error, unmatched param number
select row_count(col6) from coo order by 1;
--error, unmatched param number
select row_count(col7) from coo order by 1;
--error, unmatched param number
select row_count(col8) from coo order by 1;
--error, unmatched param number
select row_count(col9) from coo order by 1;
--error, unmatched param number
select row_count(col10) from coo order by 1;
--error, unmatched param number
select row_count(col11) from coo order by 1;
--error, unmatched param number
select row_count(col12) from coo order by 1;
--error, unmatched param number
select row_count(col13) from coo order by 1;
--error, unmatched param number
select row_count(col14) from coo order by 1;
--error, unmatched param number
select row_count(col15) from coo order by 1;
--error, unmatched param number
select row_count(col16) from coo order by 1;
--error, unmatched param number
select row_count(col17) from coo order by 1;
--error, unmatched param number
select row_count(col18) from coo order by 1;
--error, unmatched param number
select row_count(col19) from coo order by 1;
--error, unmatched param number
select row_count(col20) from coo order by 1;
--error, unmatched param number
select row_count(col21) from coo order by 1;
--error, unmatched param number
select row_count(col22) from coo order by 1;
--error, unmatched param number
select row_count(col23) from coo order by 1;


delete from coo;
drop table coo;


