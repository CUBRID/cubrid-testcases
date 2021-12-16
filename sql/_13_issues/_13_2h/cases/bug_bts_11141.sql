set system parameters 'dont_reuse_heap_file=yes';

create table t (i int, j int);

create table u(i int, j int);

insert into t select rownum, rownum from _db_class limit 46;
insert into u select rownum, rownum from _db_class limit 46;

update statistics on all classes;

select /*+ recompile, no_sort_limit */ u.i from u left join t on t.i = u.i where u.j > 5 order by u.j limit 5;

select /*+ recompile, use_nl */ u.i from u left join t on t.i = u.i where u.j > 5 order by u.j limit 5;

select /*+ recompile, use_merge */ u.i from u left join t on t.i = u.i where u.j > 5 order by u.j limit 5;

drop table t;

drop table u;

create table t (i int primary key, j int);

create table u(i int, j int, foreign key fk_u_t_i(i) references t(i));

insert into t select rownum, rownum from _db_class limit 46;
insert into u select rownum, rownum from _db_class limit 46;

update statistics on all classes;

select /*+ recompile, no_sort_limit */ u.i from u left join t on t.i = u.i where u.j > 5 order by u.j limit 5;

select /*+ recompile, use_nl */ u.i from u left join t on t.i = u.i where u.j > 5 order by u.j limit 5;

select /*+ recompile, use_merge */ u.i from u left join t on t.i = u.i where u.j > 5 order by u.j limit 5;


drop table u;
drop table t;

set system parameters 'dont_reuse_heap_file=no';
