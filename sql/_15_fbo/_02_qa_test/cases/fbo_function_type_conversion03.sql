--test char_to_clob (<char_type_attr_or_value>) function

--insert data with all data type including blob&clob
create class f_toclob(
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

insert into f_toclob (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('aaa', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));
 
insert into f_toclob (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('bbb', n'bbb', n'bbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from f_toclob order by 1;

--1. normal test, convert character string types to clob type
select clob_to_char(char_to_clob(col1)) from f_toclob order by 1;
select clob_to_char(char_to_clob(col2)) from f_toclob order by 1;
select clob_to_char(char_to_clob(col3)) from f_toclob order by 1;

--2. convert clob type to clob
select if (char_to_clob(col19) is null, 'nok', 'ok') from f_toclob;

--3. convert all supported types other than character and clob to clob

--convert BIT(n) to clob
select if (char_to_clob(col4) is null, 'nok', 'ok') from f_toclob;

--convert BIT VARYING(n) to clob
select if (char_to_clob(col5) is null, 'nok', 'ok') from f_toclob;

--convert NUMERIC to clob
select if (char_to_clob(col6) is null, 'nok', 'ok') from f_toclob;

--convert INTEGER to clob
select if (char_to_clob(col7) is null, 'nok', 'ok') from f_toclob;

--convert SMALLINT to clob 
select if (char_to_clob(col8) is null, 'nok', 'ok') from f_toclob;

--convert MONETARY to clob
select if (char_to_clob(col9) is null, 'nok', 'ok') from f_toclob;

--convert FLOAT to clob
select if (char_to_clob(col10) is null, 'nok', 'ok') from f_toclob;

--convert DOUBLE to clob
select if (char_to_clob(col11) is null, 'nok', 'ok') from f_toclob;

--convert DATE to clob
select if (char_to_clob(col12) is null, 'nok', 'ok') from f_toclob;

--convert TIME to clob
select if (char_to_clob(col13) is null, 'nok', 'ok') from f_toclob;

--convert TIMESTAMP to clob
select if (char_to_clob(col4) is null, 'nok', 'ok') from f_toclob;

--convert SET to clob
select char_to_clob(col15) from f_toclob;

--convert MULTISET to clob
select char_to_clob(col16) from f_toclob;

--convert SEQUENCE to clob
select char_to_clob(col17) from f_toclob;

--convert BLOB to clob
select char_to_clob(col18) from f_toclob;

--convert empty string to clob
--select char_to_clob("") from f_toclob;

--convert NULL to clob
select char_to_clob(NULL) from f_toclob;

--pass no argument
select char_to_clob() from f_toclob;

--pass 2 arguments
select clob_to_char(char_to_clob(col1, 2)) from f_toclob;

delete from f_toclob;
drop table f_toclob;
