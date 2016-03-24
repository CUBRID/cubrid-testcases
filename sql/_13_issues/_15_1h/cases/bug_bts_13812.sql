get transaction isolation level into :c;
drop table if exists t1;
create table t1 (id int primary key, a int, b int, c int);
create index i_abc on t1(a,b, c);
insert into t1 select rownum, rownum, rownum, rownum from db_class x1, db_class x2 limit 1000;
select /*+ recompile index_ls(t1) */ distinct b from t1 where b<5 limit 1;
set transaction isolation level READ COMMITTED CLASS,READ COMMITTED INSTANCES;
select /*+ recompile index_ls(t1) */ distinct b from t1 where b<5 limit 1;
select /*+ recompile index_ss */ distinct b from t1 where b<5 limit 1;
--not support
--set transaction isolation level READ COMMITTED CLASS,READ UNCOMMITTED INSTANCES;
--select /*+ recompile index_ls(t1) */ distinct b from t1 where b<5 limit 1;
--select /*+ recompile index_ss */ distinct b from t1 where b<5 limit 1;

--set transaction isolation level REPEATABLE READ CLASS ,READ UNCOMMITTED INSTANCES;
--select /*+ recompile index_ls(t1) */ distinct b from t1 where b<5 limit 1;
--select /*+ recompile index_ss */ distinct b from t1 where b<5 limit 1;

set transaction isolation level REPEATABLE READ CLASS ,READ COMMITTED INSTANCES;
select /*+ recompile index_ls(t1) */ distinct b from t1 where b<5 limit 1;
select /*+ recompile index_ss */ distinct b from t1 where b<5 limit 1;


set transaction isolation level REPEATABLE READ CLASS ,REPEATABLE READ INSTANCES;
select /*+ recompile index_ls(t1) */ distinct b from t1 where b<5 limit 1;
select /*+ recompile index_ss */ distinct b from t1 where b<5 limit 1;

set transaction isolation level SERIALIZABLE;
select /*+ recompile index_ls(t1) */ distinct b from t1 where b<5 limit 1;
select /*+ recompile index_ss */ distinct b from t1 where b<5 limit 1;

drop table if exists t1;
set transaction isolation level :c;
