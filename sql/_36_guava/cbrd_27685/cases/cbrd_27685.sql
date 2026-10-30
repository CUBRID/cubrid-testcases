/**
 *  This test case verifies CBRD-27685: a join with GROUP BY ... LIMIT reads the groups in the order of
 *  an index on its outer table and stops when it has the LIMIT groups.
 *
 *  Before the fix the GROUP BY skip (no GROUP BY sort, aggregation during the scan) was used only for a
 *  single table. A join read every row, sorted them for the GROUP BY and then applied the LIMIT. Now a
 *  nested-loop join whose outer index gives the GROUP BY order skips the sort and stops the whole join
 *  at the LIMIT groups. Without a LIMIT the join keeps its plan.
 *
 *  Each tested query is followed by its twin with the USE_HASH hint, which sorts the GROUP BY as before.
 *  The results must match. CTP masks digits: the proof is the plan (NESTED LOOPS over the outer index
 *  scan, group by nosort) and the GROUPBY line of the trace (sort: false).
 *
 *  Coverage:
 *    Case 1:  GROUP_CONCAT with ORDER BY over the join, as in RND-2589 scenario 32
 *    Case 2:  the join stops: a row past the LIMIT groups divides by zero, so a full join fails
 *    Case 3:  LEFT OUTER JOIN, outer keys without an inner row
 *    Case 4:  LIMIT offset, count, the LIMIT past the last group, and ORDER BY the GROUP BY key
 *    Case 5:  COUNT DISTINCT, SUM, MIN, MAX, a NULL inner value
 *    Case 6:  several outer rows per group (a non-unique outer index), and a three-table join
 *    Case 7:  no LIMIT, a HAVING over an aggregate, GROUP BY DESC: the join sorts as before
 *    Case 8:  an inner partitioned class or class hierarchy is read one partition or class after another, each
 *             over the whole outer scan, so the rows of a group do not come together: the join sorts
 */

drop table if exists t_digit, t_mv, t_aka, t_note, t_akap, t_akac_sub, t_akac;

-- ten digits for the cross joins below
create table t_digit (i int);
insert into t_digit values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
-- 20000 movies: g groups them by 10 (index i_mv_g), y is a year
create table t_mv (id int primary key, g int not null, y int);
insert into t_mv select rownum, (rownum - 1) div 10, 1990 + mod(rownum, 35) from t_digit a, t_digit b, t_digit c, t_digit d, t_digit e limit 20000;
create index i_mv_g on t_mv (g);
-- 12000 titles of the movies 1, 4, 7, ... (two each, so two movies in three have none), and v is never 0
-- except on the last movie, whose row is added below. w is NULL on every eleventh row
create table t_aka (id int primary key, mid int not null, title varchar(30), v int, w int);
insert into t_aka select rownum, mod(rownum, 6000) * 3 + 1, 'aka ' || mod(rownum * 37, 1000), mod(rownum, 7) + 1, case when mod(rownum, 11) = 0 then null else mod(rownum, 50) end from t_digit a, t_digit b, t_digit c, t_digit d, t_digit e limit 12000;
insert into t_aka values (12001, 20000, 'last', 0, 0);
create index i_aka_mid on t_aka (mid);
-- notes of the titles, for the three-table join
create table t_note (id int primary key, aid int not null, n int);
insert into t_note select rownum, mod(rownum, 12000) + 1, mod(rownum, 5) from t_digit a, t_digit b, t_digit c, t_digit d, t_digit e limit 18000;
create index i_note_aid on t_note (aid);
-- the titles again in three hash partitions, and split between a class and its subclass
create table t_akap (id int, mid int not null, v int) partition by hash (id) partitions 3;
insert into t_akap select id, mid, v from t_aka;
create index i_akap_mid on t_akap (mid);
create table t_akac (id int, mid int not null, v int);
create table t_akac_sub under t_akac;
insert into t_akac select id, mid, v from t_aka where mod(id, 2) = 0;
insert into t_akac_sub select id, mid, v from t_aka where mod(id, 2) = 1;
create index i_akac_mid on t_akac (mid);
create index i_akac_sub_mid on t_akac_sub (mid);
update statistics on t_digit, t_mv, t_aka, t_note, t_akap, t_akac, t_akac_sub with fullscan;

set trace on;


evaluate 'Case 1: GROUP_CONCAT with ORDER BY over the join (RND-2589 scenario 32); result = use_hash';
select /*+ recompile */ m.id, group_concat(a.title order by a.title separator ', ') from t_mv m join t_aka a on a.mid = m.id group by m.id limit 20;
show trace;
select /*+ recompile use_hash */ m.id, group_concat(a.title order by a.title separator ', ') from t_mv m join t_aka a on a.mid = m.id group by m.id limit 20;


