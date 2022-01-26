-- SHA2
-- special input
select sha2(NULL, 256);
select if(sha2('abc', 0) = sha2('abc', 256), 'ok', 'nok');
select if(sha2('abc', 224) = '23097D223405D8228642A477BDA255B32AADBCE4BDA0B3F7E36C9DA7', 'ok', 'nok');
select if(sha2('abc', 256) = 'BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD', 'ok', 'nok');
select if(sha2('abc', 384) = 'CB00753F45A35E8BB5A03D699AC65007272C32AB0EDED1631A8B605A43FF5BED8086072BA1E7CC2358BAECA134C825A7', 'ok', 'nok');
select if(sha2('abc', 512) = 'DDAF35A193617ABACC417349AE20413112E6FA4E89A97EA20A9EEEE64B55D39A2192992A274FC1A836BA3C23A3FEEBBD454D4423643CE80E2A9AC94FA54CA49F', 'ok', 'nok');

select sha2('aaa', 224);
select sha2('aaa', 384);

select sha2('abc', 112);

create table testshatwo(
	a smallint,
	b int,
	c bigint
);

insert into testshatwo value(512, 512, 512);
select sha2('abc', a) from testshatwo where a=512;
select sha2('abc', b) from testshatwo where a=512;
select sha2('abc', c) from testshatwo where a=512;

delete from testshatwo;
drop testshatwo;

-- check function with a literal, non-char argument (implies conversion to char) --
SELECT sha2(1, 0);

-- check function result data type --
CREATE TABLE SHATWOType AS SELECT sha2(1, 256) AS SHATWOCol;
SELECT attr_name, class_name, attr_type, data_type FROM db_attribute WHERE class_name='shatwotype' AND attr_name='shatwocol';
DROP TABLE SHATWOType;

-- check run-time function --
SELECT sha2(CAST(1000 AS CHAR VARYING), 256);
SELECT sha2(CAST(1000 AS NCHAR VARYING), 256);

-- check some literal strings --
SELECT sha2('SQL-99 Complete. Really!', 512);

-- check host variables support --
PREPARE st FROM 'SELECT sha2(?, ?)';
EXECUTE st USING 'SQL-99 Complete. Really!', 512;

create table coo(
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
 values('aaa', 'aaa', n'aaa', n'aaa', 'aaaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, 16, '1/2/2008', '1:2:3 pm', '01/31/1994 9:10:11 pm', '2010-10-01 1:2:3.123', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21, col22, col23)
 values('bbb', 'bbb', n'bbb', n'bbb', 'bbbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, 26, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', '2022-11-12 12:12:12.12', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

show columns in coo;

--char(n), normal
select sha2(col1, 512) from coo order by 1;
--varchar(n), normal
select sha2(col2, 512) from coo order by 1;
--nchar(n), normal
select sha2(col3, 512) from coo order by 1;
--nchar varying(n), normal
select sha2(col4, 512) from coo order by 1;
--string, normal
select sha2(col5, 512) from coo order by 1;
--bit(n), normal
select sha2(col6, 512) from coo order by 1;
--bit varying(n), normal
select sha2(col7, 512) from coo order by 1;
--error, unmatched type
select sha2(col8, 512) from coo order by 1;
--error, unmatched type
select sha2(col9, 512) from coo order by 1;
--error, unmatched type
select sha2(col10, 512) from coo order by 1;
--error, unmatched type
select sha2(col11, 512) from coo order by 1;
--error, unmatched type
select sha2(col12, 512) from coo order by 1;
--error, unmatched type
select sha2(col13, 512) from coo order by 1;
--error, unmatched type
select sha2(col14, 512) from coo order by 1;
--error, unmatched type
select sha2(col15, 512) from coo order by 1;
--error, unmatched type
select sha2(col16, 512) from coo order by 1;
--error, unmatched type
select sha2(col17, 512) from coo order by 1;
--error, unmatched type
select sha2(col18, 512) from coo order by 1;
--error, unmatched type
select sha2(col19, 512) from coo order by 1;
--error, unmatched type
select sha2(col20, 512) from coo order by 1;
--error, unmatched type
select sha2(col21, 512) from coo order by 1;
--error, unmatched type
select sha2(col22, 512) from coo order by 1;
--error, unmatched type
select sha2(col23, 512) from coo order by 1;

delete from coo;
drop table coo;

--pass argument with blob_to_bit() and clob_to_char() function


create table moo(a int, b blob, c clob);

insert into moo values(1, bit_to_blob(X'aaaaaaaaabbbbbbbbccccccccccccccccddddddddd'), char_to_clob('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddd'));

insert into moo values(2, bit_to_blob(B'10101010100000001111111'), char_to_clob('111111111111111777777777777777777ddddddddddddddddd000000000000000000000'));

insert into moo values(3, null, null);

select a, blob_to_bit(b), clob_to_char(c) from moo order by 1;

select a, sha2(blob_to_bit(b), 512), sha2(clob_to_char(c), 512) from moo order by 1;


delete from moo;
drop table moo;

-- using aes as index
create table testshatwo(a int, b char, c nchar, d varchar);
create index i_testshatwo_b on testshatwo(sha2(b, 512));
create index i_testshatwo_c on testshatwo(sha2(c, 512));
create index i_testshatwo_d on testshatwo(sha2(d, 512));

delete from testshatwo;
drop table testshatwo;
