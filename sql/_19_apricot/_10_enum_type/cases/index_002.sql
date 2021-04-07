--+ holdcas on;

create table t(i int auto_increment, e enum ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), s varchar(255));

insert into t(i) values(null);
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;

update t set e = (i % 7) + 1;
update t set s = e;

create index i_t_i on t(i);
create index i_t_i_e on t(i, e);
create index i_t_i_e_s on t(i, e, s);
create index i_t_e_s on t(e, s);
create index i_t_e_i on t(e, i);
create index i_t_e on t(e);

update statistics on t;

select /*+ recompile */ e from t where e < 2;

select /*+ recompile */ i, e from t where i = 2 and e < 3;

select /*+ recompile */ i, e from t where i = 2 and e < 'Wednesday';

select /*+ recompile */ e from t where e between 'Tuesday' and 'Saturday';

select /*+ recompile */ i, e from t where e = 3 and s < 'x' order by e,s,i;

select /*+ recompile */ i, e from t where e = 'Wednesday' and s < 'x' order by e,s,i;

select /*+ recompile */ e from t where e < 10;

select /*+ recompile */ e from t where e in ('Tuesday', 'Thursday') order by e;

select i, e, s from t where i < 10 order by i, e, s;

drop table t;
commit;
--+ holdcas off;
