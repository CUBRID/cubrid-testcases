--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

drop table if exists t;
create table t(i int auto_increment, enum_col enum ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') collate utf8_en_cs, str_col varchar(255) collate utf8_en_cs);
show full columns from t;

insert into t(i) values(null);
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;
insert into t(i) select null from t;

update t set enum_col = (i % 7) + 1;
update t set str_col = enum_col;

create index i_t_i on t(i);
create index i_t_i_e on t(i, enum_col);
create index i_t_i_e_s on t(i, enum_col, str_col);
create index i_t_e_s on t(enum_col, str_col);
create index i_t_e_i on t(enum_col, i);
create index i_t_e on t(enum_col);

update statistics on t;

select /*+ recompile */ enum_col from t where enum_col < 2;

select /*+ recompile */ i, enum_col from t where i = 2 and enum_col < 3;

select /*+ recompile */ i, enum_col from t where i = 2 and enum_col < 'Wednesday';

select /*+ recompile */ enum_col from t where enum_col between 'Tuesday' and 'Saturday';

select /*+ recompile */ i, enum_col from t where enum_col = 3 and str_col < 'x' order by enum_col,str_col,i;

select /*+ recompile */ i, enum_col from t where enum_col = 'Wednesday' and str_col < 'x' order by enum_col,str_col,i;

select /*+ recompile */ enum_col from t where enum_col < 10;

select /*+ recompile */ enum_col from t where enum_col in ('Tuesday', 'Thursday') order by enum_col;

select i, enum_col, str_col from t where i < 10 order by i, enum_col, str_col;

drop table t;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
