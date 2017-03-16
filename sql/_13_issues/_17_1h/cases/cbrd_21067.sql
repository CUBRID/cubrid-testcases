--+ holdcas on;

drop table if exists t1;

create table t1(s1 string,s2 string);

create index idx_t1 on t1(s1,s2);

insert into t1(s1,s2) values(repeat('abc',100),repeat('chartest',100));

select a.s1,b.s2 from t1 a,t1 b where a.s1=b.s1 and a.s1>'abc' group by a.s1 order by b.s2 desc limit 1;

select max(a.s1) from t1 a,t1 b where a.s1=b.s1 and a.s1>'abc' group by a.s1 order by b.s2 desc for orderby_num() between 1 and 2; 

drop t1;


--+ holdcas off;