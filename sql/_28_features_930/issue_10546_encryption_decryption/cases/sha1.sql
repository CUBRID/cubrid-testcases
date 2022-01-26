-- SHA1
-- special input
select sha1(NULL);
select if(sha1('abc') = 'A9993E364706816ABA3E25717850C26C9CD0D89D', 'ok', 'nok');

-- check function with a literal, non-char argument (implies conversion to char) --
SELECT sha1(1);

-- check function result data type --
CREATE TABLE SHAONEType AS SELECT sha1(1) AS SHAONECol;
SELECT attr_name, class_name, attr_type, data_type FROM db_attribute WHERE class_name='shaonetype' AND attr_name='shaonecol';
DROP TABLE SHAONEType;

-- check run-time function --
SELECT sha1(CAST(1000 AS CHAR VARYING));
SELECT sha1(CAST(1000 AS NCHAR VARYING));

-- check some literal strings --
SELECT sha1('SQL-99 Complete. Really!');

-- check host variables support --
PREPARE st FROM 'SELECT sha1(?)';
EXECUTE st USING 'SQL-99 Complete. Really!';

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
 values('aaa', 'aaa', n'aaa', n'aaa', 'aaaa', b'0011', b'0011', 10, 11, 12, 13, 14, 15, 16, '1/2/2008', '1:2:3 pm', '01/31/1994 9:10:11 pm', '2010-10-01 1:2:3.123', {10, 20}, {'abc','def'}, {50,60,70}, bit_to_blob(B'000010'), char_to_clob('character'));

insert into coo (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col12, col13, col14,col15, col16, col17, col18, col19, col20, col21, col22, col23)
 values('bbb', 'bbb', n'bbb', n'bbb', 'bbbb', b'1011', b'1010', 20, 21, 22, 23, 24, 25, 26, '5/7/2010', '8:40:22 pm', '05/20/1985 8:15:00 pm', '2022-11-12 12:12:12.12', {11, 22}, {'ghj','yut'}, {80,90,100}, bit_to_blob(B'11100010'), char_to_clob('string'));

show columns in coo;

--char(n), normal
select sha1(col1) from coo order by 1;
--varchar(n), normal
select sha1(col2) from coo order by 1;
--nchar(n), normal
select sha1(col3) from coo order by 1;
--nchar varying(n), normal
select sha1(col4) from coo order by 1;
--string, normal
select sha1(col5) from coo order by 1;
--bit(n), normal
select sha1(col6) from coo order by 1;
--bit varying(n), normal
select sha1(col7) from coo order by 1;
--error, unmatched type
select sha1(col8) from coo order by 1;
--error, unmatched type
select sha1(col9) from coo order by 1;
--error, unmatched type
select sha1(col10) from coo order by 1;
--error, unmatched type
select sha1(col11) from coo order by 1;
--error, unmatched type
select sha1(col12) from coo order by 1;
--error, unmatched type
select sha1(col13) from coo order by 1;
--error, unmatched type
select sha1(col14) from coo order by 1;
--error, unmatched type
select sha1(col15) from coo order by 1;
--error, unmatched type
select sha1(col16) from coo order by 1;
--error, unmatched type
select sha1(col17) from coo order by 1;
--error, unmatched type
select sha1(col18) from coo order by 1;
--error, unmatched type
select sha1(col19) from coo order by 1;
--error, unmatched type
select sha1(col20) from coo order by 1;
--error, unmatched type
select sha1(col21) from coo order by 1;
--error, unmatched type
select sha1(col22) from coo order by 1;
--error, unmatched type
select sha1(col23) from coo order by 1;

delete from coo;
drop table coo;

--pass argument with blob_to_bit() and clob_to_char() function


create table moo(a int, b blob, c clob);

insert into moo values(1, bit_to_blob(X'aaaaaaaaabbbbbbbbccccccccccccccccddddddddd'), char_to_clob('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbccccccccccccccccccccccccccdddddddddddddddddddddddddddddddddd'));

insert into moo values(2, bit_to_blob(B'10101010100000001111111'), char_to_clob('111111111111111777777777777777777ddddddddddddddddd000000000000000000000'));

insert into moo values(3, null, null);

select a, blob_to_bit(b), clob_to_char(c) from moo order by 1;

select a, sha1(blob_to_bit(b)), sha1(clob_to_char(c)) from moo order by 1;


delete from moo;
drop table moo;

-- using aes as index
create table testshaone(a int, b char, c nchar, d varchar);
create index i_testshaone_b on testshaone(sha1(b));
create index i_testshaone_c on testshaone(sha1(c));
create index i_testshaone_d on testshaone(sha1(d));

delete from testshaone;
drop table testshaone;
