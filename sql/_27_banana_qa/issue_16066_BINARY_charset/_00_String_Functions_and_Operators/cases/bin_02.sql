--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values('문자열', '문자열', '문자열', 'ÀÏ');

set names binary;
SELECT BIN(col_binary), BIN(col_euckr), BIN(col_utf8), BIN(col_iso) from t1;

delete from t1;
insert into t1 values('1','1','1','1' );
SELECT BIN(col_binary), BIN(col_euckr), BIN(col_utf8), BIN(col_iso) from t1;


drop table t1;
set names iso88591;
commit;
--+ holdcas off;