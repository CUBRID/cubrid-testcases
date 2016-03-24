create table t1 (id int, v varchar(20));
create index i_t1_v on t1(v(7));

insert into t1 values (1, 'dbms qa1 part');
insert into t1 values (2, 'dbms qa2 part');

select /*+ recompile */ id,v from t1 where v like 'dbms qa1%' using index none;
select /*+ recompile */ id,v from t1 where v like 'dbms qa1%';
select /*+ recompile */ id,v from t1 where v like 'dbms%';

drop table t1;
