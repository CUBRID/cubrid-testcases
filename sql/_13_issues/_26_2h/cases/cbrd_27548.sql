/**
 *  This test case verifies CBRD-27548: an index nested-loop join over partitioned tables
 *  returns every joined row once.
 *
 *  When a driving block has no match in the middle table, the scan block iterator closes
 *  the partitioned inner while it is still on its first partition. The restart then opened
 *  a root block that kept that partition's index, so the partition was read twice and its
 *  rows came back twice (11.5, since CBRD-25759). The fix restarts on the first partition.
 *
 *  Every query runs again on non-partitioned copies of the tables with the same indexes,
 *  and the two result blocks must match. The driving table is list partitioned and pruned
 *  with pc IN lists, so the order of its blocks is fixed. CTP masks digits in the trace,
 *  which therefore shows only the plan shape.
 *
 *  Coverage:
 *    Case 1:  issue repro, hash partitioned driving table
 *    Case 2:  driving blocks without and with a match
 *    Case 3:  three driving blocks, the first matching block first, second or last
 *    Case 4:  the inner row in the middle or last partition of the inner table
 *    Case 5:  pruning on the inner leaves its first partition only, or drops it
 *    Case 6:  four-table chain with two partitioned inner tables
 *    Case 7:  memoize_memory_limit=0
 *    Case 8:  the join in a correlated scalar subquery
 *    Case 9:  heap scan of the inner table, no index
 *    Case 10: INSERT ... SELECT of the join
 *    Case 11: multi-table UPDATE whose target is the driving table
 */

drop table if exists t_hdrv, t_drv, t_mid, t_inn, t_four, t_heap, x_hdrv, x_drv, x_mid, x_inn, x_four, x_heap, t_par, t_sink;

-- the issue tables: hash partitioned driving table, range partitioned middle table
create table t_hdrv (id int, k int, kb int, pc int) partition by hash (k) partitions 3;
create index i_hdrv_kb on t_hdrv (kb);
insert into t_hdrv values (293, 6, 0, 1), (295, 2, 2, 5);
create table t_mid (id int, k int, f int, pc int) partition by range (pc)
  (partition p_a values less than (1), partition p_b values less than (4), partition p_c values less than (5), partition p_d values less than maxvalue);
create index i_mid_k_id on t_mid (k, id);
insert into t_mid values (3, 6, 0, 5);

-- one driving row per partition: k = 2 has no match in t_mid, k = 6 has one, kb picks the inner partition
create table t_drv (id int, k int, kb int, pc int) partition by list (pc)
  (partition p_a values in (0), partition p_b values in (1), partition p_c values in (2), partition p_d values in (3), partition p_e values in (4), partition p_f values in (5));
create index i_drv_kb on t_drv (kb);
insert into t_drv values (295, 2, 2, 0), (293, 6, 0, 1), (296, 2, 2, 2), (297, 6, 0, 3), (298, 6, 1, 4), (299, 6, 2, 5);

-- inner tables: key 0 in the first partition, key 2 in the middle one, key 1 in the last one
create table t_inn (id int, k int, pc int) partition by list (pc)
  (partition p_a values in (4, 0, 1), partition p_b values in (3, 2), partition p_c values in (5));
create index i_inn_k on t_inn (k);
insert into t_inn values (3, 0, 0), (5, 2, 2), (7, 1, 5);
create table t_four (id int, k int, pc int) partition by list (pc) (partition p_a values in (0), partition p_b values in (1));
create index i_four_k on t_four (k);
insert into t_four values (8, 0, 0);
create table t_heap (id int, k int, pc int) partition by list (pc)
  (partition p_a values in (4, 0, 1), partition p_b values in (3, 2), partition p_c values in (5));
insert into t_heap select * from t_inn;

-- non-partitioned copies with the same indexes
create table x_hdrv (id int, k int, kb int, pc int);
create index i_xhdrv_kb on x_hdrv (kb);
insert into x_hdrv select * from t_hdrv;
create table x_drv (id int, k int, kb int, pc int);
create index i_xdrv_kb on x_drv (kb);
insert into x_drv select * from t_drv;
create table x_mid (id int, k int, f int, pc int);
create index i_xmid_k_id on x_mid (k, id);
insert into x_mid select * from t_mid;
create table x_inn (id int, k int, pc int);
create index i_xinn_k on x_inn (k);
insert into x_inn select * from t_inn;
create table x_four (id int, k int, pc int);
create index i_xfour_k on x_four (k);
insert into x_four select * from t_four;
create table x_heap (id int, k int, pc int);
insert into x_heap select * from t_inn;

create table t_par (a int);
insert into t_par values (0), (294);
create table t_sink (o_id int, w_id int, x_id int);

update statistics on t_hdrv, t_mid, t_drv, t_inn, t_four, t_heap, x_hdrv, x_drv, x_mid, x_inn, x_four, x_heap, t_par with fullscan;

set trace on;


evaluate 'Case 1: issue repro, hash partitioned driving table; result = non-partitioned copies';
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_hdrv o, t_mid w, t_inn x where w.k = o.k and x.k = o.kb order by 1, 2, 3;
show trace;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_hdrv o, x_mid w, x_inn x where w.k = o.k and x.k = o.kb order by 1, 2, 3;


evaluate 'Case 2: driving blocks without and with a match; result = non-partitioned copies';
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_drv o, t_mid w, t_inn x where o.pc in (0, 1) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
show trace;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_drv o, x_mid w, x_inn x where o.pc in (0, 1) and w.k = o.k and x.k = o.kb order by 1, 2, 3;


