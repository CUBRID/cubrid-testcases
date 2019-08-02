drop table if exists t1,foo;
create table t1 (a int);
insert into t1 values (1), (2), (3), (4), (5);

select /*+ recompile */ '1', x.* from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1 ) ORDER BY a desc for orderby_num() <= 1) x order by 1;
create table foo as select * from 
(
select /*+ recompile */ '2', x.* from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1 ) ORDER BY a desc limit 1) x limit 3
) cte limit 1;

select * from foo order by 1;
drop table if exists t1,foo;
