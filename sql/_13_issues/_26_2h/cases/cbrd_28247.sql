/**
 *  This test case verifies CBRD-28247: a statement that reads one CTE twice and runs its
 *  uncorrelated subqueries as parallel subquery jobs returns its rows again when its
 *  cached plan runs a second and a third time.
 *
 *  Before the fix the CTE ran as a parallel subquery job, and the CTE held a parallel
 *  subquery executor of its own. The first execution was right; a later execution of the
 *  cached plan stopped the server. Now a CTE runs first on the thread that dispatches
 *  the jobs, never as a job (fixed by CUBRID/cubrid#8556).
 *
 *  The statement runs three times without a recompile hint, so the second and third
 *  executions reuse the cached plan; the third one is traced. The NO_PARALLEL_SUBQUERY twin
 *  must give the same result block. CTP masks digits, so only trace tokens are checked.
 *
 *  v_pb2 and v_pb3 have the body of v_pb. A view read twice or more in a statement runs once
 *  as a CTE (CBRD-27351), which would take the parallel subquery jobs off this statement,
 *  so each reference reads a different view.
 *
 *  Coverage:
 *    Case 1:  the issue query, three executions of one cached plan
 */

drop view if exists v_pb;
drop view if exists v_pb2;
drop view if exists v_pb3;
drop table if exists t_pa, t_pb;

-- the issue data: thirty rows are enough, the crash needs only the plan shape
create table t_pa (id int, c2 int);
create table t_pb (id int primary key, c0 char(4), c1 numeric(8,2));
insert into t_pa select rownum, mod (rownum, 7) - 2 from db_class limit 30;
insert into t_pb values (1, '', 5);
create view v_pb as select c0 x0, c1 x1 from t_pb group by c0, c1 having c1 >= c1;
create view v_pb2 as select c0 x0, c1 x1 from t_pb group by c0, c1 having c1 >= c1;
create view v_pb3 as select c0 x0, c1 x1 from t_pb group by c0, c1 having c1 >= c1;


evaluate 'Case 1: the issue query three times on one cached plan; result = no_parallel_subquery';
with c as (select t4.x1 x0 from (select t3.c2 x0 from t_pa, t_pa t3) d1 left join v_pb t4 on d1.x0 = t4.x1 where 1 < t4.x0) select t8.x0 from c w5 join v_pb2 t6 on w5.x0 = t6.x1 join c w7 on t6.x1 = w7.x0, v_pb3 t8 where w7.x0 = t8.x1;
with c as (select t4.x1 x0 from (select t3.c2 x0 from t_pa, t_pa t3) d1 left join v_pb t4 on d1.x0 = t4.x1 where 1 < t4.x0) select t8.x0 from c w5 join v_pb2 t6 on w5.x0 = t6.x1 join c w7 on t6.x1 = w7.x0, v_pb3 t8 where w7.x0 = t8.x1;
-- the third execution is traced: parallel workers under SUBQUERY shows the jobs ran
set trace on;
with c as (select t4.x1 x0 from (select t3.c2 x0 from t_pa, t_pa t3) d1 left join v_pb t4 on d1.x0 = t4.x1 where 1 < t4.x0) select t8.x0 from c w5 join v_pb2 t6 on w5.x0 = t6.x1 join c w7 on t6.x1 = w7.x0, v_pb3 t8 where w7.x0 = t8.x1;
show trace;
-- trace goes off before the twin: its plan would stay in the session
set trace off;
with c as (select t4.x1 x0 from (select t3.c2 x0 from t_pa, t_pa t3) d1 left join v_pb t4 on d1.x0 = t4.x1 where 1 < t4.x0) select /*+ no_parallel_subquery */ t8.x0 from c w5 join v_pb2 t6 on w5.x0 = t6.x1 join c w7 on t6.x1 = w7.x0, v_pb3 t8 where w7.x0 = t8.x1;

drop view v_pb;
drop view v_pb2;
drop view v_pb3;
drop table t_pa, t_pb;
