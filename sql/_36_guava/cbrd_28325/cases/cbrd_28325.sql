/**
 *  This test case verifies CBRD-28325: a constant ON term of a RIGHT OUTER JOIN that follows an ANTI JOIN.
 *
 *  Bug: an ON term of a RIGHT OUTER JOIN that folds to a constant has no table, so the optimizer attached it
 *  as a scan filter of the node right before the RIGHT OUTER JOIN, where a false term empties the left side.
 *  When that node is the inner table of an ANTI JOIN, emptying it keeps every outer row instead, so a false
 *  ON was ignored and the RIGHT OUTER JOIN matched rows (a cross product when the whole ON folds to the
 *  constant).
 *  Fix: the term is attached to the first node before the RIGHT OUTER JOIN that is not an ANTI JOIN inner.
 *
 *  Each query returns res and actual. actual is count(*)/count(a.id)/sum(a.id)/sum(d.id) of the query and
 *  res is PASS when it equals that of a query with the same meaning written without the ANTI JOIN and the
 *  constant term (the right table alone for a false ON, a LEFT JOIN with IS NULL for the ANTI JOIN).
 *
 *  Coverage:
 *    Case 1: issue Q1, ANTI JOIN then RIGHT JOIN ON d.v = a.v and 1 = 0
 *    Case 2: issue Q2, RIGHT JOIN ON d.v = a.v and coalesce (2, 1) = 1
 *    Case 3: RIGHT JOIN ON 1 = 0 only
 *    Case 4: false term from constant propagation on the left table: a.v = 7 and coalesce (a.v, 1) = 1
 *    Case 5: false term from constant propagation on the right table: d.v = 7 and coalesce (d.v, 1) = 1
 *    Case 6: two ANTI JOINs before the false RIGHT JOIN
 *    Case 7: INNER JOIN and ANTI JOIN before the false RIGHT JOIN
 *    Case 8: RIGHT JOIN and ANTI JOIN before the false RIGHT JOIN
 *    Case 9: a LEFT JOIN follows the false RIGHT JOIN
 *    Case 10: a RIGHT JOIN follows the false RIGHT JOIN
 *    Case 11: indexed tables
 *    Case 12: the term skips an ANTI JOIN inner and lands on the node of the previous RIGHT JOIN
 *    Case 13: INNER JOIN ON 1 = 1 before the ANTI JOIN
 *    Case 14: a view with the false RIGHT JOIN after an ANTI JOIN, under a LEFT JOIN
 *    Case 15: control, RIGHT JOIN ON d.v = a.v and 1 = 1
 *    Case 16: control, SEMI JOIN before the false RIGHT JOIN
 *    Case 17: control, INNER JOIN before the false RIGHT JOIN
 *    Case 18: control, LEFT JOIN ON 1 = 0 after the ANTI JOIN
 *    Case 19: control, RIGHT JOIN ON a predicate on the left table
 *    Case 20: control, the ANTI JOIN ON is false
 *    Case 21: control, ANTI JOIN after the false RIGHT JOIN
 *    Case 22: control, RIGHT JOIN before the false RIGHT JOIN
 */

drop view if exists v28325_ar;
drop table if exists t28325_a, t28325_b, t28325_c, t28325_d, t28325_e, t28325_ia, t28325_ic, t28325_id;

create table t28325_a (id int, v int);
create table t28325_b (id int, v int);
create table t28325_c (id int, v int);
create table t28325_d (id int, v int);
create table t28325_e (id int, v int);
insert into t28325_a values (1, 1), (2, 2), (3, 3), (4, null), (5, 2), (6, 7);
insert into t28325_b values (10, 1), (20, 2), (60, 7), (70, null), (80, 8);
insert into t28325_c values (100, 1), (200, 2), (300, 3);
insert into t28325_d values (1000, 1), (2000, 2), (3000, 3), (7000, 7);
insert into t28325_e values (1, 1), (2, 7);
create table t28325_ia (id int primary key, v int);
create table t28325_ic (id int primary key, v int);
create table t28325_id (id int primary key, v int);
insert into t28325_ia select * from t28325_a;
insert into t28325_ic select * from t28325_c;
insert into t28325_id select * from t28325_d;
create index i_t28325_ia_v on t28325_ia (v);
create index i_t28325_ic_v on t28325_ic (v);
create index i_t28325_id_v on t28325_id (v);
update statistics on t28325_a, t28325_b, t28325_c, t28325_d, t28325_e, t28325_ia, t28325_ic, t28325_id;
create view v28325_ar as select a.id aid, a.v av, d.id did, d.v dv from t28325_a a anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and 1 = 0;


evaluate 'Case 1: issue Q1, ANTI JOIN then RIGHT JOIN ON d.v = a.v and 1 = 0';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and 1 = 0) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

evaluate 'Case 2: issue Q2, RIGHT JOIN ON d.v = a.v and coalesce (2, 1) = 1';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and coalesce (2, 1) = 1) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

