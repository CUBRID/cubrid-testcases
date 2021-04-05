--+ holdcas on;

create table dummy1 (i int);
create table dummy2 (i int);
create table dummy3 (i int);
create table dummy4 (i int);
create table dummy5 (i int);

create table di (i int);
create index i_di_i on di (i);
insert into di values (5),(3),(1),(4),(3),(5),(2),(5);

create table dj (i int);
create index i_dj_i  on dj (i);
insert into dj values (5),(3),(1),(4),(3),(5),(2),(5);

create table dk (i int, x int);
create index i_dk on dk (i, x);
insert into dk values (5,1),(3,9),(1,9),(4,9),(3,9),(5,2),(2,9),(5,3);


select /*+ recompile */ * from di, dj where di.i > 0 and di.i = dj.i order by di.i desc limit 3;
select /*+ recompile use_desc_idx*/ * from di, dj where di.i > 0 and di.i = dj.i order by di.i desc limit 3;

-- desc index is forced to all scans in query
select /*+ recompile */ * from di, dk where di.i > 0 and di.i = dk.i and dk.x > 0 order by di.i desc limit 3;
drop index i_dk on dk;
create reverse index i_dk_rev on dk (i, x);
-- desc index is still forced
select /*+ recompile */ * from di, dk where di.i > 0 and di.i = dk.i and dk.x > 0 order by di.i desc limit 3;
drop reverse index i_dk_rev on dk;
-- no index on dk, desc idx still detected as a valid option for di
select /*+ recompile */ * from di, dk where di.i > 0 and di.i = dk.i and dk.x > 0 order by di.i desc limit 3;
-- extra colunm to sort, temp sort plan required
select /*+ recompile */ * from di, dk where di.i > 0 and di.i = dk.i and dk.x > 0 order by di.i desc, dk.x limit 3;

-- three way join - still skipping order by
select /*+ recompile */ * from di, dj, dk where di.i > 0 and di.i = dj.i and dj.i = dk.i order by di.i desc limit 3;

-- no longer qualifies for iscan because there is no condition on di.i to prevent it from being NULL
-- will yield different results because is not fully ordered.
-- select /*+ recompile */ * from di, dj, dk where dj.i > 0 and di.i = dj.i and dj.i = dk.i order by di.i desc limit 3;

-- recreate the table with not null constraint
drop table di;
create table di (i int not null);
create index i_di_i  on di (i);
insert into di values (5),(3),(1),(4),(3),(5),(2),(5);

-- same query as before, now works even though there is no index on
select /*+ recompile */ di.i, dj.i, dk.i from di, dj, dk where di.i > 0 and  di.i = dj.i and dj.i = dk.i order by di.i desc limit 3;

drop table di;
drop table dj;
drop table dk;

drop table dummy1;
drop table dummy2;
drop table dummy3;
drop table dummy4;
drop table dummy5;


commit;

--+ holdcas off;