evaluate 'Case 3: three driving blocks, the first matching block last, second or first; result = non-partitioned copies';
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_drv o, t_mid w, t_inn x where o.pc in (0, 2, 3) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
show trace;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_drv o, x_mid w, x_inn x where o.pc in (0, 2, 3) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_drv o, t_mid w, t_inn x where o.pc in (0, 1, 3) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_drv o, x_mid w, x_inn x where o.pc in (0, 1, 3) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_drv o, t_mid w, t_inn x where o.pc in (1, 3) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_drv o, x_mid w, x_inn x where o.pc in (1, 3) and w.k = o.k and x.k = o.kb order by 1, 2, 3;


evaluate 'Case 4: the inner row in the last or middle partition of the inner table; result = non-partitioned copies';
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_drv o, t_mid w, t_inn x where o.pc in (0, 4) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
show trace;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_drv o, x_mid w, x_inn x where o.pc in (0, 4) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_drv o, t_mid w, t_inn x where o.pc in (0, 5) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_drv o, x_mid w, x_inn x where o.pc in (0, 5) and w.k = o.k and x.k = o.kb order by 1, 2, 3;


evaluate 'Case 5: pruning on the inner leaves its first partition only, or drops it; result = non-partitioned copies';
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_drv o, t_mid w, t_inn x where o.pc in (0, 1) and w.k = o.k and x.k = o.kb and x.pc = 0 order by 1, 2, 3;
show trace;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_drv o, x_mid w, x_inn x where o.pc in (0, 1) and w.k = o.k and x.k = o.kb and x.pc = 0 order by 1, 2, 3;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_drv o, t_mid w, t_inn x where o.pc in (0, 5) and w.k = o.k and x.k = o.kb and x.pc in (2, 3, 5) order by 1, 2, 3;
show trace;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_drv o, x_mid w, x_inn x where o.pc in (0, 5) and w.k = o.k and x.k = o.kb and x.pc in (2, 3, 5) order by 1, 2, 3;


evaluate 'Case 6: four-table chain with two partitioned inner tables; result = non-partitioned copies';
select /*+ recompile ordered use_nl */ o.id, w.id, x.id, y.id from t_drv o, t_mid w, t_inn x, t_four y where o.pc in (0, 1) and w.k = o.k and x.k = o.kb and y.k = o.kb order by 1, 2, 3, 4;
show trace;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id, y.id from x_drv o, x_mid w, x_inn x, x_four y where o.pc in (0, 1) and w.k = o.k and x.k = o.kb and y.k = o.kb order by 1, 2, 3, 4;


evaluate 'Case 7: memoize_memory_limit=0; result = non-partitioned copies';
set system parameters 'memoize_memory_limit=0';
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_drv o, t_mid w, t_inn x where o.pc in (0, 2, 3) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
show trace;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_drv o, x_mid w, x_inn x where o.pc in (0, 2, 3) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
set system parameters 'memoize_memory_limit=default';


evaluate 'Case 8: the join in a correlated scalar subquery; result = non-partitioned copies';
select /*+ recompile */ p.a, (select /*+ ordered use_nl */ count(*) from t_drv o, t_mid w, t_inn x where o.pc in (0, 1) and o.id > p.a and w.k = o.k and x.k = o.kb) cnt from t_par p order by 1;
show trace;
select /*+ recompile */ p.a, (select /*+ ordered use_nl */ count(*) from x_drv o, x_mid w, x_inn x where o.pc in (0, 1) and o.id > p.a and w.k = o.k and x.k = o.kb) cnt from t_par p order by 1;


evaluate 'Case 9: heap scan of the inner table, no index; result = non-partitioned copies';
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_drv o, t_mid w, t_heap x where o.pc in (0, 1) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
show trace;
select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_drv o, x_mid w, x_heap x where o.pc in (0, 1) and w.k = o.k and x.k = o.kb order by 1, 2, 3;
-- trace goes off before the DML below that no show trace reads: its plan would stay in the session
set trace off;


evaluate 'Case 10: INSERT ... SELECT of the join; result = non-partitioned copies';
insert into t_sink select /*+ recompile ordered use_nl */ o.id, w.id, x.id from t_drv o, t_mid w, t_inn x where o.pc in (0, 2, 3) and w.k = o.k and x.k = o.kb;
select o_id, w_id, x_id from t_sink order by 1, 2, 3;
delete from t_sink;
insert into t_sink select /*+ recompile ordered use_nl */ o.id, w.id, x.id from x_drv o, x_mid w, x_inn x where o.pc in (0, 2, 3) and w.k = o.k and x.k = o.kb;
select o_id, w_id, x_id from t_sink order by 1, 2, 3;


evaluate 'Case 11: multi-table UPDATE whose target is the driving table; result = non-partitioned copies';
update /*+ recompile ordered use_nl */ t_drv o, t_mid w, t_inn x set o.id = o.id + 1000 where o.pc in (0, 1, 3) and w.k = o.k and x.k = o.kb;
select id, k, kb, pc from t_drv order by 1;
update /*+ recompile ordered use_nl */ x_drv o, x_mid w, x_inn x set o.id = o.id + 1000 where o.pc in (0, 1, 3) and w.k = o.k and x.k = o.kb;
select id, k, kb, pc from x_drv order by 1;

drop table t_hdrv, t_drv, t_mid, t_inn, t_four, t_heap, x_hdrv, x_drv, x_mid, x_inn, x_four, x_heap, t_par, t_sink;
