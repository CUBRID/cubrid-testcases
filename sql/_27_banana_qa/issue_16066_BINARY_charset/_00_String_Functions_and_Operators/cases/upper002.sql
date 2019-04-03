--+ holdcas on;
set names binary;
drop table if exists t1;

SELECT UPPER('abc');

SELECT UPPER('ABC');

SELECT UPPER(chr(0) );


create table t1 (col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values('abc', 'abc', 'abc', 'abc');
insert into t1 values('ABC', 'ABC', 'ABC', 'ABC');


SELECT UPPER(col_binary) , UPPER(col_euckr),UPPER(col_utf8),UPPER(col_iso)   from t1 order by 1 desc;


drop table t1;

set names iso88591;
commit;
--+ holdcas off;
