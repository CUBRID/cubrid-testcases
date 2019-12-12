--+ holdcas on;
set names utf8;
create table t( a varchar(2) charset utf8);
insert into t values ('表1');
select * from t order by 1;
drop table t;
set names iso88591;
commit;
--+ holdcas off;