--simple case: order by different data types:
--all supported types


create class uoo(
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
        col14 timestamp,
        col15 set,
        col16 multiset,
        col17 sequence,
        col18 blob,
        col19 clob
);

insert into uoo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('aaa', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));
 
insert into uoo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('bbb', n'bbb', n'bbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1; 

update uoo set col1='modified', col6=col6+10 order by col1;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col2;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col3;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col4;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified11', col6=col6+10 order by col5;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col6;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified22', col6=col6+10 order by col7;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col8;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col10;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col11;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col12;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col13;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col14;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col15;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col16;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col17;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col18;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 

update uoo set col1='modified', col6=col6+10 order by col19;
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from uoo order by 1,2; 


drop table uoo;
