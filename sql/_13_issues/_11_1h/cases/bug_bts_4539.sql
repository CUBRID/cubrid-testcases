--+ holdcas on;

create table t1 (a int, b int, c int);
insert into t1 values (1,1,1);
insert into t1 values (null,null,null);
insert into t1 values (1,null,null);

create index i_a on t1(a);
create index i_ab on t1(a,b);
create index i_abc on t1(a,b,c);

select /*+ recompile */ * from t1 where rownum>0;

drop table t1;

commit;

--+ holdcas off;
