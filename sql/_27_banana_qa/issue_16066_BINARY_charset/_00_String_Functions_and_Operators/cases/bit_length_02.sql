--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (id int, col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values(1, '문자열', '문자열', '문자열', 'ÀÏ');
insert into t1 values(2, cast( _utf8'문자열' as string charset euckr), '문자열', '문자열', 'ÀÏ');
insert into t1 values(3, cast( _utf8'ÀÏ' as string charset iso88591), '문자열', '문자열', 'ÀÏ');
insert into t1 values(4, chr(0), chr(0), '문자열', chr(0));
insert into t1 values(5, '1','1','1','1' );
set names binary;
SELECT id, BIT_LENGTH(col_binary), BIT_LENGTH(col_euckr), BIT_LENGTH(col_utf8), BIT_LENGTH(col_iso) from t1 order by id;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;