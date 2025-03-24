-- Verified for CBRD-25947
-- Issue: The issue where rownum and orderby_num were unnecessarily rewritten during the transformation of a subquery's ORDER BY clause in view merging has been resolved.

drop table if exists t1, t2;

create table t1(c1 int, c2 int);
insert into t1 values(1,1),(2,2),(3,3),(4,4);

create table t2(c1 int);
insert into t2 values(1),(2),(3),(4);

set optimization level 513;

evaluate '1. in-list, main query''s select-list contains rownum';
select /*+ recompile */ * from t2
    where c1 in (select rownum from (select c2 from t1 order by c1 desc));

evaluate '2. main query''s select-list contains rownum/orderby_num()';
select /*+ recompile */ distinct rownum from (select c2 from t1 order by c1 desc);

evaluate '3. in-list, main query contains limit clause';
select /*+ recompile */ * from t2
    where c1 in (select c2 from (select c2 from t1 order by c1 desc) limit 2);

evaluate '4. main query contains limit clause';
select /*+ recompile */ distinct c2 from (select c2 from t1 order by c1 desc) limit 2;

evaluate '5. in-list, subquery''s select-list contains orderby_num()';
select /*+ recompile */ * from t2
    where c1 in (select orderby_num from (select orderby_num() as orderby_num from t1 order by c1 desc));

evaluate '6. subquery''s select-list contains orderby_num()';
select /*+ recompile */ distinct orderby_num from (select orderby_num() as orderby_num from t1 order by c1 desc);

evaluate '7. in-list, subquery contains limit clause';
select /*+ recompile */ * from t2
    where c1 in (select c2 from (select c2 from t1 order by c1 desc limit 2));

evaluate '8. subquery contains limit clause';
select /*+ recompile */ distinct c2 from (select c2 from t1 order by c1 desc limit 2);

evaluate '9. Main query with no_merge';
select rownum from (select /*+ no_merge */ * from t2 order by 1);

evaluate '10. in-list, subquery contains no_merge';
select /*+ recompile */ * from t1
    where c1 in (select rownum from (select /*+ no_merge */ * from t2 order by 1));

drop table if exists t1, t2;
