--+ holdcas on;

create table t1 (id int, v varchar(20));
create index i_t1_v on t1(v);

insert into t1 values (1, 'dbms qa1 part');
insert into t1 values (2, 'dbms qa1 part');
insert into t1 values (3, 'dbms qa2 part');
insert into t1 values (4, 'dbms qa2 part');


select /*+ recompile */ * from t1 where v like 'dbms qa1%' or (v like 'dbms qa2%' and id>3) using index i_t1_v keylimit 1,3;


select /*+ recompile */ * from t1 where v like 'dbms qa1%' or (v like 'dbms qa2%' and id>3) using index i_t1_v keylimit 0,3;

select /*+ recompile */ * from t1 where v like 'dbms qa1%' or (v like 'dbms qa2%' and id>3) using index i_t1_v keylimit 1,4;


select /*+ recompile */ * from t1 where v like 'dbms qa1%' or (v like 'dbms qa2%' and id>3) using index i_t1_v keylimit 0,4;

drop table t1;

commit;

--+ holdcas off;

