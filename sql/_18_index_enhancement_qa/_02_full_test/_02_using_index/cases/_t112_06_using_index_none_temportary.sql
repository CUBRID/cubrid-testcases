--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (a int, b varchar(20));
insert into t select rownum, cast(rownum as varchar(20)) from db_class a, db_class b, db_class c limit 50000;

create index i_t_a_b on t (a,b);
create index i_t_b_a on t (b,a);

select /*+ recompile use_merge */ * from 
(select * from t where a>0 using index i_t_a_b keylimit 99990,10) x, 
(select * from t where b>'0' using index i_t_b_a keylimit 99990,10) y
where x.a=y.a using index none;

drop table t;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
