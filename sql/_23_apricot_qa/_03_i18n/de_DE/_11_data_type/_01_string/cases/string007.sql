--+ holdcas on;
set names utf8;
drop table if exists t;
create table t( a char(2) collate utf8_de_exp,   b varchar(2) collate utf8_de_exp,  c nchar(2) collate utf8_de_exp,  d NCHAR VARYING(2) collate utf8_de_exp,  e string collate utf8_de_exp);

insert into t values ( 'a',  'a',  N'a',  N'a',  'a' );
insert into t values ( upper('a'),  upper('a'),  upper(N'a'),  upper(N'a'),  upper('a'));
insert into t values ( 'ä',  'ä',  N'ä',  N'ä',  'ä' );
insert into t values ( upper('ä'),  upper('ä'),  upper(N'ä'),  upper(N'ä'),  upper('ä'));
insert into t values ( 'är',  'är',  N'är',  N'är',  'är' );
insert into t values ( upper('är'),  upper('är'),  upper(N'är'),  upper(N'är'),  upper('är'));
insert into t values ( 'ar',  'ar',  N'ar',  N'ar',  'ar' );
insert into t values ( upper('ar'),  upper('ar'),  upper(N'ar'),  upper(N'ar'),  upper('ar'));
insert into t values ( '你好',  '你好',  N'你好',  N'你好',  '你好' );
insert into t values ( upper('你好'),  upper('你好'),  upper(N'你好'),  upper(N'你好'),  upper('你好'));

select * from t order by 1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
