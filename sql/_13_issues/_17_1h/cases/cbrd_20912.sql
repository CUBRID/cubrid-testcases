--+ holdcas on;

drop table if exists t1;

drop table if exists t2;

create table t1(a varchar, b int, c int, d int, e int, f int, g int, h int);

insert into t1 values(repeat('a',300),1,1,1,1,1,1,1);

create index i_t1_all on t1(a,b,c,d,e,f,g,h);

select /*+ INDEX_LS */ a from t1 where c>0 group by a;

insert into t1 values(repeat('b',300),2,2,2,2,2,2,2);

insert into t1 values(repeat('b',300),2,2,2,2,2,2,2);

select /*+ INDEX_LS */ DISTINCT a from t1 where c>0 group by a desc,c,b desc having a > 'aaa' order by a limit 1;

create table t2(i1 int,s1 string);

insert into t2 values(1,repeat('a',300));

select /*+ INDEX_LS ORDERED */ t1.a,t1.c from t2 inner join t1 on t2.s1=t1.a and t2.i1=t1.c where t1.c>0 group by t1.a,t1.c; 

drop t1;

drop t2;


drop table if exists t3;

create table t3(id int, a varchar, b int, c int, d int, e int, f int, g int, h int, primary key(id, a)) 
PARTITION BY RANGE (a) (
    PARTITION before_m VALUES LESS THAN ('m'),
    PARTITION before_r VALUES LESS THAN ('r'),
    PARTITION before_w VALUES LESS THAN ('w')
);

insert into t3 values(1,repeat('a',300),1,1,1,1,1,1,1);
insert into t3 values(2,repeat('o',300),2,2,2,2,2,2,2);
insert into t3 values(3,repeat('u',300),3,3,3,3,3,3,3);

create unique index i_t1_all on t3(a,b,c,d,e,f,g,h);

select /*+ INDEX_LS */ a from t3__p__before_m where c>0 group by a; 

create index i_t3_all2 on t3(a,b,c,f);

select /*+ INDEX_LS */ distinct a,b,c from t3 where c>0 group by a using index i_t3_all2 order by 1; 

drop t3;


--+ holdcas off;