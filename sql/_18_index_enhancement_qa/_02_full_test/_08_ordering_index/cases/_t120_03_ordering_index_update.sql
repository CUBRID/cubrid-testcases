--+ holdcas on;
create table t (a int, b int,c int, d int);
insert into t values (1,1,1,1);
insert into t values (2,2,2,2);
insert into t values (3,3,3,3);
create index i_t_abc on t(a,b,c);
--covering index is used. It's good.
select /*+ recompile */ * from t where a>0 and b=2 order by a,c;
--we expect covering index is used.
update /*+ recompile */t set d=1 where a>0 and b=2 order by a,c;

drop table t;
commit;
--+ holdcas off;
