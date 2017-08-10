create table t (id int, a varchar(20));
create index i_t_all on t(id,a);

insert into t values (1, 'dbms qa1 part');
insert into t values (2, 'dbms qa2 part');

select /*+ recompile */ id,a from t where id> 0 and rownum=0;

drop table t;