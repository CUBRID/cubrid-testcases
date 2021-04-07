--+ holdcas on;
create table t (a int, b varchar(20));
insert into t select rownum, cast(rownum as varchar(20)) from db_class a, db_class b, db_class c limit 10000;

create index i_t_a_b on t (a,b);

select /*+ recompile */ * from t where a>0 using index i_t_a_b keylimit 9990,10;

select /*+ recompile */ * from t where a>0 using index i_t_a_b keylimit 9990,10 order by a desc;

drop table t;


commit;
--+ holdcas off;
