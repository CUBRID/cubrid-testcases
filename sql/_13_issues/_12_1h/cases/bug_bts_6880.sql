create table t(a int);
insert into t value(1);
create index idx on t(MOD(a,0));
select MOD(a,0) from t;
select/*+recompile*/* from t where MOD(a,0)>0;
drop table t;

