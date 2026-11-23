/*
 * This test case verifies CBRD-27340 : a condition that reads the
 * null-supplying side of a preceding LEFT/RIGHT OUTER JOIN -- directly, by
 * inference, or through a SEMI/ANTI JOIN -- must not be evaluated before
 * that OUTER JOIN's null-padding is resolved.
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
 * Bug (develop): join order/method is chosen by cost, independently of
 * this dependency. Nothing stopped the planner from placing jtbl_c's join
 * to jtbl_a before the RIGHT OUTER JOIN against jtbl_b is resolved, which
 * reads jtbl_a's original (pre-null-pad) rows instead of the null-padded
 * ones.
 *
 * Fix: qo_add_null_supplier_dep_set() (query_graph.c) walks every on_node
 * and records, in QO_NODE_OUTER_DEP_SET, every preceding LEFT/RIGHT OUTER
 * JOIN on_node whose null-supplying side the current on_node's ON clause
 * reads (directly, or indirectly through another on_node that already
 * carries the same dependency). qo_build_implied_seg_roots() then excludes
 * such a term from seeding a new *inferred* join condition (an inferred
 * condition would otherwise carry none of this dependency), and
 * qo_node_can_be_placed() (called from planner_visit_node()) uses the same
 * dependency to keep the on_node out of the join order until its outer-join
 * dependencies are resolved.
 *
 * count(*) must be 2 under every join method. Verified by hand (see above)
 * and empirically against the pre-fix engine: hintless/USE_NL/USE_MERGE
 * happened to still return 2 on this data, but /*+ USE_IDX *\/ returned 3 --
 * the planner reordered to (jtbl_a INNER JOIN jtbl_c) RIGHT JOIN jtbl_b,
 * which null-pads a jtbl_b.j=9 row that the correct join order (RIGHT JOIN
 * first, then INNER JOIN) drops.
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
 *
 * Cases 9-15 were added when the per-term dependency tracking above was
 * replaced by the current on_node-level tracking (QO_NODE_OUTER_DEP_SET),
 * covering paths the term-level implementation did not guard.
 *
 *   Case 9:  RIGHT OUTER JOIN followed by LEFT OUTER JOIN, the LEFT JOIN's
 *            own ON condition reads the RIGHT JOIN's null-supplying side
 *            through nvl(), /*+ USE_NL *\/. count(*) must be 129315.
 *   Case 10: LEFT OUTER JOIN -> INNER JOIN -> INNER JOIN, the last INNER
 *            JOIN reads both the LEFT OUTER JOIN's preserved side and
 *            (through the middle INNER JOIN) its null-supplying side.
 *            count(*) must be 16.
 *   Case 11: LEFT OUTER JOIN followed by an INNER JOIN whose ON clause is
 *            an AND of two conditions -- one reading the LEFT JOIN's
 *            preserved side (c11_x0), the other its null-supplying side
 *            (c11_x2). count(*) must be 2.
 *   Case 12: RIGHT OUTER JOIN followed by EXISTS (unnested to SEMI JOIN).
 *            count(*) must be 800.
 *   Case 13: RIGHT OUTER JOIN followed by an explicit SEMI JOIN.
 *            count(*) must be 800.
 *   Case 14: RIGHT OUTER JOIN followed by NOT EXISTS (unnested to ANTI
 *            JOIN). count(*) must be 2.
 *   Case 15: original JIRA repro (RIGHT OUTER JOIN -> INNER JOIN -> LEFT
 *            OUTER JOIN, /*+ USE_NL *\/). count(*) must be 19020.
 *
 * Cases 16-19 cover a path opened by CBRD-27397 (#7943): an uncorrelated IN
 * against a unique-key column gets unnested to an INNER JOIN. When that
 * INNER JOIN's ON condition reads a preceding RIGHT OUTER JOIN's
 * null-supplying side through coalesce() (so the column is never NULL and
 * qo_rewrite_outerjoin() cannot convert the RIGHT OUTER JOIN to INNER), it
 * hits the same hazard as Cases 1-15. This PR's fix resolves it without any
 * change beyond what Cases 1-15 already exercise; Cases 16-17 pin that as a
 * regression guard against CBRD-27397's rewrite, and Cases 18-19 confirm
 * the same hazard through EXISTS and an explicit SEMI JOIN.
 *
 *   Case 16: uncorrelated IN, coalesce(k, -1) so a null-padded row never
 *            matches. count(*) must be 12.
 *   Case 17: uncorrelated IN, coalesce(k, 0) so a null-padded row matches
 *            jtbl3_u's row 0. count(*) must be 2992.
 *   Case 18: EXISTS form of Case 17. count(*) must be 2992.
 *   Case 19: explicit SEMI JOIN form of Case 17. count(*) must be 2992.
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

drop table if exists c9_jt3;
drop table if exists c9_jt4;
create table c9_jt3 (k int, v int, w int);
create table c9_jt4 (g int primary key, h int, pk int);
insert into c9_jt3 select mod(rownum,11), mod(rownum,13), mod(rownum,11) from db_class a, db_class b, db_class c limit 300;
insert into c9_jt4 select rownum, mod(rownum,7), mod(rownum,11) from db_class a, db_class b, db_class c limit 200;
update statistics on c9_jt3, c9_jt4 with fullscan;

-- Case 9
select /*+ USE_NL */ count(*) from c9_jt4 x1 right join c9_jt3 x2 on x2.w = x1.h
  left join c9_jt3 x3 on x3.v = nvl(x1.pk,1);

