create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 char(10) collate utf8_en_ci);
create table t3 (s1 char(4) collate iso88591_en_cs);

insert into t1 values ('Ab'),( 'aa'), (NULL);

insert into t2 values ('Ab'),( 'aa'), (NULL);

insert into t3 values ('Ab'),( 'aa'), (NULL);


select /*+ RECOMPILE */ s1,nvl2(s1,s1,'AA') from t1 order by 2,1;

select /*+ RECOMPILE */ s1,nvl2(s1,s1,'AA') from t2 order by 2,1;

select /*+ RECOMPILE */ s1,nvl2(s1,s1,'AA') from t3 order by 2,1;

prepare s from 'select /*+ RECOMPILE */ s1,nvl2(s1,s1,?) from t1 order by 2,1'
execute s using 'AA';

prepare s from 'select /*+ RECOMPILE */ s1,nvl2(s1,s1,?) from t2 order by 2,1'
execute s using 'AA';

prepare s from 'select /*+ RECOMPILE */ s1,nvl2(s1,s1,?) from t3 order by 2,1'
execute s using 'AA';


select /*+ RECOMPILE */ * from t1 where 'aa' > nvl2(s1,s1,'0')  order by 1;

select /*+ RECOMPILE */ * from t2 where 'aa' > nvl2(s1,s1,'0')  order by 1;

select /*+ RECOMPILE */ * from t3 where 'aa' > nvl2(s1,s1,'0')  order by 1;


prepare s from 'select /*+ RECOMPILE */ * from t1 where ? > nvl2(s1,s1,?)  order by 1'
execute s using 'aa','0';

prepare s from 'select /*+ RECOMPILE */ * from t2 where ? > nvl2(s1,s1,?)  order by 1'
execute s using 'aa','0';

prepare s from 'select /*+ RECOMPILE */ * from t3 where ? > nvl2(s1,s1,?)  order by 1'
execute s using 'aa','0';

drop prepare s;
drop table t1;
drop table t2;
drop table t3;
