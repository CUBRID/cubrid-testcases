--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

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
create index i_t_s on t(s);

update statistics on t;

create table u (i int);
create index i_u_i on u (i);

insert into u select i from t;

update statistics on u;

select /*+ recompile */ t.e, u.i from t, u where t.e = u.i order by t.e;

select /*+ recompile */ t.e, u.i from t, u where t.e = u.i and u.i = 4 order by u.i;

select /*+ recompile */ t.s, u.i from t, u where t.i = u.i order by t.e,2;

select /*+ recompile */ t.e from t, u where t.i = u.i and t.s = 'Monday' order by t.e;

drop table u;

drop table t;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
