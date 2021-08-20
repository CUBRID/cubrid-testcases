drop table if exists t;

create table t (cola int, colb varchar(3), colc int, cold int);
insert into t values (1, 'ABC', 2, 3), (2, 'BCD', 3, 4), (3, 'CDE', 4, 5), (4, 'DEF', 5, 6), (5, 'EFG', 6, 7);
select /*+ recompile */ * from t where (cola,colb) = (select cola,colb from t where cola in (3,4) order by cold desc limit 1);
select cola, (select colb from t where cola = a.cola order by cold desc limit 1) from t a where cola=4;
select * from (select colb from t where cola in (3,4) order by cold desc limit 1) where colb='DEF';

drop table t;
