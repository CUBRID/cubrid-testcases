-- Verified for CBRD-25947
-- Issue: The issue where rownum and orderby_num were unnecessarily rewritten during the transformation of a subquery's ORDER BY clause in view merging has been resolved.

drop table if exists t1, t2;

create table t1(c1 int, c2 int);
insert into t1 values(1,1),(2,2),(3,3),(4,4);

create table t2(c1 int);
insert into t2 values(1),(2),(3),(4);

evaluate '1. Main query: rownum replaced by orderby_num() when ORDER BY is added';
select /*+ recompile */ rownum from (select c2 from t1 order by c1 desc);

evaluate '1-1. Query 1 with no_merge hint';
select /*+ recompile */ rownum from (select /*+ no_merge */ * from t2 order by 1);

evaluate '2. Main query: rownum remains unchanged when no ORDER BY is added in the main query';
select /*+ recompile */ * from t2
    where c1 in (select rownum from (select c2 from t1 order by c1 desc));

evaluate '2-2. Query 2 with no_merge hint';
select /*+ recompile */ * from t2
    where c1 in (select rownum from (select c2 from t1 order by c1 desc));

evaluate '3. Subquery: orderby_num() replaced by rownum when ORDER BY is removed from subquery';
select /*+ recompile */ * from t2
    where c1 in (select orderby_num from (select orderby_num() as orderby_num from t1 order by c1 desc));

evaluate '4. Subquery: orderby_num() remains unchanged when ORDER BY is retained in subquery';
select /*+ recompile */ orderby_num from (select orderby_num() as orderby_num from t1 order by c1 desc);

evaluate '5. Subquery with LIMIT: view merge disabled and ordering preserved';
select /*+ recompile */ * from t2
    where c1 in (select c2 from (select c2 from t1 order by c1 desc limit 2));

drop table if exists t1, t2;
