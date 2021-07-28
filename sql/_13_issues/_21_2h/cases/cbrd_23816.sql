--skewed data
drop table if exists t1; create table t1 (a int, b int, c int);
insert into t1 select mod(rownum,2) ,mod(rownum,10),mod(rownum,20) from db_class a, db_class b, db_class c, db_class d limit 200000;

set trace on;
select /*+ ordered */ count(*) from (select * from t1 limit 100) a, (select * from t1 limit 200000) b where a.a = b.a and a.b = b.b and a.c = b.c;
show trace;
set trace off;

--uniform data
drop table if exists t1; create table t1 (a int, b int, c int);
insert into t1 select rownum,rownum,rownum from db_class a, db_class b, db_class c, db_class d limit 200000;

set trace on;
select /*+ ordered */ count(*) from (select * from t1 limit 100) a, (select * from t1 limit 200000) b where a.a = b.a and a.b = b.b and a.c = b.c;
show trace;
set trace off;
drop t1;
