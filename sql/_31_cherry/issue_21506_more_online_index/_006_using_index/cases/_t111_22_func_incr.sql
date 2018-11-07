--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (a int);
insert into t values (1),(2),(3),(4),(5);

create index i_t_a  on t (a) with online;

select /*+ recompile */ incr(a),decr(a) from t where a>0 using index i_t_a keylimit 0,1;
select /*+ recompile */ incr(a),decr(a) from t where a>0 using index i_t_a keylimit 1,1;
select /*+ recompile */ incr(a),decr(a) from t where a>0 using index i_t_a keylimit 2,1;
select /*+ recompile */ incr(a),decr(a) from t where a>0 using index i_t_a keylimit 3,1;
select /*+ recompile */ incr(a),decr(a) from t where a>0 using index i_t_a keylimit 4,1;
select /*+ recompile */ incr(a),decr(a) from t where a>0 using index i_t_a keylimit 5,1;

select /*+ recompile */ a from t where a>0;

drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
