--+ holdcas on;
set names utf8;
create table t( a char(3) charset utf8 default'aä你', b varchar(3) charset utf8  default'aä你', c nchar(3) charset utf8  default N'aä你', d NCHAR VARYING(3) charset utf8  default N'aä你', e string charset utf8  default'aä你');
drop table t;
set names iso88591;
commit;
--+ holdcas off;