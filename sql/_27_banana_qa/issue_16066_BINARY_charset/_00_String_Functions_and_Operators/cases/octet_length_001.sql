--+ holdcas on;
set names binary;

SELECT OCTET_LENGTH('');
SELECT OCTET_LENGTH('CUBRID');
SELECT OCTET_LENGTH('你我他');
SELECT OCTET_LENGTH('큐브리드');
SELECT OCTET_LENGTH(B'010101010');

SELECT OCTET_LENGTH(cast( _utf8''as string charset iso88591));
SELECT OCTET_LENGTH(cast( _utf8'CUBRID'as string charset binary));
SELECT OCTET_LENGTH( _utf8'你我他');
SELECT OCTET_LENGTH(cast( _utf8'큐브리드'as string charset euckr));

drop table if exists octet_length_tbl;
CREATE TABLE octet_length_tbl (char_1 CHAR, char_2 CHAR(5), varchar_1 VARCHAR, bit_var_1 BIT VARYING);
select * from octet_length_tbl;
INSERT INTO octet_length_tbl VALUES('', '', '', B'');
INSERT INTO octet_length_tbl VALUES('a', 'a', 'a', B'010101010');
INSERT INTO octet_length_tbl VALUES(NULL, '你', '你', B'010101010');
INSERT INTO octet_length_tbl VALUES(' ', ' 큐', ' 큐', B'010101010');

SELECT OCTET_LENGTH(char_1), OCTET_LENGTH(char_2), OCTET_LENGTH(varchar_1), OCTET_LENGTH(bit_var_1) FROM octet_length_tbl order by 1,2,3,4;
drop octet_length_tbl;


set names utf8;
drop table if exists t1;

create table t1 (id int, col_binary varchar(20) collate binary, col_euckr varchar(20) collate euckr_bin, col_utf8 varchar(20) collate utf8_bin, col_iso varchar(20) collate iso88591_bin);
insert into t1 values(1, 'CUBRID', 'CUBRID', 'CUBRID', 'CUBRID');
insert into t1 values(2, '你我他', '你我他', '你我他', '你我他');
insert into t1 values(3, '큐브리드','큐브리드', '큐브리드', '큐브리드');
insert into t1 values(4, 'ÀÏ', 'ÀÏ','ÀÏ', 'ÀÏ');

set names binary;
select id, col_binary, HEX(col_euckr), col_utf8, col_iso from t1 order by 1;
SELECT id, OCTET_LENGTH(col_binary), OCTET_LENGTH(col_euckr),OCTET_LENGTH(col_utf8),OCTET_LENGTH(col_iso) from t1 order by id;

drop table t1;
set names iso88591;
--+ holdcas off;

