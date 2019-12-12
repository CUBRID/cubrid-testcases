--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
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
-- test no key filter, only range, with order by criteria
select /*+ recompile */ i,j,k,l from t where j = 10 and k > 4000 and s <> 'x'  order by i;
select /*+ recompile */ i,j,k,l from t where j = 10 and k > 4000   order by i;

-- test use descending index: the simple case
select /*+ recompile */ i,j,k,l from t where j = 10 and k > 4000 and s <> 'x'  order by i desc;

-- test still skip order by, regardless of j's orientation, because j is cosntant (=10) 
select /*+ recompile */ i,j,k,l from t where j = 10 and k > 4000 and s <> 'x'  order by i desc, j asc;
-- test
select /*+ recompile */ i,j,k,l from t where j = 10 and k > 4000 and s <> 'x'  order by i desc, j desc;

-- test iss, but no skip order by
select /*+ recompile */ i,j,k,l from t where j = 10 and k > 4000 and s <> 'x'  order by i desc, j asc, k asc;

-- test
select /*+ recompile */ i,j,k,l from t where j = 10 and k > 4000 and s <> 'x'  order by i desc, k asc;

-- test skip order by again:
select /*+ recompile */ i,j,k,l from t where j = 10 and k > 4000 and s <> 'x'  order by i desc, k desc;

drop table t;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;