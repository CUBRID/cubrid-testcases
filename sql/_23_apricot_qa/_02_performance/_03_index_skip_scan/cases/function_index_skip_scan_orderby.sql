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
--test
create index idx on t(i asc,j desc,k desc,l asc);
update statistics on all classes;
commit;
--test order by skipping: skip
select /*+ recompile */ i,j,k,l from t where j=2 and s <> 'x'  order by i asc, j desc, k desc limit 10 ;

--test no skip
select /*+ recompile */ i,j,k,l from t where j=2 and s <> 'x'  order by i asc, j desc, l desc limit 10 ;

--test skip, descending index
select /*+ recompile */ i,j,k,l from t where j=2 and s <> 'x'  order by i desc limit 10 ;

--test skip, descending index
select /*+ recompile */ i,j,k,l from t where j=2 and s <> 'x'  order by i desc, k asc limit 10 ;

--test skip
select /*+ recompile */ i,j,k,l from t where j>2 and i <> 0 and s <> 'x'  order by i asc, j desc, k desc, l asc limit 10 ;

--test skip, because it ignores the sort parameter j (it is pinned to "2" by the condition)
select /*+ recompile */ i,j,k,l from t where j=2 and i <> 0 and s <> 'x'  order by i asc, j asc, k desc, l asc limit 10 ;

--test no skip ordby, j is no longer in an equality condition
select /*+ recompile */ i,j,k,l from t where j>2 and i <> 0 and s <> 'x'  order by i asc, j asc limit 10 ;

--test skip order by, because directions coincide 
select /*+ recompile */ i,j,k,l from t where j>2 and i <> 0 and s <> 'x'  order by i asc, j desc limit 10 ;


--test no skip
select /*+ recompile */ i,j,k,l from t where j>2 and i <> 0 and s <> 'x'  order by i asc, j desc, k desc, l desc limit 10 ;

--test no skip
select /*+ recompile */ i,j,k,l from t where j>2 and i <> 0 and s <> 'x'  order by i asc, j asc, k asc, l desc limit 10 ;

--test "ghost columns" introduced by "order by":
-- iss, skip ordby
select /*+ recompile */ k from t where j>2 and s <> 'x'  order by i asc limit 10 ;
--test no iss, just covering
select /*+ recompile */ k from t where k>2 and s <> 'x'  order by i asc, j desc limit 10 ;
--test no iss
select /*+ recompile */ k from t where k=2 and s <> 'x'  order by j desc limit 10 ;


drop table t;
commit;
--+ holdcas off;