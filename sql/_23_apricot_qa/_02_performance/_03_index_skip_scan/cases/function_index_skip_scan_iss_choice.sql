--+ holdcas on;
--create a table with a large number of incremental values
create table a (i int auto_increment);
insert into a (i) values(NULL);
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;
insert into a (i) select NULL from a;

create table t (i int, j int, k int, s string);

insert into t(i,j,k, s) select NULL, NULL, NULL, NULL from a;
insert into t(i,j,k, s) select NULL, i, i, i from a;
insert into t(i,j,k, s) select 1, i, i, i from a;
insert into t(i,j,k, s) select 2, i, i, i from a;
insert into t(i,j,k, s) select 3, i, i, i from a;
insert into t(i,j,k, s) select 4, i, i, i from a;
insert into t(i,j,k, s) select 5, i, i, i from a;

create index idx1 on t(i,j,k);

create index idx2 on t(j, k);

update statistics on all classes;

--Test should use ISS because it covers
select /*+ recompile */ i, j from t where j = 2 order by 1;

--Test should not use ISS because t(j, k) is better
select /*+ recompile */ j, k from t where j = 2;

--Test should use ISS 
select /*+ recompile */ j, k from t where j <= 2 order by i;

--Test should not use ISS because i_t_j_k is better
select /*+ recompile */ j, k from t where j <=2 and s = '2';

--Test should use ISS
select /*+ recompile */ j, k from t where j <=2 and s = '2' order by i;

--Test should use t(i,j,k) index and not return NULL values
prepare s from 'select /*+ recompile */ i, j from t where i = ? and j = ?';
execute s using NULL, 2;
execute s using 2, NULL;
execute s using NULL, NULL;
deallocate prepare s;

--Testshould use ISS but not return NULL values for j
prepare s from 'select /*+ recompile */ i, j from t where j = ? order by i';
execute s using NULL;
execute s using 2;
deallocate prepare s;

drop table t;

--Test create too many ranges for ISS
create table b (i int auto_increment, j int);

insert into b (j) values(NULL);
insert into b (j) select 1 from b;
insert into b (j) select 2 from b;
insert into b (j) select 3 from b;
insert into b (j) select 4 from b;
insert into b (j) select 5 from b;
insert into b (j) select 6 from b;
insert into b (j) select 7 from b;
insert into b (j) select 8 from b;
insert into b (j) select 9 from b;
insert into b (j) select 10 from b;
insert into b (j) select 11 from b;
insert into b (j) select 12 from b;
insert into b (j) select 13 from b;
insert into b (j) select 14 from b;
create table t (i int, j int, k int, s string);

insert into t(i,j,k, s) select j%5, i, i, i from b;

create index idx1 on t(i,j,k);
create index idx2 on t(j,k);

update statistics on all classes;

--Test should use ISS because it covers
select /*+ recompile */ i, j from t where j = 2;

--Test should not use ISS because t(j, k) is better
select /*+ recompile */ j, k from t where j = 2;

--Test should use ISS 
select /*+ recompile */ j, k from t where j <= 2 order by i;

--Test should not use ISS because i_t_j_k is better
select /*+ recompile */ j, k from t where j <=2 and s = '2';

--Test should use ISS because it generates an SKIP ORDER BY plan
select /*+ recompile */ j, k from t where j <=2 and s = '2' order by i;

drop table t;

drop table b;
drop table a;
commit;
--+ holdcas off;
