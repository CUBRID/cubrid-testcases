/*
 * This test case verifies CBRD-27492 : a MERGE that updates many target rows
 * never returned.
 *
 * Bug: MERGE opens its statement-level system operation before executing its
 * UPDATE / INSERT sub-SELECTs. The GROUP BY that MERGE adds for the duplicate
 * target check abandons hash aggregation (every target OID is unique) and,
 * since CBRD-27177, sorts in parallel. A sort worker that has to create a
 * temporary file (empty temp file cache, e.g. right after server start) calls
 * log_sysop_start on the leader's transaction and blocks forever on the
 * rmutex_topop the leader holds, while the leader waits for the worker.
 *
 * Fix: parallel execution is disabled for the SELECTs MERGE generates and,
 * for anything else that decides a parallel degree while a system operation
 * is open (a derived table in the USING clause has no MERGE flag), in
 * compute_parallel_degree.
 *
 * Under test_mode the parallel sort threshold is 0, so the 10,000-row GROUP BY
 * sort input of every MERGE below is a parallel sort candidate on a host with
 * 3 or more cores. Before the fix the first MERGE hung when no cached temp file
 * was available; the deadlock does not depend on the statement shape, so every
 * case below reproduced it on a freshly started server. The affected-row count
 * and the count of updated rows are the check.
 *   Case 1: WHEN MATCHED UPDATE, 10,000 matched rows -> 10000 / 10000
 *   Case 2: WHEN MATCHED UPDATE + WHEN NOT MATCHED INSERT, 8,000 matched
 *           and 2,000 inserted -> 10000 / count 10000 / updated 8000
 *   Case 3: USING a derived table with ORDER BY (no MERGE flag on the nested
 *           SELECT, its ORDER BY sort is gated at run time) -> 10000 / 10000
 *   Case 4: USING a derived table joined with USE_HASH (hash join gated at
 *           run time) -> 10000 / 10000
 */
drop table if exists t1, t2, t3;

create table t1 (a int primary key, b int, c int, d char(10), e char(100), f char(500), index i_t1_b(b));
create table t2 (a int, b int, c int, d char(10), e char(100), f char(500), index i_t2_b(b), primary key(a, b)) partition by hash(b) partitions 3;
create table t3 (b int, x int);

insert into t1 select rownum, rownum, rownum, rownum||'', rownum||'', rownum||'' from db_class c1, db_class c2, db_class c3 limit 10000;
insert into t3 select b, b*2 from t1;

-- Case 1: WHEN MATCHED UPDATE with 10,000 matched rows
insert into t2 select a, b, c, d, e, f from t1;
select count(*) from t2;

merge into t2 using t1 on (t1.a=t2.a) when matched then update set t2.b=t1.a+1, t2.c=t1.c, t2.d=t1.d;
select count(*) from t2 where b = a + 1;

-- Case 2: WHEN MATCHED UPDATE and WHEN NOT MATCHED INSERT (8,000 matched, 2,000 inserted)
truncate table t2;
insert into t2 select a, b, c, d, e, f from t1 where a <= 8000;
select count(*) from t2;

merge into t2 using t1 on (t1.a=t2.a)
when matched then update set t2.b=t1.a+1, t2.c=t1.c, t2.d=t1.d
when not matched then insert values (t1.a, t1.b, t1.c, t1.d, t1.e, t1.f);
select count(*) from t2;
select count(*) from t2 where b = a + 1;

-- Case 3: USING a derived table with ORDER BY
truncate table t2;
insert into t2 select a, b, c, d, e, f from t1;

merge into t2 using (select a, b, c, d from t1 order by b desc) s on (s.a=t2.a) when matched then update set t2.b=s.a+1, t2.c=s.c, t2.d=s.d;
select count(*) from t2 where b = a + 1;

-- Case 4: USING a derived table joined with USE_HASH
truncate table t2;
insert into t2 select a, b, c, d, e, f from t1;

merge into t2 using (select /*+ USE_HASH */ t1.a, t1.c, t1.d, t3.x from t1, t3 where t1.b = t3.b) s on (s.a=t2.a) when matched then update set t2.b=s.a+1, t2.c=s.x, t2.d=s.d;
select count(*) from t2 where b = a + 1;
select count(*) from t2 where c = a * 2;

drop table t1, t2, t3;
