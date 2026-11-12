/**
 *  This test case verifies CBRD-27548: a select whose partition pruning leaves no partition
 *  returns no row, and an outer join over it returns its NULL rows.
 *
 *  Since CBRD-25759 a select scan of a partitioned table moves to its first pruned partition
 *  when it opens. With no partition left (k = some {98, 99}, or a collection of NULLs only)
 *  there is none, and the statement failed with a query execution error (an assertion in
 *  debug builds). The fix keeps such a scan on the root class, whose heap is empty.
 *
 *  Every query runs again on non-partitioned copies of the tables, and the two result
 *  blocks must match. CTP masks digits in the trace, which therefore shows only the plan:
 *  the scan of Case 1 lists no partition, the one of Case 12 lists every partition.
 *
 *  Coverage:
 *    Case 1:  list partition, values no partition holds
 *    Case 2:  collections of NULLs only, list, hash and expression partitions
 *    Case 3:  a NULL and a value, one partition left
 *    Case 4:  list partition on an expression, values no partition holds
 *    Case 5:  nested-loop LEFT OUTER JOIN whose inner table is pruned to nothing
 *    Case 6:  inner, hash and merge joins with the inner table pruned to nothing
 *    Case 7:  EXISTS and NOT EXISTS over a table pruned to nothing
 *    Case 8:  correlated scalar subquery
 *    Case 9:  derived table, UNION ALL and WITH
 *    Case 10: SELECT ... FOR UPDATE
 *    Case 11: index scan of the pruned table, alone and as an index nested-loop inner
 *    Case 12: pruning that keeps every partition, range partition and k = 99
 *    Case 13: UPDATE, DELETE and INSERT ... SELECT whose target is pruned to nothing
 */

drop table if exists t_list, t_hash, t_expr, t_elist, t_range, t_ilist, t_outer, x_list, x_hash, x_expr, x_elist, x_range, x_ilist, t_sink;

-- list partition with a NULL partition: key 6 has two rows and key 5 one, so a lost or doubled row shows
create table t_list (k int, n int) partition by list (k) (partition p_a values in (1, 2, 3, null), partition p_b values in (4, 5, 6));
insert into t_list values (1, 10), (2, 20), (5, 50), (6, 60), (6, 61), (null, 0);
create table t_hash (k int, n int) partition by hash (k) partitions 2;
insert into t_hash select * from t_list;
-- partition keys on expressions: hash on i + 3, list on i + 1 (i = 1 and 4 give 2 and 5)
create table t_expr (i smallint, n int) partition by hash (i + 3) partitions 3;
insert into t_expr values (1, 10), (2, 20), (5, 50), (null, 0);
create table t_elist (i int, n int) partition by list (i + 1) (partition p_a values in (1, 2, 3), partition p_b values in (4, 5, 6));
insert into t_elist values (1, 10), (4, 40), (4, 41);
create table t_range (k int, n int) partition by range (k) (partition p_a values less than (3), partition p_b values less than (10));
insert into t_range values (1, 10), (5, 50), (6, 60);
-- the same rows with an index on the partition key
create table t_ilist (k int, n int) partition by list (k) (partition p_a values in (1, 2, 3, null), partition p_b values in (4, 5, 6));
create index i_ilist_k on t_ilist (k);
insert into t_ilist select * from t_list;
create table t_outer (k int);
insert into t_outer values (1), (5), (6);

-- non-partitioned copies
create table x_list (k int, n int);
insert into x_list select * from t_list;
create table x_hash (k int, n int);
insert into x_hash select * from t_hash;
create table x_expr (i smallint, n int);
insert into x_expr select * from t_expr;
create table x_elist (i int, n int);
insert into x_elist select * from t_elist;
create table x_range (k int, n int);
insert into x_range select * from t_range;
create table x_ilist (k int, n int);
create index i_xilist_k on x_ilist (k);
insert into x_ilist select * from t_list;
create table t_sink (k int, n int);

update statistics on t_list, t_hash, t_expr, t_elist, t_range, t_ilist, t_outer, x_list, x_hash, x_expr, x_elist, x_range, x_ilist with fullscan;

set trace on;


