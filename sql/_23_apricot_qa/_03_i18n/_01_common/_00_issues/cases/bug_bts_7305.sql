--+ holdcas on;
set names utf8;
create table t( a char(1) charset utf8, b varchar(1) charset utf8, c nchar(1) charset utf8, d NCHAR VARYING(1) charset utf8, e string charset utf8);

insert into t values ( 'a', 'a', N'a', N'a', 'a' );
select * from t order by 1;
update t set a='ä',b='ä',c=N'ä',d=N'ä',e='ä' where b='a';
select * from t order by 1;
update t set a='你',b='你',c=N'你',d=N'你',e='你' where a='ä';
select * from t order by 1;
drop table t;
set names iso88591;
commit;
--+ holdcas off;