evaluate 'Case 2: the join stops at the LIMIT groups: the row of the last movie divides by zero; result = use_hash with the row excluded';
select /*+ recompile */ m.id, count(*), sum(a.v) from t_mv m join t_aka a on a.mid = m.id and 100 / a.v > 0 group by m.id limit 30;
show trace;
select /*+ recompile use_hash */ m.id, count(*), sum(a.v) from t_mv m join t_aka a on a.mid = m.id and a.v > 0 group by m.id limit 30;


evaluate 'Case 3: LEFT OUTER JOIN, two outer keys in three have no inner row; result = use_hash';
select /*+ recompile */ m.id, count(a.id), max(a.title) from t_mv m left join t_aka a on a.mid = m.id group by m.id limit 25;
show trace;
select /*+ recompile use_hash */ m.id, count(a.id), max(a.title) from t_mv m left join t_aka a on a.mid = m.id group by m.id limit 25;


evaluate 'Case 4: LIMIT offset, count; a LIMIT past the last group; ORDER BY the GROUP BY key; result = use_hash';
select /*+ recompile */ m.id, count(*) from t_mv m join t_aka a on a.mid = m.id group by m.id limit 100, 10;
show trace;
select /*+ recompile use_hash */ m.id, count(*) from t_mv m join t_aka a on a.mid = m.id group by m.id limit 100, 10;
select /*+ recompile */ count(*), sum(c), sum(s) from (select m.id, count(*) c, sum(a.v) s from t_mv m join t_aka a on a.mid = m.id and a.v > 0 group by m.id limit 7000) x;
select /*+ recompile use_hash */ count(*), sum(c), sum(s) from (select m.id, count(*) c, sum(a.v) s from t_mv m join t_aka a on a.mid = m.id and a.v > 0 group by m.id limit 7000) x;
select /*+ recompile */ m.id, count(*) from t_mv m join t_aka a on a.mid = m.id group by m.id order by m.id limit 15;
show trace;
select /*+ recompile use_hash */ m.id, count(*) from t_mv m join t_aka a on a.mid = m.id group by m.id order by m.id limit 15;


evaluate 'Case 5: COUNT DISTINCT, SUM, MIN, MAX and a NULL inner value; result = use_hash';
select /*+ recompile */ m.id, count(distinct a.v), sum(a.w), min(a.w), max(a.title), count(a.w) from t_mv m join t_aka a on a.mid = m.id group by m.id limit 40;
show trace;
select /*+ recompile use_hash */ m.id, count(distinct a.v), sum(a.w), min(a.w), max(a.title), count(a.w) from t_mv m join t_aka a on a.mid = m.id group by m.id limit 40;


evaluate 'Case 6: ten outer rows per group (index i_mv_g), and a three-table join; result = use_hash';
select /*+ recompile */ m.g, count(*), sum(a.v), min(m.id) from t_mv m join t_aka a on a.mid = m.id where m.g >= 0 group by m.g limit 12;
show trace;
select /*+ recompile use_hash */ m.g, count(*), sum(a.v), min(m.id) from t_mv m join t_aka a on a.mid = m.id where m.g >= 0 group by m.g limit 12;
select /*+ recompile */ m.id, count(*), sum(n.n) from t_mv m join t_aka a on a.mid = m.id join t_note n on n.aid = a.id group by m.id limit 18;
show trace;
select /*+ recompile use_hash */ m.id, count(*), sum(n.n) from t_mv m join t_aka a on a.mid = m.id join t_note n on n.aid = a.id group by m.id limit 18;


evaluate 'Case 7: no LIMIT, a HAVING over an aggregate, GROUP BY DESC: the join sorts the GROUP BY as before';
select /*+ recompile */ count(*), sum(c) from (select m.id, count(*) c from t_mv m join t_aka a on a.mid = m.id and a.v > 0 group by m.id) x;
show trace;
select /*+ recompile */ m.id, count(*) from t_mv m join t_aka a on a.mid = m.id group by m.id having count(*) > 1 limit 5;
show trace;
select /*+ recompile */ m.id, count(*) from t_mv m join t_aka a on a.mid = m.id and a.v > 0 group by m.id desc limit 5;
show trace;


evaluate 'Case 8: an inner partitioned class and an inner class hierarchy: the join sorts the GROUP BY; result = use_hash';
select /*+ recompile */ m.id, count(*), sum(a.v) from t_mv m join t_akap a on a.mid = m.id group by m.id limit 12;
show trace;
select /*+ recompile use_hash */ m.id, count(*), sum(a.v) from t_mv m join t_akap a on a.mid = m.id group by m.id limit 12;
select /*+ recompile */ m.id, count(*), sum(a.v) from t_mv m join all t_akac a on a.mid = m.id group by m.id limit 12;
show trace;
select /*+ recompile use_hash */ m.id, count(*), sum(a.v) from t_mv m join all t_akac a on a.mid = m.id group by m.id limit 12;

set trace off;
drop table t_digit, t_mv, t_aka, t_note, t_akap, t_akac_sub, t_akac;
