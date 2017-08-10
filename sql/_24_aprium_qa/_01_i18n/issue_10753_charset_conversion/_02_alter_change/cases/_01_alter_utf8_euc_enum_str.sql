--+ holdcas on;

drop table if exists t;
set names utf8;
create table t (i1 int, e1 enum ('매','뉴','얼 ', '소', '개') charset utf8);
insert into t value (1,1);
insert into t value (2,2);
insert into t value (3,3);
insert into t value (4,4);
insert into t value (5,5);

select i1, e1, hex (e1), cast (e1 as int) from t order by 1;


alter table t modify e1 string charset euckr;
select i1, cast (e1 as string charset utf8), hex (e1) from t order by 1;

alter table t modify e1 enum ('매','뉴','얼 ', '소', '개') charset utf8;
select i1, e1, hex (e1), cast (e1 as int) from t order by 1;

set names iso88591;
drop t;

commit;
--+ holdcas off;
