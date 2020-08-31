--+ holdcas on;
set names utf8;
drop table if exists t1;
create table t1 (col_binary varchar(30) collate binary, col_euckr varchar(30) collate euckr_bin, col_utf8 varchar(30) collate utf8_bin, col_iso varchar(40) collate iso88591_bin);
insert into t1 values('문자열문자열문자열', '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(cast( _utf8'문자열문자열문자열' as string charset euckr), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
insert into t1 values(cast( _utf8'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ' as string charset iso88591), '문자열문자열문자열', '문자열문자열문자열', 'ÀÏÀÏÀÏÀÏÀÏÀÏÀÏÀÏ');
select * from t1 order by 1,2,3,4;


--modify charset
alter table t1 modify col_binary char(30) charset utf8;
select * from t1 order by 1,2,3,4;
alter table t1 change col_euckr col_euckr  varchar(60) charset binary;
select * from t1 order by 1,2,3,4;
alter table t1 modify col_euckr  varchar(60) charset euckr;
select * from t1 order by 1,2,3,4;
alter table t1 change col_utf8 col_utf8  varchar(60) charset binary;
select * from t1 order by 1,2,3,4;
alter table t1 change col_iso col_iso  varchar(30) charset binary;
select * from t1 order by 1,2,3,4;
alter table t1 modify col_iso varchar(30) charset iso88591;
select * from t1 order by 1,2,3,4;
show full columns in t1;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;


