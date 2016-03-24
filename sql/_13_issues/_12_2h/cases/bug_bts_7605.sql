--TEST:  [index skip scan] ISS doesn't work well with Filtered index and return incorrect result.

drop table if exists t1;

CREATE TABLE t1 (a INT, b int, c int);
insert into t1 select rownum%2, rownum, rownum from db_class a, db_class b, db_class c, db_class d limit 100000;
--create a filtered index
create index i_t1 on t1 (a, b) where a=1;

--should not use index
select /*+ recompile */ a,b,c from t1 where b=10;

--should not use index
select /*+ recompile */ a,b,c from t1 where b=10 using index i_t1;

--should use index
select /*+ recompile */ a,b,c from t1 where b=10 using index i_t1(+);


drop table t1;
