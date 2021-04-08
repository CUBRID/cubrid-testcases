--+ holdcas on;
create table t1 (a int, b int, c int, d int);
create reverse index i1_a on t1(a);
create reverse index i1_ab on t1(a,b);
create reverse index i1_abc on t1(a,b,c);
create reverse index i1_abcd on t1(a,b,c,d);

create table t2 (a int, b int, c int, d int);
create reverse index i2_a on t2(a);
create reverse index i2_ab on t2(a,b);
create reverse index i2_abc on t2(a,b,c);
create reverse index i2_abcd on t2(a,b,c,d);

create table t3 (a int, b int, c int, d int);
create reverse index i3_a on t3(a);
create reverse index i3_ab on t3(a,b);
create reverse index i3_abc on t3(a,b,c);
create reverse index i3_abcd on t3(a,b,c,d);

create table t4 (a int, b int, c int, d int);
create reverse index i4_a on t4(a);
create reverse index i4_ab on t4(a,b);
create reverse index i4_abc on t4(a,b,c);
create reverse index i4_abcd on t4(a,b,c,d);

insert into t1 values (1,1,1,1),(2,2,2,2),(3,3,3,3);
insert into t2 values (1,1,1,1),(2,2,2,2),(3,3,3,3);
insert into t3 values (1,1,1,1),(2,2,2,2),(3,3,3,3);
insert into t4 values (1,1,1,1),(2,2,2,2),(3,3,3,3);
update statistics on all classes;
--test
select /*+ recompile */ * from t1 use index (i1_abcd) where a>0 order by a desc for orderby_num()>1;

--test
select /*+ recompile */ * from t1 use index (i1_abcd) where a>0 order by a desc for orderby_num() between 2 and 3;

--test
select /*+ recompile */ * from t1 use index (i1_abcd) where a>0 using index i_ab  order by a desc for orderby_num() between 1 and 1;

--test
select /*+ recompile */ * from t1 use index (i1_abcd) where a>0 using index i1_ab(+)  order by a desc for orderby_num() between 1 and 1;

--test
select /*+ recompile */ * from t1 use index (i1_abcd) where a>0 using index i1_ab(+)  order by 1 desc for orderby_num() between 1 and 1;

--test
select /*+ recompile */ * from t1 use index (i1_ab) where b>0 order by b desc;

--test
select /*+ recompile */ * from t1,t2,t3,t4 use index (i1_a,i1_ab,i1_abc,i1_abcd, i2_a,i2_ab,i2_abc,i2_abcd,i3_a,i3_ab,i3_abc,i3_abcd,i4_a,i4_ab,i4_abc,i4_abcd) where t1.a>0 order by t1.a desc;

--test:  todo: should fail
select /*+ recompile */ sum(t1.a) from t1,t2,t3,t4 force index (i1_a,i1_ab,i1_abc,i1_abcd, i2_a,i2_ab,i2_abc,i2_abcd,i3_a,i3_ab,i3_abc,i3_abcd,i4_a,i4_ab,i4_abc,i4_abcd) where t1.a>0 order by t1.a desc;

--test:  todo: should fail
select /*+ recompile */ sum(t1.a) from t1,t2,t3,t4 ignore index (i1_a,i1_ab,i1_abc,i1_abcd, i2_a,i2_ab,i2_abc,i2_abcd,i3_a,i3_ab,i3_abc,i3_abcd,i4_a,i4_ab,i4_abc,i4_abcd) where t1.a>0 order by t1.a desc;

--test: todo: should fail
select /*+ recompile */ sum(t1.a) from t1,t2,t3,t4 ignore index (i1_a,i1_ab,i1_abc,i1_abcd, i2_a,i2_ab,i2_abc,i2_abcd,i3_a,i3_ab,i3_abc,i3_abcd,i4_a,i4_ab,i4_abc,i4_abcd) where t1.a>0 order by t1.a desc;

select /*+ recompile */ sum(t1.a) from t1,t2,t3,t4 where t1.a>0 using index all except i1_a,i1_ab,i1_abc,i1_abcd, i2_a,i2_ab,i2_abc,i2_abcd,i3_a,i3_ab,i3_abc,i3_abcd,i4_a,i4_ab,i4_abc,i4_abcd  order by t1.a desc;

drop table t1;
drop table t2;
drop table t3;
drop table t4;
commit;
--+ holdcas off;
