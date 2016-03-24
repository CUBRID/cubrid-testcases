create table t1 (a int, b int, c int, d int);
create index i1_a on t1(a);
create index i1_ab on t1(a,b);

create table t2 (a int, b int, c int, d int);
create index i2_a on t2(a);
create index i2_ab on t2(a,b);

select /*+ recompile */ * from 
    t1 use index (i1_a)
    left join t2 force index (i1_ab) on t1.a=t2.a    
    where t1.a>0 and t2.a>0;

drop table t1;
drop table t2;

