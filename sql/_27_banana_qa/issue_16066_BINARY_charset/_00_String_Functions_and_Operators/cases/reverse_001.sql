--+ holdcas on;
set names binary;

SELECT REVERSE('CUBRID');
SELECT REVERSE('문자열');
SELECT REVERSE(cast(_utf8'문자열' as string charset euckr ));
SELECT REVERSE('ÀÏ');
SELECT REVERSE(cast(_utf8'ÀÏ' as string charset  iso88591));
SELECT REVERSE('中国国');
SELECT REVERSE(_utf8'中国国');
SELECT REVERSE('');
SELECT REVERSE(null);
  
 
set names utf8;
drop table if exists t1;
create table t1 (id int, col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values(1, '문자열', '문자열', '문자열', '문자열');
insert into t1 values(2, '中国', '中国', '中国', '中国');
insert into t1 values(3, 'ÀÏ', 'ÀÏ', 'ÀÏ', 'ÀÏ');
insert into t1 values(4, 'CUBRID', 'CUBRID','CUBRID','CUBRID');

set names binary;
select * from t1 order by 1;
SELECT id, REVERSE(col_binary), REVERSE(col_euckr),REVERSE(col_utf8),REVERSE(col_iso) from t1 order by id;

drop table t1;



set names iso88591;
--+ holdcas off;
