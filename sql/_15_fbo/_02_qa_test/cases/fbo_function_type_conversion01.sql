--test clob_to_char(<clob_type_attr>) function

--insert data with all data type including blob&clob
create class f_tochar(
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

insert into f_tochar (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('aaa', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));
 
insert into f_tochar (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('bbb', n'bbb', n'bbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14, col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from f_tochar order by 1;

--1. normal test, convert clob type to character string
--select col19 from f_tochar;
select clob_to_char(col19) from f_tochar order by 1;

--2. convert character types to character string
select clob_to_char(col1) from f_tochar order by 1;
select clob_to_char(col2) from f_tochar order by 1;
select clob_to_char(col3) from f_tochar order by 1;

--3. convert all supported types other than clob and character to character string

--convert BIT(n) to char
select clob_to_char(col4) from f_tochar order by 1;

--convert BIT VARYING(n) to char
select clob_to_char(col5) from f_tochar order by 1;

--convert NUMERIC to char
select clob_to_char(col6) from f_tochar order by 1;

--convert INTEGER to char
select clob_to_char(col7) from f_tochar order by 1;

--convert SMALLINT to char 
select clob_to_char(col8) from f_tochar order by 1;

--convert MONETARY to char
select clob_to_char(col9) from f_tochar order by 1;

--convert FLOAT to char
select clob_to_char(col10) from f_tochar order by 1;

--convert DOUBLE to char
select clob_to_char(col11) from f_tochar order by 1;

--convert DATE to char
select clob_to_char(col12) from f_tochar order by 1;

--convert TIME to char
select clob_to_char(col13) from f_tochar order by 1;

--convert TIMESTAMP to char
select clob_to_char(col14) from f_tochar order by 1;

--convert SET to char
select clob_to_char(col15) from f_tochar order by 1;

--convert MULTISET to char
select clob_to_char(col16) from f_tochar order by 1;

--convert SEQUENCE to char
select clob_to_char(col17) from f_tochar order by 1;

--convert BLOB to char
select clob_to_char(col18) from f_tochar order by 1;

--convert empty string to char
--select clob_to_char("") from f_tochar;
select clob_to_char('') from f_tochar;

--convert NULL to char
select clob_to_char(NULL) from f_tochar;

--pass no argument
select clob_to_char() from f_tochar;

--pass 2 arguments
select clob_to_char(col19, 2) from f_tochar order by 1;

delete from f_tochar;
drop table f_tochar;
