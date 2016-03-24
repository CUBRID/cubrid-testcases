--TEST: [Function Based Index] Query result is not correct when a query use Function based Index and GROUP BY clause

drop table if exists t1;

create table t1 (a int, b int);

create index  i_1 on t1 (sqrt(a));
insert into t1 values (1, 1);
insert into t1 values (2, 2);
insert into t1 values (3, 3);
insert into t1 values (1, 1);
insert into t1 values (2, 2);
insert into t1 values (3, 3);
insert into t1 select rownum+100, rownum+100 from t1;

--below result is good and returns 6 rows;
select /*+ recompile */ a,b,sqrt(a) from t1 where sqrt(a)<=10 order by 1;
--test: below query will use Function Based Index (i_1), but result is not correct.
select /*+ recompile */ sqrt(a),count(*) from t1 where sqrt(a)<=10 group by sqrt(a) using index i_1 order by 1; 
--if not use Function Based Index (i_1), result is good.
select /*+ recompile */ sqrt(a),count(*) from t1 where sqrt(a)<=10 group by sqrt(a) using index none order by 1;


drop table t1;

