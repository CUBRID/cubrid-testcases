--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t2(a integer not null, b integer, c integer, d varchar(256));

insert into t2 values 
(4, 5, 6, '456'), 
(3, 4, 5, '345'), 
(2, 3, 4, '234'), 
(5, 8, 7, '587'), 
(5, 9, 9, '599');

create index i_t2_a_b  on t2(a, b);
create index i_t2_b_a on t2(b, a);
create index i_t2_b_c on t2(b, c);
create index i_t2_a_c on t2(a, c);
create index i_t2_a_b_c  on t2(a, b, c);

update statistics on all classes;
--should use covering index i_t2_b_a
select /*+ recompile */ b from t2 where a < 100 and b > 0 order by b;

--should use covering index i_t2_a_b_c
select /*+ recompile */ b from t2 where a < 100 and b > 0 and c=0 order by b;

--should use covering index i_t2_b_c
select /*+ recompile */ * from t2 where a < 100 and b > 0 using index i_t2_b_c order by b;

--should use covering index i_t2_a_b
select /*+ recompile */ * from t2 where a < 100 and b > 0 using index i_t2_a_b order by b;

--should use none index
select /*+ recompile */ b from t2 where a < 100 and b > 0 using index none order by b;

--should use index i_t2_a_b_c
select /*+ recompile */ b from t2 where a < 100 and b > 0 order by c;

--should use index i_t2_a_b_c
select /*+ recompile */ b from t2 where a < 100 order by c;

--should use index i_t2_b_c
select /*+ recompile */ b from t2 where b>0 order by c;

--should use index i_t2_b_c
select /*+ recompile */ b from t2 where b=8 order by c;

--should use index i_t2_a_c
select /*+ recompile */ a,c from t2 where a=0 order by c;

--should use index i_t2_a_b
select /*+ recompile */ a,b from t2 where b=8 order by b,a;

--should use index i_t2_a_b
select /*+ recompile */ a,b,c from t2 where b>0 order by a,b,c;

--should use index i_t2_a_b_c
select /*+ recompile */ a,c from t2 where b>0 order by a desc ,b desc ,c desc;

--should use index i_t2_a_b_c
select /*+ recompile */ a,c from t2 where b=8 order by a desc ,c desc;


drop table t2;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
