create table t(a int not null,b int);
insert into t values(1,1);
insert into t values(2,2);
create index my_index on t(a) where b>1;
SELECT /*+ recompile */ a from t where b>1 using index my_index(+);
Drop table t;

