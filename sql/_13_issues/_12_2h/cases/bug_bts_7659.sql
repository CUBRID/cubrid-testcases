drop table if exists t1;
CREATE TABLE t1 (a INT, b INT, c CHAR(3));
insert into t1 select rownum%2, rownum%10000, 'CHN'  from db_class a, db_class b, db_class c, db_class d limit 10000;
insert into t1 values (9, 10, 'Y');

select a,b,c from t1 where b=10 order by 1,2,3;

--execute below statement repeatedly, you will see that result is not always consistent.
select /*+ recompile */ incr(a),a,b,c from t1 where b=10;

select /*+ recompile */ incr(a),a,b,c from t1 where b=10;

select /*+ recompile */ incr(a),a,b,c from t1 where b=10;

select incr(a),a,b,c from t1 where b=10;

select incr(a) from t1 ;

drop table t1;




