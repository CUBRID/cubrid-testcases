set names utf8 collate utf8_en_ci;

drop table if exists t;
create table t(i int,s string collate utf8_en_ci, e enum('e','D','a') collate utf8_en_ci);
insert into t values(1,'D','D'),(2,'a','a'),(3,'e','e');

select * from t order by e;
select * from t order by cast(e as string);

drop t;

create table t(i int,e enum('年','납')) collate utf8_ko_cs;
create index i on t(e);
insert into t values(1,2),(2,1);
select * from t where e> '年';
drop t;

set names iso88591;