evaluate 'Case 1: list partition, values no partition holds; result = non-partitioned copies';
select /*+ recompile */ k, n from t_list where k = some {98, 99} order by n;
show trace;
select /*+ recompile */ k, n from x_list where k = some {98, 99} order by n;
select /*+ recompile */ count(*), sum(n) from t_list where k = some {98, 99};
select /*+ recompile */ count(*), sum(n) from x_list where k = some {98, 99};


evaluate 'Case 2: collections of NULLs only, list, hash and expression partitions; result = non-partitioned copies';
select /*+ recompile */ k, n from t_list where k = some {null} order by n;
select /*+ recompile */ k, n from x_list where k = some {null} order by n;
select /*+ recompile */ k, n from t_hash where k = some {null} order by n;
select /*+ recompile */ k, n from x_hash where k = some {null} order by n;
select /*+ recompile */ i, n from t_expr where i + 3 = some {null} order by n;
select /*+ recompile */ i, n from x_expr where i + 3 = some {null} order by n;


evaluate 'Case 3: a NULL and a value, one partition left; result = non-partitioned copies';
select /*+ recompile */ k, n from t_list where k = some {null, 6} order by n;
select /*+ recompile */ k, n from x_list where k = some {null, 6} order by n;
select /*+ recompile */ k, n from t_hash where k = some {null, 6} order by n;
select /*+ recompile */ k, n from x_hash where k = some {null, 6} order by n;
select /*+ recompile */ i, n from t_expr where i + 3 = some {null, 4} order by n;
select /*+ recompile */ i, n from x_expr where i + 3 = some {null, 4} order by n;


evaluate 'Case 4: list partition on an expression, values no partition holds; result = non-partitioned copies';
select /*+ recompile */ i, n from t_elist where i + 1 = some {97, 98} order by n;
select /*+ recompile */ i, n from x_elist where i + 1 = some {97, 98} order by n;
select /*+ recompile */ i, n from t_elist where i + 1 = some {97, 5} order by n;
select /*+ recompile */ i, n from x_elist where i + 1 = some {97, 5} order by n;


evaluate 'Case 5: nested-loop LEFT OUTER JOIN whose inner table is pruned to nothing; result = non-partitioned copies';
select /*+ recompile ordered use_nl */ o.k, l.n from t_outer o left join t_list l on l.k = o.k and l.k = some {98, 99} order by 1;
show trace;
select /*+ recompile ordered use_nl */ o.k, l.n from t_outer o left join x_list l on l.k = o.k and l.k = some {98, 99} order by 1;
select /*+ recompile ordered use_nl */ o.k, l.n from t_outer o left join t_hash l on l.k = o.k and l.k = some {null} order by 1;
select /*+ recompile ordered use_nl */ o.k, l.n from t_outer o left join x_hash l on l.k = o.k and l.k = some {null} order by 1;


evaluate 'Case 6: inner, hash and merge joins with the inner table pruned to nothing; result = non-partitioned copies';
select /*+ recompile ordered use_nl */ o.k, l.n from t_outer o, t_list l where l.k = o.k and l.k = some {98, 99} order by 1;
select /*+ recompile ordered use_nl */ o.k, l.n from t_outer o, x_list l where l.k = o.k and l.k = some {98, 99} order by 1;
select /*+ recompile ordered use_hash */ o.k, l.n from t_outer o left join t_list l on l.k = o.k and l.k = some {98, 99} order by 1;
select /*+ recompile ordered use_hash */ o.k, l.n from t_outer o left join x_list l on l.k = o.k and l.k = some {98, 99} order by 1;
select /*+ recompile ordered use_merge */ o.k, l.n from t_outer o left join t_list l on l.k = o.k and l.k = some {98, 99} order by 1;
select /*+ recompile ordered use_merge */ o.k, l.n from t_outer o left join x_list l on l.k = o.k and l.k = some {98, 99} order by 1;


