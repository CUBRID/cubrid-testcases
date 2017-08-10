--test bit_to_blob (<blob_type_attr_or_value>) function

--insert data with all data type including blob&clob
create class f_toblob2(
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

insert into f_toblob2 (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('aaa', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));
 
insert into f_toblob2 (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('bbb', n'bbb', n'bbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from f_toblob2 order by 1;

--1. normal test, convert bit string types to blob type
select blob_to_bit(bit_to_blob(col4)) from f_toblob2 order by 1;
select blob_to_bit(bit_to_blob(col5)) from f_toblob2 order by 1;

--2. convert blob type to blob
select if (bit_to_blob(col18) is null, 'nok', 'ok') from f_toblob2;

--3. convert all supported types other than character and clob to blob

--convert CHAR(n) to blob
select blob_to_bit(bit_to_blob(col1)) from f_toblob2;

--convert NCHAR(n) to blob
select blob_to_bit(bit_to_blob(col2)) from f_toblob2;

--convert NCHAR VARYING(n) to blob
select if (blob_to_bit(bit_to_blob(col3)) is null, 'nok', 'ok') from f_toblob2;

--convert NUMERIC to blob
select bit_to_blob(col6) from f_toblob2;

--convert INTEGER to blob
select bit_to_blob(col7) from f_toblob2;

--convert SMALLINT to blob 
select bit_to_blob(col8) from f_toblob2;

--convert MONETARY to blob
select bit_to_blob(col9) from f_toblob2;

--convert FLOAT to blob
select bit_to_blob(col10) from f_toblob2;

--convert DOUBLE to blob
select bit_to_blob(col11) from f_toblob2;

--convert DATE to blob
select bit_to_blob(col12) from f_toblob2;

--convert TIME to blob
select bit_to_blob(col13) from f_toblob2;

--convert TIMESTAMP to blob
select bit_to_blob(col14) from f_toblob2;

--convert SET to blob
select bit_to_blob(col15) from f_toblob2;

--convert MULTISET to blob
select bit_to_blob(col16) from f_toblob2;

--convert SEQUENCE to blob
select bit_to_blob(col17) from f_toblob2;

--convert BLOB to blob
select if (bit_to_blob(col18) is null, 'nok', 'ok') from f_toblob2;

--convert empty string to blob
select blob_to_bit(bit_to_blob('')) from f_toblob2;

--convert NULL to blob
select bit_to_blob(NULL) from f_toblob2;

--pass no argument
select bit_to_blob() from f_toblob2;

--pass 2 arguments
select blob_to_bit(bit_to_blob(col4, 2)) from f_toblob2;

delete from f_toblob2;
drop table f_toblob2;
