--01_nulls_first_last_002.sql
--insert data with all data type including blob&clob
drop table if exists lprocess2_tb;
create class lprocess2_tb(
        id int primary key not null auto_increment,
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

insert into lprocess2_tb (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(null, null, null, null,null,null, null, null, null, null, null, null, null, null,null, null, null, bit_to_blob(null), char_to_clob(null));

insert into lprocess2_tb (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(null, null, null, null,null,null, null, null, null, null, null, null, null, null,null, null, null, bit_to_blob(null), char_to_clob(null));

--select * from lprocess2_tb;

select id,col1 from lprocess2_tb order by col1 asc nulls first,id;
select id,col2 from lprocess2_tb order by col2 asc nulls first,id;
select id,col3 from lprocess2_tb order by col3 asc nulls first,id;
select id,col4 from lprocess2_tb order by col4 asc nulls first,id;
select id,col5 from lprocess2_tb order by col5 asc nulls first,id;
select id,col6 from lprocess2_tb order by col6 asc nulls first,id;
select id,col7 from lprocess2_tb order by col7 asc nulls first,id;
select id,col8 from lprocess2_tb order by col8 asc nulls first,id;
select id,col9 from lprocess2_tb order by col9 asc nulls first,id;
select id,col10 from lprocess2_tb order by col10 asc nulls first,id;
select id,col11 from lprocess2_tb order by col11 asc nulls first,id;
select id,col12 from lprocess2_tb order by col12 asc nulls first,id;
select id,col13 from lprocess2_tb order by col13 asc nulls first,id;
select id,col14 from lprocess2_tb order by col14 asc nulls first,id;
select id,col15 from lprocess2_tb order by col15 asc nulls first,id;
select id,col16 from lprocess2_tb order by col16 asc nulls first,id;
select id,col17 from lprocess2_tb order by col17 asc nulls first,id;
select id,col18 from lprocess2_tb order by col18 asc nulls first,id;
select id,col19 from lprocess2_tb order by col19 asc nulls first,id;

select id,col1 from lprocess2_tb order by col1 desc nulls first,id;
select id,col2 from lprocess2_tb order by col2 desc nulls first,id;
select id,col3 from lprocess2_tb order by col3 desc nulls first,id;
select id,col4 from lprocess2_tb order by col4 desc nulls first,id;
select id,col5 from lprocess2_tb order by col5 desc nulls first,id;
select id,col6 from lprocess2_tb order by col6 desc nulls first,id;
select id,col7 from lprocess2_tb order by col7 desc nulls first,id;
select id,col8 from lprocess2_tb order by col8 desc nulls first,id;
select id,col9 from lprocess2_tb order by col9 desc nulls first,id;
select id,col10 from lprocess2_tb order by col10 desc nulls first,id;
select id,col11 from lprocess2_tb order by col11 desc nulls first,id;
select id,col12 from lprocess2_tb order by col12 desc nulls first,id;
select id,col13 from lprocess2_tb order by col13 desc nulls first,id;
select id,col14 from lprocess2_tb order by col14 desc nulls first,id;
select id,col15 from lprocess2_tb order by col15 desc nulls first,id;
select id,col16 from lprocess2_tb order by col16 desc nulls first,id;
select id,col17 from lprocess2_tb order by col17 desc nulls first,id;
select id,col18 from lprocess2_tb order by col18 desc nulls first,id;
select id,col19 from lprocess2_tb order by col19 desc nulls first,id;

select id,col1 from lprocess2_tb order by col1 desc nulls last,id;
select id,col2 from lprocess2_tb order by col2 desc nulls last,id;
select id,col3 from lprocess2_tb order by col3 desc nulls last,id;
select id,col4 from lprocess2_tb order by col4 desc nulls last,id;
select id,col5 from lprocess2_tb order by col5 desc nulls last,id;
select id,col6 from lprocess2_tb order by col6 desc nulls last,id;
select id,col7 from lprocess2_tb order by col7 desc nulls last,id;
select id,col8 from lprocess2_tb order by col8 desc nulls last,id;
select id,col9 from lprocess2_tb order by col9 desc nulls last,id;
select id,col10 from lprocess2_tb order by col10 desc nulls last,id;
select id,col11 from lprocess2_tb order by col11 desc nulls last,id;
select id,col12 from lprocess2_tb order by col12 desc nulls last,id;
select id,col13 from lprocess2_tb order by col13 desc nulls last,id;
select id,col14 from lprocess2_tb order by col14 desc nulls last,id;
select id,col15 from lprocess2_tb order by col15 desc nulls last,id;
select id,col16 from lprocess2_tb order by col16 desc nulls last,id;
select id,col17 from lprocess2_tb order by col17 desc nulls last,id;
select id,col18 from lprocess2_tb order by col18 desc nulls last,id;
select id,col19 from lprocess2_tb order by col19 desc nulls last,id;

select id,col1 from lprocess2_tb order by col1 asc nulls last,id;
select id,col2 from lprocess2_tb order by col2 asc nulls last,id;
select id,col3 from lprocess2_tb order by col3 asc nulls last,id;
select id,col4 from lprocess2_tb order by col4 asc nulls last,id;
select id,col5 from lprocess2_tb order by col5 asc nulls last,id;
select id,col6 from lprocess2_tb order by col6 asc nulls last,id;
select id,col7 from lprocess2_tb order by col7 asc nulls last,id;
select id,col8 from lprocess2_tb order by col8 asc nulls last,id;
select id,col9 from lprocess2_tb order by col9 asc nulls last,id;
select id,col10 from lprocess2_tb order by col10 asc nulls last,id;
select id,col11 from lprocess2_tb order by col11 asc nulls last,id;
select id,col12 from lprocess2_tb order by col12 asc nulls last,id;
select id,col13 from lprocess2_tb order by col13 asc nulls last,id;
select id,col14 from lprocess2_tb order by col14 asc nulls last,id;
select id,col15 from lprocess2_tb order by col15 asc nulls last,id;
select id,col16 from lprocess2_tb order by col16 asc nulls last,id;
select id,col17 from lprocess2_tb order by col17 asc nulls last,id;
select id,col18 from lprocess2_tb order by col18 asc nulls last,id;
select id,col19 from lprocess2_tb order by col19 asc nulls last,id;


select id,col1 from lprocess2_tb order by col1 nulls last,id;
select id,col2 from lprocess2_tb order by col2 nulls last,id;
select id,col3 from lprocess2_tb order by col3 nulls last,id;
select id,col4 from lprocess2_tb order by col4 nulls last,id;
select id,col5 from lprocess2_tb order by col5 nulls last,id;
select id,col6 from lprocess2_tb order by col6 nulls last,id;
select id,col7 from lprocess2_tb order by col7 nulls last,id;
select id,col8 from lprocess2_tb order by col8 nulls last,id;
select id,col9 from lprocess2_tb order by col9 nulls last,id;
select id,col10 from lprocess2_tb order by col10 nulls last,id;
select id,col11 from lprocess2_tb order by col11 nulls last,id;
select id,col12 from lprocess2_tb order by col12 nulls last,id;
select id,col13 from lprocess2_tb order by col13 nulls last,id;
select id,col14 from lprocess2_tb order by col14 nulls last,id;
select id,col15 from lprocess2_tb order by col15 nulls last,id;
select id,col16 from lprocess2_tb order by col16 nulls last,id;
select id,col17 from lprocess2_tb order by col17 nulls last,id;
select id,col18 from lprocess2_tb order by col18 nulls last,id;
select id,col19 from lprocess2_tb order by col19 nulls last,id;

drop table if exists lprocess2_tb;



--insert data with all data type including blob&clob
drop table if exists lprocess2_tb;
create class lprocess2_tb(
        id int primary key not null auto_increment,
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

insert into lprocess2_tb (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(null, null, null, null,null,null, null, null, null, null, null, null, null, null,null, null, null, bit_to_blob(null), char_to_clob(null));

insert into lprocess2_tb (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19)
 values(null, null, null, null,null,null, null, null, null, null, null, null, null, null,null, null, null, bit_to_blob(null), char_to_clob(null));

--select * from lprocess2_tb;

select id , blob_length(col18) as a from lprocess2_tb order by a nulls last,id;
select id , blob_length(col18) as a from lprocess2_tb order by a nulls first,id;

--get data length of clob column
select id ,clob_length(col19) as a from lprocess2_tb order by a nulls last,id;
select id ,clob_length(col19) as a from lprocess2_tb order by a nulls first,id;


--data_length() in where clause
select col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, blob_to_bit(col18), clob_to_char(col19) from lprocess2_tb where blob_length(col18)>0 and clob_length(col19)<30 order by 1;


--2.test with all cubrid-supported data types other than blob and clob

--CHAR(n)
select blob_length(col1) from lprocess2_tb order by 1 nulls first;
select clob_length(col1) from lprocess2_tb order by 1 nulls first;

--NCHAR(n)
select blob_length(col2) from lprocess2_tb order by 1 nulls first;
select clob_length(col2) from lprocess2_tb order by 1 nulls first;

--NCHAR VARYING(n)
select blob_length(col3) from lprocess2_tb order by 1 nulls first;
select clob_length(col3) from lprocess2_tb order by 1 nulls first;

--BIT(n)
select blob_length(col4) from lprocess2_tb order by 1 nulls first;
select clob_length(col4) from lprocess2_tb order by 1 nulls first;

--BIT VARYING(n) to clob
select blob_length(col5) from lprocess2_tb order by 1 nulls first;
select clob_length(col5) from lprocess2_tb order by 1 nulls first;

--NUMERIC 
select blob_length(col6) from lprocess2_tb order by 1 nulls first;
select clob_length(col6) from lprocess2_tb order by 1 nulls first;

--INTEGER 
select blob_length(col7) from lprocess2_tb order by 1 nulls first;
select clob_length(col7) from lprocess2_tb order by 1 nulls first;

--SMALLINT  
select blob_length(col8) from lprocess2_tb order by 1 nulls first;
select clob_length(col8) from lprocess2_tb order by 1 nulls first;

--MONETARY 
select blob_length(col9) from lprocess2_tb order by 1 nulls first;
select clob_length(col9) from lprocess2_tb order by 1 nulls first;

--FLOAT 
select blob_length(col10) from lprocess2_tb order by 1 nulls first;
select clob_length(col10) from lprocess2_tb order by 1 nulls first;

--DOUBLE 
select blob_length(col11) from lprocess2_tb order by 1 nulls first;
select clob_length(col11) from lprocess2_tb order by 1 nulls first;

--DATE 
select blob_length(col12) from lprocess2_tb order by 1 nulls first;
select clob_length(col12) from lprocess2_tb order by 1 nulls first;

--TIME 
select blob_length(col13) from lprocess2_tb order by 1 nulls first;
select clob_length(col13) from lprocess2_tb order by 1 nulls first;

--TIMESTAMP 
select blob_length(col14) from lprocess2_tb order by 1 nulls first;
select clob_length(col14) from lprocess2_tb order by 1 nulls first;

--SET 
select blob_length(col15) from lprocess2_tb order by 1 nulls first;
select clob_length(col15) from lprocess2_tb order by 1 nulls first;

--MULTISET 
select blob_length(col16) from lprocess2_tb order by 1 nulls first;
select clob_length(col16) from lprocess2_tb order by 1 nulls first;

--SEQUENCE 
select blob_length(col17) from lprocess2_tb order by 1 nulls first;
select clob_length(col17) from lprocess2_tb order by 1 nulls first;

--empty string 
select blob_length("") from lprocess2_tb order by 1 nulls first;
select clob_length("") from lprocess2_tb order by 1 nulls first;

--NULL 
select blob_length(NULL) from lprocess2_tb order by 1 nulls first;
select clob_length(NULL) from lprocess2_tb order by 1 nulls first;

--pass no argument
select blob_length() from lprocess2_tb order by 1 nulls first;
select clob_length() from lprocess2_tb order by 1 nulls first;

--pass 2 arguments
select blob_length(col18, 2) from lprocess2_tb order by 1 nulls first;
select clob_length(col19, 2) from lprocess2_tb order by 1 nulls first;

--NULL 
select blob_length(NULL) from lprocess2_tb order by 1 nulls last;
select clob_length(NULL) from lprocess2_tb order by 1 nulls last;


drop table if exists lprocess2_tb;