evaluate 'Case 3: RIGHT JOIN ON 1 = 0 only';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v right join t28325_d d on 1 = 0) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

evaluate 'Case 4: false term from constant propagation on the left table: a.v = 7 and coalesce (a.v, 1) = 1';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and a.v = 7 and coalesce (a.v, 1) = 1) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

evaluate 'Case 5: false term from constant propagation on the right table: d.v = 7 and coalesce (d.v, 1) = 1';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and d.v = 7 and coalesce (d.v, 1) = 1) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

evaluate 'Case 6: two ANTI JOINs before the false RIGHT JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v anti join t28325_b e on e.v = a.v right join t28325_d d on d.v = a.v and 1 = 0) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

evaluate 'Case 7: INNER JOIN and ANTI JOIN before the false RIGHT JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a inner join t28325_b b on b.v = a.v anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and 1 = 0) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

evaluate 'Case 8: RIGHT JOIN and ANTI JOIN before the false RIGHT JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_b b right join t28325_a a on a.v = b.v anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and 1 = 0) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

evaluate 'Case 9: a LEFT JOIN follows the false RIGHT JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and 1 = 0 left join t28325_b e on e.v = d.v) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d left join t28325_b e on e.v = d.v) o;

evaluate 'Case 10: a RIGHT JOIN follows the false RIGHT JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and 1 = 0 right join t28325_b e on e.v = d.v) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_b e left join t28325_d d on e.v = d.v) o;

evaluate 'Case 11: indexed tables';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_ia a anti join t28325_ic c on c.v = a.v right join t28325_id d on d.v = a.v and 1 = 0) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_id d) o;

evaluate 'Case 12: the term skips an ANTI JOIN inner and lands on the node of the previous RIGHT JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), count(d.id), nvl(sum(f.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and 1 = 0 anti join t28325_c e on e.v = d.v right join t28325_b f on f.v = d.v and 1 = 0) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(f.id), 0)) as sig from t28325_b f) o;

evaluate 'Case 13: INNER JOIN ON 1 = 1 before the ANTI JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a inner join t28325_b b on 1 = 1 anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and 1 = 0) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

evaluate 'Case 14: a view with the false RIGHT JOIN after an ANTI JOIN, under a LEFT JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(w.aid), nvl(sum(w.aid), 0), nvl(sum(w.did), 0)) as sig from t28325_e x left join v28325_ar w on w.dv = x.v) t,
  (select concat_ws('/', count(*), count(w.aid), nvl(sum(w.aid), 0), nvl(sum(w.did), 0)) as sig from t28325_e x left join (select cast (null as int) aid, d.id did, d.v dv from t28325_d d) w on w.dv = x.v) o;

evaluate 'Case 15: control, RIGHT JOIN ON d.v = a.v and 1 = 1';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and 1 = 1) t,
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_d d left join (select a.id, a.v from t28325_a a left join t28325_c c on c.v = a.v where c.id is null) a on d.v = a.v) o;

evaluate 'Case 16: control, SEMI JOIN before the false RIGHT JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a semi join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and 1 = 0) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

evaluate 'Case 17: control, INNER JOIN before the false RIGHT JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a inner join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and 1 = 0) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

evaluate 'Case 18: control, LEFT JOIN ON 1 = 0 after the ANTI JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v left join t28325_d d on d.v = a.v and 1 = 0) t,
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), 0) as sig from (select a.id, a.v from t28325_a a left join t28325_c c on c.v = a.v where c.id is null) a) o;

evaluate 'Case 19: control, RIGHT JOIN ON a predicate on the left table';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a anti join t28325_c c on c.v = a.v right join t28325_d d on d.v = a.v and a.id = 6) t,
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_d d left join (select a.id, a.v from t28325_a a left join t28325_c c on c.v = a.v where c.id is null) a on d.v = a.v and a.id = 6) o;

evaluate 'Case 20: control, the ANTI JOIN ON is false';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), 0) as sig from t28325_a a anti join t28325_c c on c.v = a.v and 1 = 0) t,
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), 0) as sig from t28325_a a) o;

evaluate 'Case 21: control, ANTI JOIN after the false RIGHT JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_a a right join t28325_d d on d.v = a.v and 1 = 0 anti join t28325_c c on c.v = d.v) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d where not exists (select 1 from t28325_c c where c.v = d.v)) o;

evaluate 'Case 22: control, RIGHT JOIN before the false RIGHT JOIN';
select if (t.sig = o.sig, 'PASS', 'FAIL') as res, t.sig as actual from
  (select concat_ws('/', count(*), count(a.id), nvl(sum(a.id), 0), nvl(sum(d.id), 0)) as sig from t28325_b b right join t28325_a a on a.v = b.v right join t28325_d d on d.v = a.v and 1 = 0) t,
  (select concat_ws('/', count(*), 0, 0, nvl(sum(d.id), 0)) as sig from t28325_d d) o;

drop view v28325_ar;
drop table t28325_a, t28325_b, t28325_c, t28325_d, t28325_e, t28325_ia, t28325_ic, t28325_id;
