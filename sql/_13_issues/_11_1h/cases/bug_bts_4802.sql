create table t (i int);

insert into t values (1);
insert into t values (2);
insert into t values (3);
insert into t values (4);
insert into t values (5);
insert into t values (6);

create index i_t_i on t(i);
select /*+ recompile */ t.i  from t order by i limit 1,2;
drop table t;

