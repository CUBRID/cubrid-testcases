--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(a int,b char(1000), c varchar(1000), d date);
insert into t1 values (1,'Y', 'Monday', DATE('2010-10-27'));
insert into t1 values (2,'N', 'Friday', DATE('2010-10-28'));


create index idx_t1_a on t1(a) where a>1;
create index idx_t1_ab on t1(a,b) where a>1 and b>'A';
create index idx_t1_abc on t1(a,b,c) where a>1 and b>'A' and d>'2010-10-27';
create index idx_t1_abcd on t1(a,b,c,d) where a>1 and b>'A' and c is not null and d>'2010-10-27';

--TEST:  should use index idx_t1_abcd;
select /*+ RECOMPILE */ count(t1.c) from t1 where t1.a>1  and t1.b>'A' and d>'2010-10-27'using index idx_t1_a(+),idx_t1_ab(+),idx_t1_abc(+),idx_t1_abcd(+);

--TEST:  should use index  idx_t1_ab;
select /*+ RECOMPILE */ count(t1.c) from t1 where t1.a>1 and t1.b>'A' and d>'2010-10-2d'using index idx_t1_a(+),idx_t1_ab(+),idx_t1_abc(+);

--TEST:  should use index  idx_t1_abc;
select /*+ RECOMPILE */ count(t1.c) from t1 where t1.a>1 and t1.b>'A' and d>'2010-10-2d'using index idx_t1_a(+),idx_t1_abc(+);
--TEST:  should use index  idx_t1_a;
select /*+ RECOMPILE */ count(t1.c) from t1 where t1.a>1 and t1.b>'A' and d>'2010-10-2d'using index idx_t1_a(+);

drop table t1;



set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
