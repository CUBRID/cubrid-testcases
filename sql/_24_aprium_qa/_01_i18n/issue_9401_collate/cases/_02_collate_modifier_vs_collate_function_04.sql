--+ holdcas on;
set names utf8;

set names iso88591 collate iso88591_bin;
select collation(t1.k),coercibility(t1.k) from (select 'ß' as k union select 'SS' as k union select 'ss' as k) t1 group by t1.k collate utf8_gen_ai_ci;
set names utf8;
select collation(t1.k),coercibility(t1.k) from (select 'ß' as k union select 'SS' as k union select 'ss' as k) t1 group by t1.k collate utf8_gen_ai_ci;

drop table if exists t;
create table t(i int,s1 varchar(10),s2 char(10) collate utf8_en_cs);
insert into t values(1,'Ab','Ab'),(2,'aa','aa'),(3,'bA','bA'),(4,'bb','bb'),(5,'0','0'),(6,'ß','ß'),(7,'SS','SS'),(8,' ',' ');

select coercibility(s1),coercibility(s2),coercibility('aa') from t group by s1 having s2>'aa' collate utf8_en_ci;

select s2 from t where coercibility(cast(s2 as string collate iso88591_en_cs) collate iso88591_en_ci)=coercibility(cast(s2 as string collate iso88591_en_ci) collate iso88591_en_cs) group by s2 having cast(s2 as char(10) collate iso88591_en_cs) collate iso88591_bin=cast(s2 as string collate iso88591_en_ci) collate iso88591_en_cs order by s2;

drop t;

set names iso88591;
commit;
--+ holdcas off;