evaluate 'Case 7: EXISTS and NOT EXISTS over a table pruned to nothing; result = non-partitioned copies';
select /*+ recompile */ o.k from t_outer o where exists (select 1 from t_list l where l.k = o.k and l.k = some {98, 99}) order by 1;
select /*+ recompile */ o.k from t_outer o where exists (select 1 from x_list l where l.k = o.k and l.k = some {98, 99}) order by 1;
select /*+ recompile */ o.k from t_outer o where not exists (select 1 from t_list l where l.k = o.k and l.k = some {98, 99}) order by 1;
select /*+ recompile */ o.k from t_outer o where not exists (select 1 from x_list l where l.k = o.k and l.k = some {98, 99}) order by 1;


evaluate 'Case 8: correlated scalar subquery; result = non-partitioned copies';
select /*+ recompile */ o.k, (select count(*) from t_list l where l.n > o.k and l.k = some {98, 99}) cnt from t_outer o order by 1;
select /*+ recompile */ o.k, (select count(*) from x_list l where l.n > o.k and l.k = some {98, 99}) cnt from t_outer o order by 1;


evaluate 'Case 9: derived table, UNION ALL and WITH; result = non-partitioned copies';
select /*+ recompile */ d.k, d.n from (select k, n from t_list where k = some {98, 99}) d order by 2;
select /*+ recompile */ d.k, d.n from (select k, n from x_list where k = some {98, 99}) d order by 2;
select /*+ recompile */ k, n from t_list where k = some {98, 99} union all select k, n from t_list where k = some {5} order by 2;
select /*+ recompile */ k, n from x_list where k = some {98, 99} union all select k, n from x_list where k = some {5} order by 2;
with c as (select k, n from t_list where k = some {98, 99}) select /*+ recompile */ count(*) from c;
with c as (select k, n from x_list where k = some {98, 99}) select /*+ recompile */ count(*) from c;


evaluate 'Case 10: SELECT ... FOR UPDATE; result = non-partitioned copies';
select /*+ recompile */ k, n from t_list where k = some {98, 99} for update;
select /*+ recompile */ k, n from x_list where k = some {98, 99} for update;


evaluate 'Case 11: index scan of the pruned table, alone and as an index nested-loop inner; result = non-partitioned copies';
select /*+ recompile */ k, n from t_ilist force index (i_ilist_k) where k = some {98, 99} order by n;
select /*+ recompile */ k, n from x_ilist force index (i_xilist_k) where k = some {98, 99} order by n;
select /*+ recompile ordered use_nl */ o.k, l.n from t_outer o, t_ilist l where l.k = o.k and l.k = some {98, 99} order by 1;
show trace;
select /*+ recompile ordered use_nl */ o.k, l.n from t_outer o, x_ilist l where l.k = o.k and l.k = some {98, 99} order by 1;


evaluate 'Case 12: pruning that keeps every partition, range partition and k = 99; result = non-partitioned copies';
select /*+ recompile */ k, n from t_range where k = some {98, 99} order by n;
select /*+ recompile */ k, n from x_range where k = some {98, 99} order by n;
select /*+ recompile */ k, n from t_list where k = 99 order by n;
show trace;
-- trace goes off before the DML below that no show trace reads: its plan would stay in the session
set trace off;
select /*+ recompile */ k, n from x_list where k = 99 order by n;


evaluate 'Case 13: UPDATE, DELETE and INSERT ... SELECT whose target is pruned to nothing; result = non-partitioned copies';
update t_list set n = n + 100 where k = some {98, 99};
update t_list set n = n + 100 where k = some {98, 5};
delete from t_list where k = some {null};
delete from t_list where k = some {null, 2};
insert into t_sink select k, n from t_list where k = some {98, 99};
insert into t_sink select k, n from t_list where k = some {98, 1};
select k, n from t_list order by n;
select k, n from t_sink order by n;
delete from t_sink;
update x_list set n = n + 100 where k = some {98, 99};
update x_list set n = n + 100 where k = some {98, 5};
delete from x_list where k = some {null};
delete from x_list where k = some {null, 2};
insert into t_sink select k, n from x_list where k = some {98, 99};
insert into t_sink select k, n from x_list where k = some {98, 1};
select k, n from x_list order by n;
select k, n from t_sink order by n;

drop table t_list, t_hash, t_expr, t_elist, t_range, t_ilist, t_outer, x_list, x_hash, x_expr, x_elist, x_range, x_ilist, t_sink;
