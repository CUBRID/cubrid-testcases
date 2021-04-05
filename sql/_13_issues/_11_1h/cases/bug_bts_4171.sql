--+ holdcas on;

create table t1(c1 int, c2 int, c3 int);
create index i_23 on t1(c2,c3);
create index i_2 on t1(c2);
insert into t1 values (null, null, null);
insert into t1 values (1, 1, 1);

--TEST:  index i_2 should be used.
select /*+ recompile */ c2 from t1 where c2 is not null using index i_2(+);

drop table t1;

commit;

--+ holdcas off;

