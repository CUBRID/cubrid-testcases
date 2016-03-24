drop table if exists a,b,t;
create table b (i int auto_increment, j int);
insert into b (j) values(NULL);
insert into b (j) select 1 from b;
insert into b (j) select 2 from b;
insert into b (j) select 3 from b;
insert into b (j) select 4 from b;
insert into b (j) select 5 from b;
insert into b (j) select 6 from b;
insert into b (j) select 7 from b;
insert into b (j) select 8 from b;
insert into b (j) select 9 from b;
insert into b (j) select 10 from b;
insert into b (j) select 11 from b;
insert into b (j) select 12 from b;
insert into b (j) select 12 from b;
insert into b (j) select 12 from b;
insert into b (j) select 12 from b;

create table t (i int, j int, k int, s string);
insert into t(i,j,k, s) select j, i, i, i from b;
create index i_t_i_j_k on t(i,j,k);

update statistics on all classes;
select /*+ recompile INDEX_SS */ i, j from t where j = 2;
create index i_t_j_k on t(j,k);
select /*+ recompile */ i, j from t where j = 2;
select /*+ recompile */ i, j from t where i= 2 order by j;
select /*+ recompile */ i, j from t where i= 2 ;
create index i_t_i_j on t(i,j);
update statistics on all classes with fullscan;
select /*+ recompile */ i, j from t where i= 2 ;
drop b,t;

drop table if exists foo, bar;

create table foo (l int, m int, n int, s string);

insert into foo values (0, 0, 0, 'abcdefghijklmnopqrstuvwxyz');

insert into foo select 0, m+1, n+1, s from foo;
insert into foo select 0, m+2, n+2, s from foo;
insert into foo select 0, m+4, n+4, s from foo;
insert into foo select 0, m+8, n+8, s from foo;
insert into foo select 0, m+16, n+16, s from foo;
insert into foo select 0, m+32, n+32, s from foo;
insert into foo select 0, m+64, n+64, s from foo;
insert into foo select 0, m+128, n+128, s from foo;
insert into foo select 0, m+256, n+256, s from foo;
insert into foo select 0, m+512, n+512, s from foo;

create index idx_m_n on foo (m, n);
create index idx_l_m_n on foo (l, m, n);

create table bar (l int, m int primary key, s string);
insert into bar values (0, 0, 'abcdefghijklmnopqrstuvwxyz');

update statistics on foo with fullscan;
update statistics on bar with fullscan;

set optimization level 513;
select /*+ RECOMPILE */ * 
from bar b 
where b.l in (select distinct f.l from foo f where f.m = b.m);
drop foo ,bar;
create table a (i int auto_increment);
insert into a (i) values(NULL);
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
create table t (i int, j int, k int, s string);
insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, i, i, i from a;
insert into t(i,j,k, s) select 1, i, i, i from a;
insert into t(i,j,k, s) select 2, i, i, i from a;
insert into t(i,j,k, s) select 3, i, i, i from a;
insert into t(i,j,k, s) select 4, i, i, i from a;
insert into t(i,j,k, s) select 5, i, i, i from a;
create index idx_i_j_k on t(i,j,k);
create index idx_j_k on t(j, k);
update statistics on all classes;
select /*+ recompile */ i, j from t where j = 2 order by 1;
set optimization level 514;
select /*+ recompile */ i, j,k from t where j = 2 order by k;
set optimization  level 513;
select /*+ recompile */ i, j,k from t where j = 2 order by k,i desc;
drop a,t;

