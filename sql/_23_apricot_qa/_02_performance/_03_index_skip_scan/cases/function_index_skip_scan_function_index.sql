--+ holdcas on;


drop table if exists b, t;

--Test create too many ranges for ISS
create table b (i int not null auto_increment, j int);

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
create table t (i double, j int, k int, s string);

insert into t(i,j,k, s) select j%5, i, i, i from b;

create index idx1 on t(sign(i),j,k);
update statistics on all classes;
commit;

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

create index idx2 on t(i,j,k);
update statistics on all classes;
commit;

--Test should use ISS because it covers
select /*+ recompile INDEX_SS */ i, j from t where j = 2;

--Test should not use ISS because t(j, k) is better
select /*+ recompile INDEX_SS */ j, k from t where j = 2;

--Test should use ISS 
select /*+ recompile INDEX_SS */ j, k from t where j <= 2 order by i;

--Test should not use ISS because i_t_j_k is better
select /*+ recompile INDEX_SS */ j, k from t where j <=2 and s = '2';

--Test should use ISS because it generates an SKIP ORDER BY plan
select /*+ recompile INDEX_SS */ j, k from t where j <=2 and s = '2' order by i;

drop table t;

drop table b;
commit;
--+ holdcas off;
