--+ holdcas on;
set names binary;

SELECT REPEAT('Cubrid',3);
SELECT length( REPEAT('C',33554432));
set  system parameters 'string_max_size_bytes=33554432';
SELECT length( REPEAT('C',33554432));
SELECT REPEAT('C',33554432+1);
set  system parameters 'string_max_size_bytes=1M';
SELECT REPEAT('Cubrid',-1);
SELECT REPEAT('Cubrid',0);
SELECT REPEAT('Cubrid',null);
SELECT REPEAT('cubrid','a');

SELECT REPEAT('한국',3);
SELECT REPEAT('中国',3);
SELECT REPEAT('ÀÀÀ',3);


set names utf8;
drop table if exists t1;
create table t1 (id int, col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values(1, '中国', '中国', '中国', '中国');
insert into t1 values(2, cast( _utf8'한국' as string charset euckr), '한국', '한국', 'ÀÏ');
insert into t1 values(3, cast( _utf8'ÀÏ' as string charset iso88591), 'ÀÏ', 'ÀÏ', 'ÀÏ');

set names binary;
-- CUBRIDSUS-17766
select * from t1 order by id;
select id, col_binary, repeat(col_binary, 3),repeat(col_euckr, 3),repeat(col_utf8, 3),repeat(col_iso, 3) from t1 order by id;

drop t1;

set names iso88591;
--+ holdcas off;
