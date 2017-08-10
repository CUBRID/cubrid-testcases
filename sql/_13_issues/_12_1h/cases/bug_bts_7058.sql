create table t(i int,j int,primary key(i,j));
create index i_mod_j_2 on t(mod(j,2));

select /*+ recompile*/ * from t where i=0 and mod(j,2)=1 using index i_mod_j_2;
select /*+ recompile*/ * from t where i=0 and mod(j,2)=1 using index i_mod_j_2(+);

alter table t partition by hash(j) partitions 3;
insert into t values(1,11),(0,3);
select /*+ recompile*/ * from t where i=0 and mod(j,2)=1 using index i_mod_j_2;
select /*+ recompile*/ * from t where i=0 and mod(j,2)=1 using index i_mod_j_2(+);

drop t;
