/*
 * This test case verifies CBRD-27485 : when the driving scan runs as a
 * parallel scan and an unnested [NOT] EXISTS subquery becomes a nested loop
 * SEMI / ANTI join whose inner is a partitioned table, only the first
 * partition of the inner was probed.
 *
 * Bug: the parallel scan worker opened the inner on the one partition the
 * main thread handed over and never pruned its own XASL clone, so it never
 * moved on to the other partitions. EXISTS dropped every outer row whose
 * match is in a later partition and NOT EXISTS kept them. With trace on
 * the server went down, either on a NULL curr_spec (the clone was pruned
 * but not rewound per outer row) or on a partition pruning assertion (an
 * earlier run without trace left the partition BTID in the cached clone).
 *
 * outer_big is large enough to be scanned in parallel under test_mode
 * (parallel_scan_page_threshold 32). Every k in 0..5 exists in the inner,
 * so every outer row satisfies EXISTS and none satisfies NOT EXISTS.
 *   Case 1: EXISTS, hash partitioned inner -> 100000
 *   Case 2: NOT EXISTS, hash partitioned inner -> 0
 *   Case 3: EXISTS, range partitioned inner -> 100000
 *   Case 4: NOT EXISTS, range partitioned inner -> 0
 *   Case 5: Case 1 and Case 2 with trace on -> same counts, no server failure
 */
drop table if exists outer_big, part_inner, part_inner_r;

create table part_inner (a int, k int, primary key (k, a)) partition by hash (k) partitions 4;
insert into part_inner select rownum, mod (rownum, 6) from db_class a, db_class b limit 50;

create table part_inner_r (a int, k int, primary key (k, a))
partition by range (k) (partition p0 values less than (2), partition p1 values less than (4), partition p2 values less than maxvalue);
insert into part_inner_r select a, k from part_inner;

create table outer_big (a int primary key, k int);
insert into outer_big select rownum, mod (rownum, 6) from db_class a, db_class b, db_class c, db_class d limit 100000;

update statistics on outer_big, part_inner, part_inner_r with fullscan;

-- Case 1
select count(*) from outer_big o where exists (select 1 from part_inner s where s.k = o.k);

-- Case 2
select count(*) from outer_big o where not exists (select 1 from part_inner s where s.k = o.k);

-- Case 3
select count(*) from outer_big o where exists (select 1 from part_inner_r s where s.k = o.k);

-- Case 4
select count(*) from outer_big o where not exists (select 1 from part_inner_r s where s.k = o.k);

-- Case 5
set trace on;
select count(*) from outer_big o where exists (select 1 from part_inner s where s.k = o.k);
select count(*) from outer_big o where not exists (select 1 from part_inner s where s.k = o.k);
set trace off;

drop table outer_big, part_inner, part_inner_r;
