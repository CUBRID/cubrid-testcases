drop table if exists t1;
CREATE TABLE t1 (a INT, b INT, c CHAR(3));
insert into t1 select rownum%2, rownum%10000, 'CHN'  from db_class a, db_class b, db_class c, db_class d limit 10000;
select incr(a) from t1 ;
drop table t1;
