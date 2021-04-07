--+ holdcas on;
create table t (id int, a varchar(20));
create index i_t_all on t(id,a);

insert into t values (1, 'dbms qa1 part');
insert into t values (2, 'dbms qa2 part');
insert into t values (3, 'dbms qa2 part');
insert into t values (4, 'aaa');
insert into t values (5, 'bbb');
insert into t values (6, 'ccc');
insert into t values (7, 'AAA');
insert into t values (8, 'ABA');
insert into t values (9, 'BBC');
insert into t values (10, null);
insert into t values (null, null);

set system parameters 'xasl_debug_dump=yes';

select /*+ recompile */ id,a from t where id> 0 and rownum%2=0;
select /*+ recompile */ id,a from t where id> 0 and rownum+1=2;
select /*+ recompile */ id,a from t where id> 0 and rownum*rownum=4;
select /*+ recompile */ 1 from t where id in (1,5) and rownum=2;
select /*+ recompile */ id,a from t where id not in (1,5) and rownum=2;
select /*+ recompile */ id,a from t where id in set{1,2} and rownum<5;


set system parameters 'xasl_debug_dump=no';

drop table t;

commit;
--+ holdcas off;
