create table t(a double);
create index idx on t(log10(a));
insert into t values (1);
select /*+ recompile */ a from t where log10(a)=0;
select /*+ recompile */ a from t x where log10(a)=0;
drop table t;

