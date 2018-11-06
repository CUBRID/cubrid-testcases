--+ holdcas on;
set system parameters 'dont_reuse_heap_file = yes';

-- create and populate tables
drop table if exists t,t3;
create table t3(i int);
insert into t3(i) values(1),(2),(3);
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

select 'table joined with view';

-- T -> VU (rewrite VU)
select /*+ recompile */ * from t left join vu on t.i = vu.i order by t.i;

WITH mycte(a,b,c,d) AS
(
select /*+ recompile */ * from t left join u on t.i = u.i order by t.i
)
delete from t3 where i <=(select count(*) from mycte);

-- T x VU
select /*+ recompile */ * from t, vu order by t.i, vu.i;

WITH mycte(a,b,c,d) AS
(
select /*+ recompile */ * from t, u order by t.i, u.i
)
delete from t3 where i <=(select count(*) from mycte);

-- T <- VU
select /*+ recompile */ * from t right join vu on t.i = vu.i order by vu.i;

WITH mycte(a,b,c,d) AS
(
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i
)
delete from t3 where i <=(select count(*) from mycte);

select 'view joined with table';

-- VT -> U
select /*+ recompile */ * from vt left join u on vt.i = u.j order by vt.i;

WITH mycte(a,b,c,d) AS
(
select /*+ recompile */ * from t left join u on t.i = u.j order by t.i
)
delete from t3 where i <=(select count(*) from mycte);

-- VT x U
select /*+ recompile */ * from vt, u order by vt.i, u.i;

WITH mycte(a,b,c,d) AS
(
select /*+ recompile */ * from t, u order by t.i, u.i
)
delete from t_delete_20181018 where i <=(select count(*) from mycte);

-- VT <- U (rewrite VT)
select /*+ recompile */ * from vt right join u on vt.i = u.i order by u.i;

WITH mycte AS
(
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i
)
delete from t_delete_20181018 where i <=(select count(*) from mycte);

select 'view joined with view';

-- VT -> VU (rewrite VU)
select /*+ recompile */ * from vt left join vu on vt.i = vu.i order by vt.i;

WITH mycte(a,b,c,d) AS
(
select /*+ recompile */ * from t left join u on t.i = u.i order by t.i
)
delete from t_delete_20181018 where i <=(select count(*) from mycte);

-- VT x VU
select /*+ recompile */ * from vt, vu order by vt.i, vu.i;

WITH mycte(a,b,c,d) AS
(
select /*+ recompile */ * from t, u order by t.i, u.i
)
delete from t3 where i <=(select count(*) from mycte);

-- VT <- VU (rewrite VT)
select /*+ recompile */ * from vt right join vu on vt.i = vu.i order by vu.i;

WITH mycte(a,b,c,d)AS
(
select /*+ recompile */ * from t right join u on t.i = u.i order by u.i
)
delete from t3 where i <=(select count(*) from mycte);

select 'multiple joins';

-- T -> U x VV
select /*+ recompile */ * from t left join u on t.i = u.i, vv order by t.i, vv.i;

WITH mycte(a,b,c,d) AS
(
select /*+ recompile */ * from t left join u on t.i = u.i, v order by t.i, v.i
)
delete from t3 where i <=(select count(*) from mycte);

-- T -> U <-> VV
select /*+ recompile */ * from t left join u on t.i = u.i inner join vv on u.i = vv.i order by t.i;

WITH mycte(a,b,c,d,e,f)) AS
(
select /*+ recompile */ * from t left join u on t.i = u.i inner join v on u.i = v.i order by t.i
)
delete from t3 where i <=(select count(*) from mycte);

-- VT -> U <- V (rewrite VT)
select /*+ recompile */ * from vt left join u on vt.i = u.i right join v on u.i = v.i order by v.i;

WITH mycte(a,b,c,d,e,f) AS
(
select /*+ recompile */ * from t left join u on t.i = u.i right join v on u.i = v.i order by v.i
)
delete from t3 where i <=(select count(*) from mycte);

-- VT <-> U  <- V (rewrite VT)
select /*+ recompile */ * from vt inner join u on vt.i = u.i right join v on u.i = v.i order by v.i;

WITH mycte(a,b,c,d,e,f) AS
(
select /*+ recompile */ * from t inner join u on t.i = u.i right join v on u.i = v.i order by v.i
)
delete from t3 where i <=(select count(*) from mycte);

-- VT x U <- V
select /*+ recompile */ * from vt, u right join v on u.i = v.i order by vt.i, v.i;

WITH mycte(a,b,c,d,e,f) AS
(
select /*+ recompile */ * from t, u right join v on u.i = v.i order by t.i, v.i
)
delete from t3 where i <=(select count(*) from mycte);

-- VT x VU x VV
select /*+ recompile */ * from vt, vu, vv order by vt.i, vu.i, vv.i;

WITH mycte(a,b,c,d,e,f) AS
(
select /*+ recompile */ * from t, u, v order by t.i, u.i, v.i
)
delete from t3 where i <=(select count(*) from mycte);

-- drop views
drop view vt, vu, vv;

drop table t, u, v;

commit;

set system parameters 'dont_reuse_heap_file = no';

commit;

--+ holdcas off;


