--+ holdcas on;
set names binary;

--CUBRIDSUS-17847
select B'000011110000', mid(B'000011110000',2,2), substr(B'000011110000',2,2);
select mid('abcde12345', 4,100);
select mid('abcde12345', 5,0);
select mid('가나다라마바', 2, 4);
select mid('天地你我他', 1, 4);
select mid('天地你我他', -6, 3);

CREATE TABLE mid_tbl(a VARCHAR);
INSERT INTO mid_tbl VALUES('12345abcdeabcde');
SELECT MID(a, 6, 0), SUBSTR(a, 6, 0), SUBSTRING(a, 6, 0) FROM mid_tbl;
SELECT MID(a, 6, 4), SUBSTR(a, 6, 4), SUBSTRING(a, 6, 4) FROM mid_tbl;
SELECT MID(a, 6, -4), SUBSTR(a, 6, -4), SUBSTRING(a, 6, -4) FROM mid_tbl;
SELECT MID(a, -6, 4), SUBSTR(a, -6, 4), SUBSTRING(a, -6, 4) FROM mid_tbl;
drop mid_tbl;

set names utf8;
drop table if exists t;
create table t (
id int AUTO_INCREMENT , 
col_binary varchar(100) collate binary, 
col_euckr  varchar(100) collate euckr_bin, 
col_utf8    varchar(100) collate utf8_bin, 
col_iso      varchar(100) collate iso88591_bin);
insert into t values(null,'큐브리드' , '큐브리드', '큐브리드', '큐브리드');
insert into t values(null,'你好我好大家好', '你好我好大家好', '你好我好大家好', '你好我好大家好');
insert into t values(null,'CUBRID' , 'CUBRID', 'CUBRID',  'CUBRID');
insert into t values(null,'ÀÀÏ' , 'ÀÀÏ', 'ÀÀÏ',  'ÀÀÏ');

set names binary;
SELECT id, MID(col_binary, 2,2), HEX(MID(col_euckr, 2,2)), MID(col_utf8, 2,2), MID(col_iso, 2,2) from t order by 1;
SELECT id, MID(col_binary, -2,3),HEX(MID(col_euckr, -2,3)),MID(col_utf8, -2,3),MID(col_iso, -2,3) from t order by 1;
drop table if exists t;

set names iso88591;
--+ holdcas off;
