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
create view vt as select /*+ recompile */ * from t limit 100;
create view vu as select /*+ recompile */ * from u limit 100;
create view vv as select /*+ recompile */ * from v limit 100;

commit;

select 'table joined with view';

-- T -> VU (rewrite VU)
delete u from t left join u on t.i = u.i;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.i order by t.i;
delete vu from t left join vu on t.i = vu.i;
select /*+ recompile */ * from t left join u on t.i = u.i order by t.i;
rollback;
-- T x VU
delete u from t, u;
rollback;
select /*+ recompile */ * from t, u order by t.i, u.i;
delete vu from t, vu;
select /*+ recompile */ * from t, u order by t.i, u.i;
rollback;
-- T <- VU
delete u from t right join u on t.i = u.i;
rollback;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
delete vu from t right join vu on t.i = vu.i;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
rollback;

select 'view joined with table';

-- VT -> U
delete t from t left join u on t.i = u.j;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.j order by t.i;
delete vt from vt left join u on vt.i = u.j;
select /*+ recompile */ * from t left join u on t.i = u.j order by t.i;
rollback;
-- VT x U
delete t from t, u;
rollback;
select /*+ recompile */ * from t, u order by t.i, u.i;
delete vt from vt, u;
select /*+ recompile */ * from t, u order by t.i, u.i;
rollback;
-- VT <- U (rewrite VT)
delete t from t right join u on t.i = u.i;
rollback;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
delete vt from vt right join u on vt.i = u.i;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
rollback;

select 'view joined with view';

-- VT -> VU (rewrite VU)
delete t, u from t left join u on t.i = u.i;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.i order by t.i;
delete vt, vu from vt left join vu on vt.i = vu.i;
select /*+ recompile */ * from t left join u on t.i = u.i order by t.i;
rollback;
-- VT x VU
delete t, u from t, u;
rollback;
select /*+ recompile */ * from t, u order by t.i, u.i;
delete vt, vu from vt, vu;
select /*+ recompile */ * from t, u order by t.i, u.i;
rollback;
-- VT <- VU (rewrite VT)
delete t, u from t right join u on t.i = u.i;
rollback;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
delete vt, vu from vt right join vu on vt.i = vu.i;
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i;
rollback;

select 'multiple joins';

-- T -> U x VV
delete v from t left join u on t.i = u.i, v;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.i, v order by t.i, v.i;
delete vv from t left join u on t.i = u.i, vv;
select /*+ recompile */ * from t left join u on t.i = u.i, v order by t.i, v.i;
rollback;
-- T -> U <-> VV
delete v from t left join u on t.i = u.i inner join v on u.i = v.i;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.i inner join v on u.i = v.i order by t.i;
delete vv from t left join u on t.i = u.i inner join vv on u.i = vv.i;
select /*+ recompile */ * from t left join u on t.i = u.i inner join v on u.i = v.i order by t.i;
rollback;

-- VT -> U <- V (rewrite VT)
delete t from t left join u on t.i = u.i right join v on u.i = v.i;
rollback;
select /*+ recompile */ * from t left join u on t.i = u.i right join v on u.i = v.i order by v.i;
delete vt from vt left join u on vt.i = u.i right join v on u.i = v.i;
select /*+ recompile */ * from t left join u on t.i = u.i right join v on u.i = v.i order by v.i;
rollback;
-- VT <-> U  <- V (rewrite VT)
delete t from t inner join u on t.i = u.i right join v on u.i = v.i;
rollback;
select /*+ recompile */ * from t inner join u on t.i = u.i right join v on u.i = v.i order by v.i;
delete vt from vt inner join u on vt.i = u.i right join v on u.i = v.i;
select /*+ recompile */ * from t inner join u on t.i = u.i right join v on u.i = v.i order by v.i;
rollback;
-- VT x U <- V
delete t from t, u right join v on u.i = v.i;
rollback;
select /*+ recompile */ * from t, u right join v on u.i = v.i order by t.i, v.i;
delete vt from vt, u right join v on u.i = v.i;
select /*+ recompile */ * from t, u right join v on u.i = v.i order by t.i, v.i;
rollback;
-- VT x VU x VV
delete t, u, v from t, u, v;
rollback;
select /*+ recompile */ * from t, u, v order by t.i, u.i, v.i;
delete vt, vu, vv from vt, vu, vv;
select /*+ recompile */ * from t, u, v order by t.i, u.i, v.i;
rollback;

-- test deleting from derived table
delete from (select * from t);
delete from (select * from t) x;
rollback;

-- drop stuff
drop view vt, vu, vv;
drop table t, u, v;
commit;

set system parameters 'dont_reuse_heap_file = no';
commit;
autocommit on;
set system parameters 'create_table_reuseoid=yes';
