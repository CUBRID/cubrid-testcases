--+ holdcas on;
set names utf8;
create table t( a char(6) collate binary,   b varchar(6) collate binary,  c nchar(6) collate binary,  d NCHAR VARYING(6) collate binary,  e string collate utf8_ko_cs_uca);

insert into t values ( 'a',  'a',  N'a',  N'a',  'a' );
insert into t values ( upper('a'),  upper('a'),  upper(N'a'),  upper(N'a'),  upper('a'));
insert into t values ( '규',  '규',  N'규',  N'규',  '규' );
insert into t values ( upper('규'),  upper('규'),  upper(N'규'),  upper(N'규'),  upper('규'));
insert into t values ( '규r',  '규r',  N'규r',  N'규r',  '규r' );
insert into t values ( upper('규r'),  upper('규r'),  upper(N'규r'),  upper(N'규r'),  upper('규r'));
insert into t values ( 'ar',  'ar',  N'ar',  N'ar',  'ar' );
insert into t values ( upper('ar'),  upper('ar'),  upper(N'ar'),  upper(N'ar'),  upper('ar'));
insert into t values ( '你好',  '你好',  N'你好',  N'你好',  '你好' );
insert into t values ( upper('你好'),  upper('你好'),  upper(N'你好'),  upper(N'你好'),  upper('你好'));

select * from t order by 1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
