--TEST: [index skip scan] Consider to use ISS in UPDATE and DELETE statement

set system parameters 'dont_reuse_heap_file = yes';

drop table if exists t1;

CREATE TABLE t1 (a INT, b INT, c CHAR(3));
insert into t1 select rownum%2, rownum, 'CHN'  from db_class a, db_class b, db_class c, db_class d limit 10000;

create index i_t1_a_b on t1 (a, b);

update statistics on all classes;
--ISS is used. This is good.
select /*+ recompile INDEX_SS */ * from t1 where b=10;
--we expect ISS is used for below two statement
update /*+ recompile */ t1 set c='ABC' where b=10;
delete /*+ recompile */ from t1 where b=10;
update /*+ recompile */ t1 set c='ABC' where b<100;
delete /*+ recompile */ from t1 where b<=100;

select /*+ recompile */ count(*) from t1;


drop table t1;

set system parameters 'dont_reuse_heap_file = no';
