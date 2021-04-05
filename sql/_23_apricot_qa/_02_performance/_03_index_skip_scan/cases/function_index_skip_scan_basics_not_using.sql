--+ holdcas on;
create table t (i int not null, j int, k int, l int, s string);
INSERT INTO t values (1,6,565,1346,'J');
INSERT INTO t values (2,8,3717,1294,'B');
INSERT INTO t values (2,7,203,1700,'D');
INSERT INTO t values (1,10,3498,1189,'B');
INSERT INTO t values (0,10,2503,1070,'D');
INSERT INTO t values (1,2,4231,1944,'A');
INSERT INTO t values (2,7,3472,1230,'D');
INSERT INTO t values (1,5,2480,1340,'C');
INSERT INTO t values (1,1,4089,1992,'D');
INSERT INTO t values (2,8,1625,1046,'H');
INSERT INTO t values (1,8,4096,1858,'K');
INSERT INTO t values (1,4,1993,1900,'D');
INSERT INTO t values (1,8,811,1271,'F');
INSERT INTO t values (0,7,4570,1909,'D');
INSERT INTO t values (1,6,3962,1153,'B');
INSERT INTO t values (2,7,924,1466,'C');
INSERT INTO t values (1,9,720,1557,'D');
INSERT INTO t values (2,4,2529,1939,'B');

create index idx on t(i,j,k,l);
update statistics on all classes;
-- test
select /*+ recompile */ i,j,k,l from t where j = 9 and k = 4861 using index none;

-- cases when it should NOT perform index skip scan...
select /*+ recompile */ i,j,k,l from t where i = 5;
-- test
select /*+ recompile */ i,j,k,l from t where i > 2;
-- test
select /*+ recompile */ i,j,k,l from t where j <> 2 limit 10;
-- test
select /*+ recompile */ i,j,k,l from t where j is not null and l = 1001;
-- test
select /*+ recompile */ i,j,k,l from t where i = 5 ;
-- test
select /*+ recompile */ i,j,k,l from t where i > 2 ;
-- test
select /*+ recompile */ i,j,k,l from t where j <> 2  limit 10 ;
-- test
select /*+ recompile */ i,j,k,l from t where j is not null and l = 1001 ;
-- test
select /*+ recompile */ i,j,k,l from t where j = 10 and l > 1800 ;
--test
select /*+ recompile */ i,j,k,l from t where l > 1800 and s <> 'x' ;
--test
select /*+ recompile */ count(*) from t where l > 1800 and s <> 'x' ;
--test
select /*+ recompile */ * from t where l > 1800 and s <> 'x' ;
drop table t;
commit;
--+ holdcas off;