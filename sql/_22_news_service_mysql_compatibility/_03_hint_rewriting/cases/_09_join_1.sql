create table t1 (a int, b int, c int, d int);
create index i1_a on t1(a);
create index i1_ab on t1(a,b);
create index i1_abc on t1(a,b,c);
create index i1_abcd on t1(a,b,c,d);

create table t2 (a int, b int, c int, d int);
create index i2_a on t2(a);
create index i2_ab on t2(a,b);
create index i2_abc on t2(a,b,c);
create index i2_abcd on t2(a,b,c,d);

create table t3 (a int, b int, c int, d int);
create index i3_a on t3(a);
create index i3_ab on t3(a,b);
create index i3_abc on t3(a,b,c);
create index i3_abcd on t3(a,b,c,d);

create table t4 (a int, b int, c int, d int);
create index i4_a on t4(a);
create index i4_ab on t4(a,b);
create index i4_abc on t4(a,b,c);
create index i4_abcd on t4(a,b,c,d);


select /*+ recompile ordered */ * from 
    t1 use index (i1_a)
    left join t2 force index (i2_a) on t1.a=t2.a,
    t3 use index (i3_a)
    right join t4 ignore index (i4_a) on t3.a=t4.a
    where t1.a>0 and t2.a>0 and t3.a>0 and t4.a>0;

select /*+ recompile ordered */ * from 
    t1 use index (i1_a)
    left join t2 force index (i2_a) on t1.a=t2.a,
    t3 use index (i3_a)
    right join t4 ignore index (i4_a) on t3.a=t4.a
    where t1.a>0 and t2.a>0 and t3.a>0 and t4.a>0 using index i1_a, i2_a, i3_a, i4_a;

select /*+ recompile ordered */ * from 
    t1 use index (i1_a)
    left join t2 force index (i2_a) on t1.a=t2.a,
    t3 use index (i3_a)
    right join t4 ignore index (i4_a) on t3.a=t4.a
    where t1.a>0 and t2.a>0 and t3.a>0 and t4.a>0 using index all except i1_a, i2_a, i3_a, i4_a;

select /*+ recompile ordered */ * from 
    t1 use index (i1_a)
    left join t2 force index (i2_a) on t1.a=t2.a,
    t3 use index (i3_a)
    right join t4 ignore index (i4_a) on t3.a=t4.a
    where t1.a>0 and t2.a>0 and t3.a>0 and t4.a>0 using index none;

drop table t1;
drop table t2;
drop table t3;
drop table t4;

