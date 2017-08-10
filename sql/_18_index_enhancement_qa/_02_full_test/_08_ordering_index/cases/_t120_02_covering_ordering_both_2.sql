--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t(a integer not null, b integer, c integer, d varchar(256));

insert into t values (4, 5, 6, '456'), (3, 4, 5, '345'), (2, 3, 4, '234'), (5, 8, 7, '587'), (5, 9, 9, '599');
create index i_t_a_b_c  on t(a, b, c);

--result is good. both covering index and ordering index are used.
select /*+ recompile */ a,b,c from t where b=8 order by a desc ,c desc;
--index i_t_a_b_c is adopt. But not skip order by. We expect 'skip ORDER BY'
select /*+ recompile */ a,  c from t where b=8 order by a desc ,c desc;
--the same with above query
select /*+ recompile */ a     from t where b=8 order by a desc ,c desc;

drop table t;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
