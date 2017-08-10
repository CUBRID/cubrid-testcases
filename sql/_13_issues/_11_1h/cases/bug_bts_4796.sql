create table t (id int, a varchar(20));
create index i_t_all on t(id,a);
insert into t values (1, 'test');

select /*+ recompile */ id,a from t where id> 0 and rownum<10000000000;

drop table t;

