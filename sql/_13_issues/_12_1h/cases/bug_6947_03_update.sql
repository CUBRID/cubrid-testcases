set system parameters 'create_table_reuseoid=no';
autocommit off;
set system parameters 'dont_reuse_heap_file = yes';

-- create and populate tables
create table t (i int, j int);
create table u (i int, j int);
create table v (i int, j int);

insert into t values (1, 1), (2, 2), (3, 3);
insert into u values (1, 1), (2, 2), (4, 4);
insert into v values (1, 1), (3, 3), (5, 5);

-- create views
create view vt as select /*+ recompile */ * from t where i > 0;
create view vu as select /*+ recompile */ * from u where i < 100;
create view vv as select /*+ recompile */ * from v where i in (1, 3, 5);

commit;

select 'table joined with view';

-- T -> VU (rewrite VU)
update t left join u on t.i = u.i set u.j = 100;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.i order by t.i;
update t left join vu on t.i = vu.i set vu.j = 100;
select /*+ recompile */ * from t left join u on t.i = u.i order by t.i;
rollback;
-- T x VU
update t, u set u.j = 100;
rollback;
select /*+ recompile */ * from t, u order by t.i, u.i;
update t, vu set vu.j = 100;
select /*+ recompile */ * from t, u order by t.i, u.i;
rollback;
-- T <- VU
update t right join u on t.i = u.i set u.j = 100;
rollback;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
update t right join vu on t.i = vu.i set vu.j = 100;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
rollback;

select 'view joined with table';

-- VT -> U
update t left join u on t.i = u.j set t.j = 100;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.j order by t.i;
update vt left join u on vt.i = u.j set vt.j = 100;
select /*+ recompile */ * from t left join u on t.i = u.j order by t.i;
rollback;
-- VT x U
update t, u set t.j = 100;
rollback;
select /*+ recompile */ * from t, u order by t.i, u.i;
update vt, u set vt.j = 100;
select /*+ recompile */ * from t, u order by t.i, u.i;
rollback;
-- VT <- U (rewrite VT)
update t right join u on t.i = u.i set t.j = 100;
rollback;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
update vt right join u on vt.i = u.i set vt.j = 100;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
rollback;

select 'view joined with view';

-- VT -> VU (rewrite VU)
update t left join u on t.i = u.i set t.j = 100, u.j = 100;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.i order by t.i;
update vt left join vu on vt.i = vu.i set vt.j = 100, vu.j = 100;
select /*+ recompile */ * from t left join u on t.i = u.i order by t.i;
rollback;
-- VT x VU
update t, u set t.j = 100, u.j = 100;
rollback;
select /*+ recompile */ * from t, u order by t.i, u.i;
update vt, vu set vt.j = 100, vu.j = 100;
select /*+ recompile */ * from t, u order by t.i, u.i;
rollback;
-- VT <- VU (rewrite VT)
update t right join u on t.i = u.i set t.j = 100, u.j = 100;
rollback;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
update vt right join vu on vt.i = vu.i set vt.j = 100, vu.j = 100;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
rollback;

select 'multiple joins';

-- T -> U x VV
update t left join u on t.i = u.i, v set v.j = 100;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.i, v order by t.i, v.i;
update t left join u on t.i = u.i, vv set vv.j = 100;
select /*+ recompile */ * from t left join u on t.i = u.i, v order by t.i, v.i;
rollback;
-- T -> U <-> VV
update t left join u on t.i = u.i inner join v on u.i = v.i set v.j = 100;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.i inner join v on u.i = v.i order by t.i;
update t left join u on t.i = u.i inner join vv on u.i = vv.i set vv.j = 100;
select /*+ recompile */ * from t left join u on t.i = u.i inner join v on u.i = v.i order by t.i;
rollback;

-- VT -> U <- V (rewrite VT)
update t left join u on t.i = u.i right join v on u.i = v.i set t.j = 100;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.i right join v on u.i = v.i order by v.i;
update vt left join u on vt.i = u.i right join v on u.i = v.i set vt.j = 100;
select /*+ recompile */ * from t left join u on t.i = u.i right join v on u.i = v.i order by v.i;
rollback;
-- VT <-> U  <- V (rewrite VT)
update t inner join u on t.i = u.i right join v on u.i = v.i set t.j = 100;
rollback;
select /*+ recompile */ * from t inner join u on t.i = u.i right join v on u.i = v.i order by v.i;
update vt inner join u on vt.i = u.i right join v on u.i = v.i set vt.j = 100;
select /*+ recompile */ * from t inner join u on t.i = u.i right join v on u.i = v.i order by v.i;
rollback;
-- VT x U <- V
update t, u right join v on u.i = v.i set t.j = 100;
rollback;
select /*+ recompile */ * from t, u right join v on u.i = v.i order by t.i, v.i;
update vt, u right join v on u.i = v.i set vt.j = 100;
select /*+ recompile */ * from t, u right join v on u.i = v.i order by t.i, v.i;
rollback;
-- VT x VU x VV
update t, u, v set t.j = 100, u.j = 100, v.j = 100;
rollback;
select /*+ recompile */ * from t, u, v order by t.i, u.i, v.i;
update vt, vu, vv set vt.j = 100, vu.j = 100, vv.j = 100;
select /*+ recompile */ * from t, u, v order by t.i, u.i, v.i;
rollback;

-- drop stuff
drop view vt, vu, vv;
drop table t, u, v;
commit;

set system parameters 'dont_reuse_heap_file = no';
commit;
autocommit on;
set system parameters 'create_table_reuseoid=yes';
