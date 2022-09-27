drop table if exists t;
create table t (ca int, cb int);
insert into t values (1,1),(1,1),(1,1),(2,2),(2,2),(2,2),(2,2),(2,2),(2,2),(2,2),(2,2),(2,2),(3,3);

--normal case
select /*+ recompile */ * from (
select * from (
select /*+ recompile */ rownum rn from t where ca= 2
) where rownum < 5
) where rn >= 3;

create or replace view v as select /*+ recompile */ rownum rn from t where ca= 2;
select /*+ recompile */ * from (
select * from (
select * from v
) where rownum < 5
) where rn >= 3;

select /*+ recompile */ * from (
select /*+ recompile */ rownum rn from t where rownum < 5
) where rn >= 3;

create or replace view v as select /*+ recompile */ rownum rn from t where rownum <10;
select /*+ recompile */ * from (
select /*+ recompile */ * from v
) where rn >= 5 ;

--group by
select /*+ recompile */ * from (
select rownum rn, a.* from (
select /*+ recompile */ ca, max(cb) from t group by ca
) a where rownum < 3
) where rn >= 1;

create or replace view v as select /*+ recompile */ ca, max(cb) cb from t group by ca;
select /*+ recompile */ * from (
select rownum rn, a.* from (
select * from v
) a where rownum < 3
) where rn >= 1;

--order by
select /*+ recompile */ * from (
select rownum rn, a.* from (
select /*+ recompile */ ca, cb from t order by 2 desc
) a where rownum < 10
) where rn >= 7;

create or replace view v as select /*+ recompile */ ca, cb from t order by 2 desc;
select /*+ recompile */ * from (
select rownum rn, a.* from (
select * from v
) a where rownum < 10 
) where rn >= 7;

-- unpushable
select /*+ recompile */ * from (
select rownum rn, a.* from (
select /*+ recompile */ ca, cb from t order by 2 desc
) a where rownum < 10 order by 1
) where rn >= 7;

create or replace view v as select /*+ recompile */ ca, cb from t order by 2 desc;
select /*+ recompile */ * from (
select rownum rn, a.* from (
select * from v
) a where rownum < 10 order by 1
) where rn >= 7;

select /*+ recompile */ * from (
select /*+ */ rownum rn, a.* from (
select /*+ recompile */ ca, cb from t order by 2 desc
) a where rownum < 10
) where rn >= 7 order by 1;

create or replace view v as select /*+ recompile */ ca, cb from t order by 2 desc;
select /*+ recompile */ * from (
select /*+ */ rownum rn, a.* from (
select * from v
) a where rownum < 10
) where rn >= 7 order by 1;

--union (TO_DO)
select /*+ recompile */ * from (
select /*+ */ rownum rn, a.* from (
select /*+ recompile */ ca, cb from t
union all
select /*+ recompile */ ca, cb from t
) a where rownum < 10
) where rn >= 7;

--union + order by
select /*+ recompile */ * from (
select /*+ */ rownum rn, a.* from (
select /*+ recompile */ ca, cb from t
union all
select /*+ recompile */ ca, cb from t
order by 2 desc
) a where rownum < 10
) where rn >= 7;

select /*+ recompile */ * from (
select /*+ */ rownum rn, a.* from (
select /*+ recompile */ ca, cb from t
union all
select /*+ recompile */ ca, cb from t
order by 2 desc
) a where rownum < 10
) where rn >= 7 order by 1;

select /*+ recompile */ * from (
select /*+ */ rownum rn, a.* from (
select /*+ recompile */ ca, cb from t
union all
select /*+ recompile */ ca, cb from t
order by 2 desc
) a where rownum < 10
) where rn >= 7;

select /*+ recompile */ ca, cb from t
union all
select /*+ recompile */ ca, cb from t
limit 10,10;

drop table if exists t;
create table t (ca int, cb int, cc int);
insert into t select rownum/10,rownum/100,rownum from db_class a, db_class b limit 1000;

--normal
select /*+ recompile */ ca, cb, cc from t where ca = 1
union all
select ca, cb, cc from t where cb = 3
limit 10;

--unpushable
-- order by
select /*+ recompile */ ca, cb, cc from t where ca = 1
union all
select ca, cb, cc from t where cb = 3
order by 1,2,3
limit 10;

--union
select /*+ recompile */ ca, cb, cc from t where ca = 1
union
select ca, cb, cc from t where cb = 3
limit 10;

--rownum
select /*+ recompile */ ca, cb, cc from t where ca = 1 and rownum >= 9
union all
select ca, cb, cc from t where cb = 3 and rownum >= 9
limit 10;

--inside query with group by
select /*+ recompile */ ca, cb, cc from t where ca = 1
group by ca, cb, cc
union all
select ca, cb, cc from t where cb = 3
group by ca, cb, cc
limit 10;

--complex query
select /*+ recompile */ ca, count(cb), max(cc) from t where ca = 1
group by ca
union all
select ca, cb, cc from t where cb = 3
union all
select ca, cb, cc from t where cb = 2 and rownum > 3
limit 10;

--union
select /*+ recompile */ ca, count(cb), max(cc) from t where ca = 1
group by ca
union all
select ca, cb, cc from t where cb = 3
union
select ca, cb, cc from t where cb = 2
union all
select ca, cb, cc from t where cb = 2
limit 10;

--distinct
select /*+ recompile */ distinct ca, cb, cc from t where ca = 1
union all
select ca, cb, cc from t where cb = 3
limit 10;

--no_push_pred
select /*+ recompile no_push_pred */ ca, cb, cc from t where ca = 1
union all
select ca, cb, cc from t where cb = 3
limit 10;
drop view v;
drop table t;
