/*
 * This test case verifies CBRD-27340 : an INNER JOIN condition that
 * references the null-supplying side of a preceding RIGHT OUTER JOIN must
 * stay a real join edge to the other table(s), instead of being evaluated
 * as a post-join filter.
 *
 * jtbl_a is the null-supplying (left) side of "jtbl_a RIGHT JOIN jtbl_b".
 * jtbl_b is the RIGHT OUTER JOIN's on_node (preserved/right side).
 * jtbl_c is joined afterwards with an INNER JOIN condition that references
 * jtbl_a (jtbl_c.k = jtbl_a.k), i.e. the null-supplying side of the
 * preceding RIGHT OUTER JOIN.
 *
 * jtbl_b.j = 9 has no matching jtbl_a row, so RIGHT OUTER JOIN null-pads
 * jtbl_a's columns for that row; the following INNER JOIN to jtbl_c must
 * then drop that row (NULL never matches jtbl_c.k), leaving count = 2.
 *
 * Bug (pre-fix): the INNER JOIN term (jtbl_c.k = jtbl_a.k) was reclassified
 * away from a normal join edge once it was recognized as depending on the
 * preceding RIGHT OUTER JOIN, which disconnected jtbl_c from {jtbl_a,
 * jtbl_b} in the join graph. With no other edge connecting jtbl_c, the
 * planner was forced into a Cartesian product between jtbl_c and the
 * {jtbl_a, jtbl_b} result, filtering the condition only afterwards. The
 * final count stayed correct, but the plan degraded to a Cartesian product
 * instead of a real index/hash/merge join on jtbl_c.k -- catastrophic on
 * larger tables.
 *
 * count(*) must be 2 under every join method. Verified by hand (see above)
 * and empirically against the pre-fix engine: hintless/USE_NL/USE_MERGE
 * happened to still return 2 on this data, but /*+ USE_IDX *\/ returned 3 --
 * the planner reordered to (jtbl_a INNER JOIN jtbl_c) RIGHT JOIN jtbl_b,
 * which null-pads a jtbl_b.j=9 row that the correct join order (RIGHT JOIN
 * first, then INNER JOIN) drops. So this is a real per-join-method
 * correctness regression, not only the plan-shape regression described
 * above.
 *
 *   Case 1: hintless
 *   Case 2: /*+ USE_NL *\/ (nested loop join)
 *   Case 3: /*+ USE_IDX *\/ (index join)
 *   Case 4: /*+ USE_MERGE *\/ (sort-merge join)
 *
 * Cases 5-8 cover a second path to the same kind of bug: an INNER JOIN
 * condition that depends on a preceding RIGHT OUTER JOIN can still seed an
 * *inferred* join condition that does not carry that dependency.
 *
 * jtbl2_a RIGHT JOIN jtbl2_b ON jtbl2_a.id = jtbl2_b.id, then INNER JOIN
 * jtbl2_c ON jtbl2_a.x = jtbl2_c.x, then INNER JOIN jtbl2_d ON
 * jtbl2_c.x = jtbl2_d.x. The optimizer can infer jtbl2_a.x = jtbl2_d.x by
 * transitivity from the other two equalities; that inferred condition does
 * not know it must wait for jtbl2_b, so the planner could join jtbl2_a and
 * jtbl2_d (then jtbl2_c) before jtbl2_b -- count(*) must still be 2.
 *
 *   Case 5: hintless
 *   Case 6: /*+ USE_NL *\/
 *   Case 7: /*+ USE_IDX *\/
 *   Case 8: /*+ USE_MERGE *\/
 */
drop table if exists jtbl_a, jtbl_b, jtbl_c;

create table jtbl_a (k int primary key, j int);
create table jtbl_b (j int);
create table jtbl_c (k int primary key, v int);

insert into jtbl_a values (1, 1), (2, 2), (3, 3);
insert into jtbl_b values (1), (2), (9);
insert into jtbl_c values (1, 10), (2, 20), (3, 30);

update statistics on jtbl_a, jtbl_b, jtbl_c with fullscan;

-- Case 1
select count(*) from jtbl_a right outer join jtbl_b on jtbl_a.j = jtbl_b.j
  inner join jtbl_c on jtbl_c.k = jtbl_a.k;

-- Case 2
select /*+ USE_NL */ count(*) from jtbl_a right outer join jtbl_b on jtbl_a.j = jtbl_b.j
  inner join jtbl_c on jtbl_c.k = jtbl_a.k;

-- Case 3
select /*+ USE_IDX */ count(*) from jtbl_a right outer join jtbl_b on jtbl_a.j = jtbl_b.j
  inner join jtbl_c on jtbl_c.k = jtbl_a.k;

-- Case 4
select /*+ USE_MERGE */ count(*) from jtbl_a right outer join jtbl_b on jtbl_a.j = jtbl_b.j
  inner join jtbl_c on jtbl_c.k = jtbl_a.k;

drop table jtbl_a, jtbl_b, jtbl_c;

drop table if exists jtbl2_a, jtbl2_b, jtbl2_c, jtbl2_d;

create table jtbl2_a (id int primary key, x int);
create table jtbl2_b (id int);
create table jtbl2_c (x int primary key, v int);
create table jtbl2_d (x int primary key, w int);

insert into jtbl2_a values (1, 10), (2, 20);
insert into jtbl2_b values (1), (2), (9);
insert into jtbl2_c values (10, 100), (20, 200);
insert into jtbl2_d values (10, 1000), (20, 2000);

update statistics on jtbl2_a, jtbl2_b, jtbl2_c, jtbl2_d with fullscan;

-- Case 5
select count(*) from jtbl2_a right outer join jtbl2_b on jtbl2_a.id = jtbl2_b.id
  inner join jtbl2_c on jtbl2_a.x = jtbl2_c.x
  inner join jtbl2_d on jtbl2_c.x = jtbl2_d.x;

-- Case 6
select /*+ USE_NL */ count(*) from jtbl2_a right outer join jtbl2_b on jtbl2_a.id = jtbl2_b.id
  inner join jtbl2_c on jtbl2_a.x = jtbl2_c.x
  inner join jtbl2_d on jtbl2_c.x = jtbl2_d.x;

-- Case 7
select /*+ USE_IDX */ count(*) from jtbl2_a right outer join jtbl2_b on jtbl2_a.id = jtbl2_b.id
  inner join jtbl2_c on jtbl2_a.x = jtbl2_c.x
  inner join jtbl2_d on jtbl2_c.x = jtbl2_d.x;

-- Case 8
select /*+ USE_MERGE */ count(*) from jtbl2_a right outer join jtbl2_b on jtbl2_a.id = jtbl2_b.id
  inner join jtbl2_c on jtbl2_a.x = jtbl2_c.x
  inner join jtbl2_d on jtbl2_c.x = jtbl2_d.x;

drop table jtbl2_a, jtbl2_b, jtbl2_c, jtbl2_d;
