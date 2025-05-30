drop table if exists t1;
create table t1 (a int);
insert into t1 values (1), (2), (3), (4), (5);

select /*+ recompile */ * from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1) ORDER BY a desc limit 1);
select /*+ recompile */ * from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1) ORDER BY a desc for orderby_num() <= 1);
prepare st from 'select /*+ recompile */ * from ((SELECT a from t1 where ?=?) UNION (SELECT * FROM t1) ORDER BY a desc limit 1);';
execute st using 1,0;
deallocate prepare st;

select /*+ recompile */ '1', x.* from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1 ) ORDER BY a desc for orderby_num() <= 1) x;
select /*+ recompile */ '2', x.* from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1 ) ORDER BY a desc limit 1) x;
select /*+ recompile */ '3', x.* from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1 order by a asc) ORDER BY a desc for orderby_num() <= 1) x;
select /*+ recompile */ '4', x.* from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1 order by a asc limit 2) ORDER BY a desc for orderby_num() <= 1) x;
select /*+ recompile */ '5', x.* from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1 order by a asc for orderby_num() <= 2) ORDER BY a desc for orderby_num() <= 1) x;
select /*+ recompile */ '6', x.* from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1 order by a asc limit 2) ORDER BY a desc limit 1) x;
select /*+ recompile */ '7', x.* from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1 order by a asc for orderby_num() <= 2) ORDER BY a desc limit 1) x;
select /*+ recompile */ '8', x.* from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1 order by a asc limit 2) ) x;
select /*+ recompile */ '9', x.* from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1 order by a asc limit 2) ORDER BY a desc) x;

drop t1;
