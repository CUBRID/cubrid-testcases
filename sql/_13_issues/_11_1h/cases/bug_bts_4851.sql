--+ holdcas on;

create table t (i1 int, i2 int, i3 int);
create index i_t_123 on t(i1, i2, i3);
insert into t values (0, 0, 00), (0, 1, 01), (0, 2, 02), (0, 3, 03), (0, 4, 04);
insert into t values (1, 0, 10), (1, 1, 11), (1, 2, 12), (1, 3, 13), (1, 4, 14);
insert into t values (2, 0, 20), (2, 1, 21), (2, 2, 22), (2, 3, 23), (2, 4, 24);
insert into t values (3, 0, 30), (3, 1, 31), (3, 2, 32), (3, 3, 33), (3, 4, 34);
insert into t values (4, 0, 40), (4, 1, 41), (4, 2, 42), (4, 3, 43), (4, 4, 44);

--the result is good
select /*+ recompile */ * from t where i1=0 and i2 in (0,1,2,3,4,5) using index i_t_123 keylimit 1 order by i3;

--the result is incorrect.
select /*+ recompile */ * from t where i1=0 and i2 in (0,1,2,3,4,5) using index i_t_123 keylimit 1 order by i3 for orderby_num()<=3;


drop table t;

commit;

--+ holdcas off;

