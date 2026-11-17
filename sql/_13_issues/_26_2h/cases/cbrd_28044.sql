/**
 *  This test case verifies CBRD-28044: when the arms of a set operation run as parallel
 *  subquery jobs, each arm frees the state of all its correlated subqueries itself.
 *
 *  Before the fix the thread that ran an arm cleared only the first correlated subquery
 *  of a list of the arm. The main thread later freed the state of the others, which the
 *  worker had allocated, from its own heap, and a debug server aborted at the end of the
 *  query. Now each arm clears every subquery of its lists on the thread that ran it.
 *
 *  Each case runs the query with parallel subquery execution, shown by the parallel
 *  workers line of the trace, and then its twin with NO_PARALLEL_SUBQUERY in every arm.
 *  The two result blocks must be identical. CTP masks digits, so only trace tokens count.
 *
 *  Coverage:
 *    Case 1:  the issue query, two correlated subqueries in the WHERE of each arm
 *    Case 2:  the same shape with rows in the result
 *    Case 3:  two correlated subqueries in the select list of each arm
 *    Case 4:  three correlated subqueries in the select list, the first, middle and last
 *    Case 5:  INTERSECTION and DIFFERENCE arms
 *    Case 6:  an arm that fails after its subqueries ran returns the error
 */

drop table if exists t_small, t_pair;

-- three rows each, as in the issue: the defect needs no data size, only two or more
-- correlated subqueries in one arm and a join, which makes the arms parallel jobs
create table t_small (col_n int);
create table t_pair (col_k bigint, col_v double);
insert into t_small values (1), (2), (3);
insert into t_pair values (1, 5.0), (2, null), (null, 1.0);
update statistics on t_small, t_pair with fullscan;

set trace on;


evaluate 'Case 1: the issue query; result = no_parallel_subquery';
select /*+ recompile */ s.col_n, p.col_k, p.col_v from t_small s, t_pair p where p.col_v not in (select x.col_n from t_small x where p.col_k <= p.col_v) and 0 in (select y.col_n from t_small y where p.col_v <=> p.col_v) union all select s.col_n, p.col_k, p.col_v from t_small s, t_pair p where p.col_v not in (select x.col_n from t_small x where p.col_k <= p.col_v) and 0 in (select y.col_n from t_small y where p.col_v <=> p.col_v) order by 1, 2, 3;
show trace;
select /*+ no_parallel_subquery */ s.col_n, p.col_k, p.col_v from t_small s, t_pair p where p.col_v not in (select x.col_n from t_small x where p.col_k <= p.col_v) and 0 in (select y.col_n from t_small y where p.col_v <=> p.col_v) union all select /*+ no_parallel_subquery */ s.col_n, p.col_k, p.col_v from t_small s, t_pair p where p.col_v not in (select x.col_n from t_small x where p.col_k <= p.col_v) and 0 in (select y.col_n from t_small y where p.col_v <=> p.col_v) order by 1, 2, 3;


evaluate 'Case 2: rows in the result; result = no_parallel_subquery';
select /*+ recompile */ s.col_n, p.col_k, p.col_v from t_small s, t_pair p where p.col_v not in (select x.col_n from t_small x where p.col_k <= p.col_v) and 0 in (select y.col_n from t_small y where p.col_v <=> p.col_v) union all select s.col_n, p.col_k, p.col_v from t_small s, t_pair p where p.col_v not in (select x.col_n + 0 from t_small x where p.col_k < p.col_v + 1) and 1 in (select y.col_n - 0 from t_small y where p.col_k <=> p.col_k) order by 1, 2, 3;
show trace;
select /*+ no_parallel_subquery */ s.col_n, p.col_k, p.col_v from t_small s, t_pair p where p.col_v not in (select x.col_n from t_small x where p.col_k <= p.col_v) and 0 in (select y.col_n from t_small y where p.col_v <=> p.col_v) union all select /*+ no_parallel_subquery */ s.col_n, p.col_k, p.col_v from t_small s, t_pair p where p.col_v not in (select x.col_n + 0 from t_small x where p.col_k < p.col_v + 1) and 1 in (select y.col_n - 0 from t_small y where p.col_k <=> p.col_k) order by 1, 2, 3;


evaluate 'Case 3: two subqueries in the select list; result = no_parallel_subquery';
select /*+ recompile */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c from t_small s, t_pair p union all select s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c from t_small s, t_pair p order by 1, 2, 3, 4;
show trace;
select /*+ no_parallel_subquery */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c from t_small s, t_pair p union all select /*+ no_parallel_subquery */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c from t_small s, t_pair p order by 1, 2, 3, 4;


evaluate 'Case 4: three subqueries in the select list; result = no_parallel_subquery';
select /*+ recompile */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c, (select count(*) from t_small x where x.col_n = p.col_k) e from t_small s, t_pair p union all select s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c, (select count(*) from t_small x where x.col_n = p.col_k) e from t_small s, t_pair p order by 1, 2, 3, 4, 5;
show trace;
select /*+ no_parallel_subquery */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c, (select count(*) from t_small x where x.col_n = p.col_k) e from t_small s, t_pair p union all select /*+ no_parallel_subquery */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c, (select count(*) from t_small x where x.col_n = p.col_k) e from t_small s, t_pair p order by 1, 2, 3, 4, 5;


evaluate 'Case 5: intersection and difference arms; result = no_parallel_subquery';
select /*+ recompile */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c from t_small s, t_pair p intersection select s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c from t_small s, t_pair p order by 1, 2, 3, 4;
show trace;
select /*+ no_parallel_subquery */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c from t_small s, t_pair p intersection select /*+ no_parallel_subquery */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c from t_small s, t_pair p order by 1, 2, 3, 4;
select /*+ recompile */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c from t_small s, t_pair p difference select s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k + 1) c from t_small s, t_pair p order by 1, 2, 3, 4;
show trace;
select /*+ no_parallel_subquery */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c from t_small s, t_pair p difference select /*+ no_parallel_subquery */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k + 1) c from t_small s, t_pair p order by 1, 2, 3, 4;

-- trace goes off after the last show trace: the plan of a later query would stay in the session
-- and the first show trace of a later file over a cached plan would print it
set trace off;


evaluate 'Case 6: an arm that fails returns the error; result = no_parallel_subquery';
-- the arms of Case 3 with a division by zero at col_k = 2: the trace of Case 3 shows that they run as
-- parallel jobs, and a failed query prints no trace of its own, so this case reads no trace
select s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c, 1 / (p.col_k - 2) d from t_small s, t_pair p union all select s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c, 1 / (p.col_k - 2) d from t_small s, t_pair p order by 1, 2, 3, 4, 5;
select /*+ no_parallel_subquery */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c, 1 / (p.col_k - 2) d from t_small s, t_pair p union all select /*+ no_parallel_subquery */ s.col_n, p.col_k, (select max(x.col_n) from t_small x where x.col_n <= p.col_k) m, (select count(*) from t_small x where x.col_n > p.col_k) c, 1 / (p.col_k - 2) d from t_small s, t_pair p order by 1, 2, 3, 4, 5;

drop table t_small, t_pair;
