--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t(i int primary key, j int);

create table u(i int primary key, j int, k int, foreign key fk_u_t(j) references t(i));

insert into t select rownum, rownum from _db_class a, _db_class b limit 1500;

insert into u select rownum, rownum % 1500 + 1, rownum from _db_class a, _db_class b, _db_class c limit 2000;

create table v (i int, j int, k int);

insert into v select rownum, rownum % 1500 + 1, rownum from _db_class a, _db_class b, _db_class c limit 2000;

update statistics on all classes;

select /*+ recompile */ u.k from u, t, v where u.j = t.i and u.j = v.j order by u.k limit 10;

set system parameters 'sort_limit_max_count=0';

select /*+ recompile */ u.k from u, t, v where u.j = t.i and u.j = v.j order by u.k limit 10;

set system parameters 'sort_limit_max_count=11';

select /*+ recompile */ u.k from u, t, v where u.j = t.i and u.j = v.j order by u.k limit 10;

set system parameters 'sort_limit_max_count=9';

select /*+ recompile */ u.k from u, t, v where u.j = t.i and u.j = v.j order by u.k limit 10;

set system parameters 'sort_limit_max_count=1000';

select /*+ recompile */ u.k from u, t, v where u.j = t.i and u.j = v.j order by u.k limit 10;

drop table v;
drop table u;
drop table t;

set system parameters 'dont_reuse_heap_file=no';

