create table t(i int,j int);

create index idx1 on t (mod(j, 2));
create index idx2 on t (abs(i));
create index idx3 on t (i, abs(j));
create index idx4 on t (i, mod(j,2));

insert into t values (0, 0);
insert into t values (1, 0);
insert into t values (1, 1);
insert into t values (0, 1);

select /*+ recompile */ * from t where i = 0 and mod(j, 2) = 1 using index idx1(+);

select /*+ recompile */ * from t where abs(i) = 1 using index idx2(+);

select /*+ recompile */ * from t where i = 0 and abs(j) = 1 using index idx3(+);

select /*+ recompile */ * from t where i = 1 and mod(j,2) = 0 using index idx4(+);

drop table t;
