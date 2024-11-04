--+ holdcas on;

set system parameters 'dont_reuse_heap_file=yes';
set system parameters 'sort_limit_max_count=5';

create table t (i int primary key);

create table u(i int not null, j int, foreign key fk_u_t(i) references t(i));

insert into t select rownum from _db_class a, _db_class b limit 2000;

insert into u select rownum, rownum from _db_class a, _db_class b limit 2000;

update statistics on all classes;

select /*+ recompile NO_ELIMINATE_JOIN */ u.j from t, u where t.i = u.i order by j limit 4;

select /*+ NO_ELIMINATE_JOIN */ u.j from t, u where t.i = u.i order by j limit 6;

drop table u;
drop table t;

create table t (i int primary key);

create table u(i int not null, j int, foreign key fk_u_t(i) references t(i));

insert into t select rownum from _db_class a, _db_class b limit 2000;

insert into u select rownum, rownum from _db_class a, _db_class b limit 2000;

update statistics on all classes;

prepare x from 'select /*+ recompile NO_ELIMINATE_JOIN */ u.j from t, u where t.i = u.i order by j limit ?, ?';

execute x using 0, 3;

execute x using 2, 7;

deallocate prepare x;

drop table u;
drop table t;

set system parameters 'dont_reuse_heap_file=no';
set system parameters 'sort_limit_max_count=1000';
--+ holdcas off;
