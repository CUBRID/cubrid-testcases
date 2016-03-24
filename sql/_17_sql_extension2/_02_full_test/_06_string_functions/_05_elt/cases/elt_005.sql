--pass unmatched types of values to the 1st parameter


create class coo(
        col1 char(20),
        col2 nchar(20),
        col3 nchar varying(20),
        col4 bit(8),
        col5 bit varying(8),
        col6 date,
        col7 time,
        col8 timestamp,
        col9 set,
        col10 multiset,
        col11 sequence,
        col12 blob,
        col13 clob,
	col14 datetime
);

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14)
 values('aaa', n'aaa', n'aaa', b'0011', b'0011', '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'), '2010-10-01 1:10:11');

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14)
 values('bbb', n'bbb', n'bbb', b'1011', b'1010', '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'), '2022-11-12 12:12:12');

show columns in coo;

--error, unmatched type
select elt(col1, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col2, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col3, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col4, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col5, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col6, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col7, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col8, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col9, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col10, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col11, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col12, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col13, 'aaa', 'bbb', 'ccc', 'ddd') from coo;
--error, unmatched type
select elt(col14, 'aaa', 'bbb', 'ccc', 'ddd') from coo;


delete from coo;
drop table coo;