drop table c9_jt3, c9_jt4;

drop table if exists la;
drop table if exists lc;
drop table if exists ld;
drop table if exists lb;
create table la (id int, m int);
create table lc (id int, k int);
create table ld (x int, k int);
create table lb (k int, m int);
insert into la select rownum, rownum mod 7 from db_class a, db_class b, db_class c limit 3000;
insert into lc select rownum * 2, rownum mod 5 from db_class a, db_class b, db_class c limit 20;
insert into ld select rownum mod 5, rownum mod 3 from db_class a, db_class b limit 10;
insert into lb select 1, rownum mod 7 from db_class a, db_class b limit 7;
create index i_lc_id on lc(id);
create index i_la_m on la(m);
update statistics on la, lc, ld, lb with fullscan;

-- Case 10
select count(*) from la left outer join lc on la.id = lc.id
  inner join ld on ld.x = lc.k
  inner join lb on lb.k = ld.k and lb.m = la.m;

drop table la, lc, ld, lb;

drop table if exists c11_x0;
drop table if exists c11_x2;
drop table if exists c11_x3;
create table c11_x0 (pk int primary key);
create table c11_x2 (k int, v int);
create table c11_x3 (pk int, h int);

insert into c11_x0 values (1), (2), (3);
insert into c11_x2 values (1, 100), (2, 200);
insert into c11_x3 values (1, 100), (1, 999), (2, 200), (3, 1);

update statistics on c11_x0, c11_x2, c11_x3 with fullscan;

-- Case 11
select count(*) from c11_x0 left join c11_x2 on c11_x2.k = c11_x0.pk
  join c11_x3 on c11_x3.pk = c11_x0.pk and c11_x3.h = c11_x2.v;

drop table c11_x0, c11_x2, c11_x3;

drop table if exists ra;
drop table if exists rd;
drop table if exists rb;
create table ra (id int, m int, k int);
create table rd (x int, k int, m int);
create table rb (k int, m int);
insert into ra select rownum, rownum mod 7, nullif(rownum mod 5, 4) from db_class a, db_class b, db_class c limit 400;
insert into rd select rownum mod 5, rownum mod 3, rownum mod 7 from db_class a, db_class b limit 12;
insert into rb select 1, rownum mod 7 from db_class a, db_class b limit 7;
create index i_ra_m on ra(m);
update statistics on ra, rd, rb with fullscan;

-- Case 12
select count(*) from ra right outer join rd on rd.x = ra.k where exists (select 1 from rb where rb.m = ra.m);

-- Case 13
select count(*) from ra right outer join rd on rd.x = ra.k semi join rb on rb.m = ra.m;

-- Case 14
select count(*) from ra right outer join rd on rd.x = ra.k where not exists (select 1 from rb where rb.m = ra.m);

drop table ra, rd, rb;

drop table if exists c15_jt3;
drop table if exists c15_jt4;
create table c15_jt3 (k int, v int, w int);
create table c15_jt4 (pk int primary key, g int not null, h int, unique (g));
insert into c15_jt3 select nullif(rownum mod 12, 11), rownum mod 5, nullif(rownum mod 9, 8)
  from db_class x1, db_class x2 limit 150;
insert into c15_jt4 select rownum, rownum, nullif(rownum mod 3, 2)
  from db_class x1, db_class x2 limit 80;
update statistics on c15_jt3, c15_jt4 with fullscan;

-- Case 15
select /*+ USE_NL */ count(*) from c15_jt4 x0
  right join c15_jt3 x1 on x0.h = x1.k
  join       c15_jt3 x2 on x0.pk = x2.v
  left join  c15_jt3 x3 on x1.k = x3.w;

drop table c15_jt3, c15_jt4;

drop table if exists jtbl3_o;
drop table if exists jtbl3_p;
drop table if exists jtbl3_u;
create table jtbl3_o (id int, m int);
create table jtbl3_p (id int, k int);
create table jtbl3_u (k int primary key);

insert into jtbl3_o select rownum, mod(rownum, 7) from db_class a, db_class b, db_class c limit 3000;
insert into jtbl3_p select rownum * 2, mod(rownum, 5) from db_class a, db_class b, db_class c limit 20;
insert into jtbl3_u values (0), (1), (2);

create index i_jtbl3_p_id on jtbl3_p (id);
create index i_jtbl3_o_m on jtbl3_o (m);

update statistics on jtbl3_o, jtbl3_p, jtbl3_u with fullscan;

-- Case 16
select count(*) from jtbl3_p right outer join jtbl3_o on jtbl3_o.id = jtbl3_p.id
  where coalesce(jtbl3_p.k, -1) in (select k from jtbl3_u);

-- Case 17
select count(*) from jtbl3_p right outer join jtbl3_o on jtbl3_o.id = jtbl3_p.id
  where coalesce(jtbl3_p.k, 0) in (select k from jtbl3_u);

-- Case 18
select count(*) from jtbl3_p right outer join jtbl3_o on jtbl3_o.id = jtbl3_p.id
  where exists (select 1 from jtbl3_u where jtbl3_u.k = coalesce(jtbl3_p.k, 0));

-- Case 19
select count(*) from jtbl3_p right outer join jtbl3_o on jtbl3_o.id = jtbl3_p.id
  semi join jtbl3_u on jtbl3_u.k = coalesce(jtbl3_p.k, 0);

drop table jtbl3_o, jtbl3_p, jtbl3_u;
