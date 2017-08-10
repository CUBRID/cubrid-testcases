--+ holdcas on;
set names utf8;
create table t( a char(3) collate utf8_ko_cs_uca,   b varchar(3) collate utf8_ko_cs_uca,  c nchar(3) collate utf8_ko_cs_uca,  d NCHAR VARYING(3) collate utf8_ko_cs_uca,  e string collate utf8_ko_cs_uca);

insert into t values ( 'a',  'a',  N'a',  N'a',  'a' );
select * from t order by 1;
update t set a='규',b='규',c=N'규',d=N'규',e='규' where b='a';
select * from t order by 1;
update t set a='你',b='你',c=N'你',d=N'你',e='你' where a='규';
select * from t order by 1;
drop table t;
set names iso88591;
commit;
--+ holdcas off;