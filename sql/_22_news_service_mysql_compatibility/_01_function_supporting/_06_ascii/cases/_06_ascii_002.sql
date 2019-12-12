-- test UTF-8 format
create class t(
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
        col19 clob,
	col20 datetime
);

insert into t (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20)
 values('aaa', n'aaa', n'aaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, '1/1/2008', '1:1:1 pm', '01/31/1994 8:15:00 pm', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'), '2010-10-01 1:10:11');

show columns in t;

--TEST
select ASCII(col1) from t order by 1;
--TEST 
select ASCII(col2) from t order by 1;
--TEST
select ASCII(col3) from t order by 1;
--TEST
select ASCII(col4) from t order by 1;
--TEST
select ASCII(col5) from t order by 1;
--TEST
select ASCII(col6) from t order by 1;
--TEST
select ASCII(col7) from t order by 1;
--TEST
select ASCII(col8) from t order by 1;
--TEST
select ASCII(col9) from t order by 1;
--TEST
select ASCII(col10) from t order by 1;
--TEST
select ASCII(col11) from t order by 1;
--TEST
select ASCII(col12) from t order by 1;
--TEST
select ASCII(col13) from t order by 1;
--TEST
select ASCII(col14) from t order by 1;
--TEST
select ASCII(col15) from t order by 1;
--TEST
select ASCII(col16) from t order by 1;
--TEST
select ASCII(col17) from t order by 1;
--TEST
select ASCII(col18) from t order by 1;
--TEST
select ASCII(col19) from t order by 1;
--TEST
select ASCII(col20) from t order by 1;


delete from t;
drop table t;


