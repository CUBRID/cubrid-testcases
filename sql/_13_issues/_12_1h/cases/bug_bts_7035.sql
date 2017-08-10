create table t (a varchar(10));

insert into t values ('SQL'),('sQl'),('ABC'),('mtx'),('mBt');

create index idx on t(lower(a));

select /*+ recompile */ count(a) from t where lower(a) > 'mbt';

select /*+ recompile */ count(a) from t x where lower(x.a) > 'mbt';


create view v as select /*+ recompile */ count(a) as num from t where lower(a) > 'mbt';

select /*+ recompile */ * from v;

drop v;
drop t;