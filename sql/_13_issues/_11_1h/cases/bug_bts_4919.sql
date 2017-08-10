create table t(a int);
insert into t values (1),(1), (2);

--return error message. this is good.
select /*+ recompile */ a,count(*) from t order by a;

--'a' column return NULL value. it is a strange result. we expect result is the same as above query.
select /*+ recompile */ a,count(*) from t order by a limit 1;

drop table t;

