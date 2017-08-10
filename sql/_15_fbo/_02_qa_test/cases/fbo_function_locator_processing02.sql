--test DATA_LENGTH(<blob_or_clob_attr>) function


--insert data with all data type including blob&clob
create class lprocess2_tb(
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

insert into lprocess2_tb (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('aaa', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));
 
insert into lprocess2_tb (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values('bbb', n'bbb', n'bbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from lprocess2_tb order by 1;

--1. normal test

--get data length of blob column
select blob_length(col18) from lprocess2_tb order by 1;

--get data length of clob column
select clob_length(col19) from lprocess2_tb order by 1;

--data_length() in where clause
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from lprocess2_tb where blob_length(col18)>0 and clob_length(col19)<30 order by 1;


--2. test with all cubrid-supported data types other than blob and clob

--CHAR(n)
select blob_length(col1) from lprocess2_tb;
select clob_length(col1) from lprocess2_tb;

--NCHAR(n)
select blob_length(col2) from lprocess2_tb;
select clob_length(col2) from lprocess2_tb;

--NCHAR VARYING(n)
select blob_length(col3) from lprocess2_tb;
select clob_length(col3) from lprocess2_tb;

--BIT(n)
select blob_length(col4) from lprocess2_tb;
select clob_length(col4) from lprocess2_tb;

--BIT VARYING(n) to clob
select blob_length(col5) from lprocess2_tb;
select clob_length(col5) from lprocess2_tb;

--NUMERIC 
select blob_length(col6) from lprocess2_tb;
select clob_length(col6) from lprocess2_tb;

--INTEGER 
select blob_length(col7) from lprocess2_tb;
select clob_length(col7) from lprocess2_tb;

--SMALLINT  
select blob_length(col8) from lprocess2_tb;
select clob_length(col8) from lprocess2_tb;

--MONETARY 
select blob_length(col9) from lprocess2_tb;
select clob_length(col9) from lprocess2_tb;

--FLOAT 
select blob_length(col10) from lprocess2_tb;
select clob_length(col10) from lprocess2_tb;

--DOUBLE 
select blob_length(col11) from lprocess2_tb;
select clob_length(col11) from lprocess2_tb;

--DATE 
select blob_length(col12) from lprocess2_tb;
select clob_length(col12) from lprocess2_tb;

--TIME 
select blob_length(col13) from lprocess2_tb;
select clob_length(col13) from lprocess2_tb;

--TIMESTAMP 
select blob_length(col14) from lprocess2_tb;
select clob_length(col14) from lprocess2_tb;

--SET 
select blob_length(col15) from lprocess2_tb;
select clob_length(col15) from lprocess2_tb;

--MULTISET 
select blob_length(col16) from lprocess2_tb;
select clob_length(col16) from lprocess2_tb;

--SEQUENCE 
select blob_length(col17) from lprocess2_tb;
select clob_length(col17) from lprocess2_tb;

--empty string 
select blob_length("") from lprocess2_tb;
select clob_length("") from lprocess2_tb;

--NULL 
select blob_length(NULL) from lprocess2_tb;
select clob_length(NULL) from lprocess2_tb;

--pass no argument
select blob_length() from lprocess2_tb;
select clob_length() from lprocess2_tb;

--pass 2 arguments
select blob_length(col18, 2) from lprocess2_tb;
select clob_length(col19, 2) from lprocess2_tb;

delete from lprocess2_tb;
drop table lprocess2_tb;
