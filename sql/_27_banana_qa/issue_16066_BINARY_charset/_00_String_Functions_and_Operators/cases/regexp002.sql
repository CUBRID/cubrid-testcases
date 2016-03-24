--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values('문자열문자열문자열', '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(cast( _utf8'문자열문자열문자열' as string charset euckr), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(cast( _utf8'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ' as string charset iso88591), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591), '문자열문자열문자열', '문자열문자열문자열', 'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2');
insert into t1 values(chr(0),chr(0),chr(0),chr(0));



SELECT * FROM t1 where col_binary REGEXP '문';
SELECT * FROM t1 where col_euckr REGEXP cast( _utf8'문' as string charset euckr);
SELECT * FROM t1 where col_utf8  REGEXP '문';
SELECT * FROM t1 where col_iso  REGEXP cast( _utf8'À'  as string charset iso88591) ;
SELECT * FROM t1 where col_binary REGEXP 'chr(0)';



SELECT * FROM t1 where col_binary REGEXP BINARY '문';
SELECT * FROM t1 where col_euckr REGEXP BINARY cast( _utf8'문' as string charset euckr);
SELECT * FROM t1 where col_utf8  REGEXP  BINARY '문';
SELECT * FROM t1 where col_iso  REGEXP BINARY cast( _utf8'À'  as string charset iso88591) ;


drop table t1;

set names iso88591;
commit;
--+ holdcas off;
