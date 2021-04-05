--+ holdcas on;

drop table if exists t;
drop table if exists u;
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
create index i_t_s on t(str_col);

update statistics on t;

create table u (i int);
create index i_u_i on u (i);

insert into u select i from t;

update statistics on u;

select /*+ recompile */ t.enum_col, u.i from t, u where t.enum_col = u.i order by t.enum_col;

select /*+ recompile */ t.enum_col, u.i from t, u where t.enum_col = u.i and u.i = 4 order by u.i;

select /*+ recompile */ t.str_col, u.i from t, u where t.i = u.i order by t.enum_col;

select /*+ recompile */ t.enum_col from t, u where t.i = u.i and t.str_col = 'Monday' order by t.enum_col;

drop table u;

drop table t;
commit;
--+ holdcas off;
