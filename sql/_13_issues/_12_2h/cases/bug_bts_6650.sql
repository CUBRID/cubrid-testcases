create table t1(a int,b char(1000), c varchar(1000), d date);
create table t2(a int,b char(1000), c varchar(1000), d date);
create index idx_t1_a1 on t1(a) where a>1;
create index idx_t1_ab1 on t1(a,b) where a>1 and b>'A';
create index idx_t1_abc1 on t1(a,b,c) where a>1 and b>'A' and d>'2010-10-27';
create index idx_t1_abcd1 on t1(a,b,c,d) where a>1 and b>'A' and c is not null and d>'2010-10-27';


create index idx_t2_a1 on t2(a) where a>3;
create index idx_t2_ab1 on t2(a,b) where a>3 and b>'A';
create index idx_t2_abc1 on t2(a,b,c) where a>1 and b>'A' and d>'2010-10-27';
create index idx_t2_abcd1 on t2(a,b,c,d) where a>3 and b>'A' and c is not null and d>'2010-10-27';
create index idx_t2_bc on t2(b,c) where b>'A'  and c is not null;

insert into t1 values (1,'Y', 'Monday', DATE('2010-10-27'));
insert into t1 values (2,'N', 'Friday', DATE('2010-10-28'));
insert into t2 values (3,'Y', 'Monday', DATE('2010-10-29'));
insert into t2 values (4,'N', 'Friday', DATE('2010-10-30'));
insert into t1 values (5,'N', null, DATE('2010-10-28'));
insert into t1 values (6,'N', 'Friday', DATE('2010-10-26'));
SET OPTIMIZATION LEVEL 513;
select /*+ RECOMPILE */ count(t1.c) from t1,t2 where t1.a>1 and t1.b>'A' using index idx_t1_abcd1,idx_t1_abc1;
select /*+ RECOMPILE */ count(t1.c) from t1,t2 where t1.a>1 and t1.b>'A' using index idx_t1_abcd1(+),idx_t1_ab1(+);
drop table t1,t2;