--+ holdcas on;

set names utf8;
drop table if exists t1;
create table t1 (id int, col_binary varchar(10) collate binary, col_euckr varchar(10) collate euckr_bin, col_utf8 varchar(10) collate utf8_bin, col_iso varchar(10) collate iso88591_bin);
insert into t1 values(1, '문자열', '문자열', '문자열', 'À');
insert into t1 values(2, '문자', '문자', '문자', 'Ï');
insert into t1 values(3, '문', '문', '문', 'ÀÏ');

set names binary;
select * from t1 where id=1 and col_binary = '문자열' AND col_euckr='문자열';
select * from t1 where col_binary > '문' AND col_binary< cast(_utf8'문자열' as string charset euckr);
select * from t1 where col_binary > '문' AND col_binary< '문자열';

select * from t1 where col_binary <> '문' ;
select * from t1 where col_binary != '문' ;

select * from t1 where col_binary <> col_euckr ;
select * from t1 where col_binary != col_euckr ;
select * from t1 where col_binary > col_euckr ;
select * from t1 where col_binary < col_euckr ;
select * from t1 where col_binary = col_euckr ;

select * from t1 where col_binary <> col_utf8 ;
select * from t1 where col_binary != col_utf8 ;
select * from t1 where col_binary >col_utf8 ;
select * from t1 where col_binary < col_utf8 ;
select * from t1 where col_binary = col_utf8 ;

select * from t1 where col_binary <> col_iso ;
select * from t1 where col_binary != col_iso ;

drop table t1;

set names iso88591;
commit;

--+ holdcas off;