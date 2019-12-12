create table t ( a int);
insert into t values (1);
insert into t values (2);
insert into t values (0);
insert into t values (null);
create index i_t_a on t(a);

--result is not correct.
select /*+ recompile */ a from t where a<=>null or a is not null order by 1;

drop table t;
