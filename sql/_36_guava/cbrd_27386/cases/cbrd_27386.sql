/*
 * This test case verifies CBRD-27386 : the cost of a correlated subquery in a
 * WHERE sarg was multiplied by every row the scan reads, ignoring the other
 * sarg filters, so the subquery cost was overestimated (ticket CASE 1: one
 * real execution priced as 30,116) and plans flipped.
 *
 * Bug: CBRD-26403 made the subquery cost "subquery cost x scan_rows" (all
 * rows of an sscan, the heap rows of an iscan). But a term containing a
 * subquery is placed in the if-predicate (plan_generation.c,
 * is_normal_access_term ()), which is evaluated only for rows that passed the
 * access predicate, and a less selective index therefore looked cheaper than
 * a full scan as soon as a subquery was present: the sscan was charged
 * NCARD subquery executions, the iscan only NCARD * sel.
 *
 * Fix: qo_plan_subquery_eval_rows () multiplies the subquery cost by the rows
 * that reach the subquery term: scan_rows x sel(access predicate terms) x
 * sel(if-predicate terms evaluated before it), with no lower bound.
 *
 * Data: sq_big 20,000 rows (~200 pages): flag = 1 for 99% of the rows
 * (i_sq_big_flag, a useless index), cat has 100 values (i_sq_big_cat,
 * 200 rows per value), txt is unique and not indexed. sq_child 20,000 rows,
 * one per sq_big row (i_sq_child_big, covering for count(*)). sq_small
 * 100 rows whose a_id hits sq_big.id.
 *   Case 1: control without a subquery: flag = 1 AND txt = .. -> sscan.
 *   Case 2: same predicate plus a correlated count(*) subquery -> sscan,
 *           the same plan as Case 1, one row. The regression is iscan on
 *           i_sq_big_flag (99% of the table through the index), which the old
 *           formula chose because 20,000 x subquery cost (sscan) exceeded
 *           19,800 x subquery cost (iscan) by more than the index penalty.
 *   Case 3: selective index plus the subquery: cat = 45 AND txt = .. AND
 *           subquery -> iscan on i_sq_big_cat (200 heap rows, the subquery is
 *           charged for at most one row). Guards that the fix does not push
 *           a genuinely selective index scan to sscan.
 *   Case 4: RND-2640 shape: sq_big has only the subquery term as its sarg
 *           and joins the 100-row sq_small -> sq_small must drive (idx-join,
 *           outer sscan sq_small, inner iscan sq_big on its primary key).
 *           Guards the multiplier against under-charging: with a lower
 *           bound per probe or a too-small multiplier the 20,000-row sq_big
 *           would drive and run the subquery for every row.
 */
drop table if exists sq_small, sq_child, sq_big, sq_d;

create table sq_d (n int primary key);
insert into sq_d values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

create table sq_big (id int primary key, flag int, cat int, txt varchar(50));
create index i_sq_big_flag on sq_big (flag);
create index i_sq_big_cat on sq_big (cat);
create table sq_child (id int primary key, big_id int, v int);
create index i_sq_child_big on sq_child (big_id);
create table sq_small (id int primary key, a_id int, z int);

-- sq_big: 20,000 rows, flag 1 for 99%, cat 100 values, txt unique
insert into sq_big
select x.id,
       case when mod (x.id, 100) = 0 then 0 else 1 end,
       mod (x.id, 100),
       concat ('txt_', cast (x.id as varchar))
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n + 10000 * f.n as id
      from sq_d a, sq_d b, sq_d c, sq_d e, sq_d f where f.n < 2) x;

-- sq_child: 20,000 rows, exactly one child per sq_big row
insert into sq_child
select x.id, x.id, mod (x.id, 7)
from (select a.n + 10 * b.n + 100 * c.n + 1000 * e.n + 10000 * f.n as id
      from sq_d a, sq_d b, sq_d c, sq_d e, sq_d f where f.n < 2) x;

-- sq_small: 100 rows, a_id = 100 * id (all hit sq_big.id)
insert into sq_small
select x.id, 100 * x.id, mod (x.id, 3)
from (select a.n + 10 * b.n as id from sq_d a, sq_d b) x;

update statistics on sq_big, sq_child, sq_small with fullscan;

select count(*) from sq_big;
select count(*) from sq_big where flag = 1;
select count(*) from sq_child;
select count(*) from sq_small;

-- Case 1: control, no subquery -> sscan
evaluate '[1] control without subquery: flag = 1 AND txt = .. -> sscan sq_big';
--@queryplan
select /*+ recompile */ b.id from sq_big b where b.flag = 1 and b.txt = 'txt_12345';

-- Case 2: the same predicate plus a correlated subquery must keep the sscan
evaluate '[2] with correlated subquery: still sscan sq_big (regression = iscan on i_sq_big_flag)';
--@queryplan
select /*+ recompile */ b.id from sq_big b
where b.flag = 1 and b.txt = 'txt_12345'
  and (select count(*) from sq_child c where c.big_id = b.id) > 0;

-- Case 3: a selective index plus the subquery stays iscan
evaluate '[3] selective index + subquery: iscan on i_sq_big_cat';
--@queryplan
select /*+ recompile */ b.id from sq_big b
where b.cat = 45 and b.txt = 'txt_12345'
  and (select count(*) from sq_child c where c.big_id = b.id) > 0;

-- Case 4: RND-2640 shape, the small table must drive
evaluate '[4] subquery-only sarg on sq_big joined with sq_small: idx-join, outer sscan sq_small, inner iscan sq_big';
--@queryplan
select /*+ recompile */ count(*)
from sq_big b, sq_small s
where s.a_id = b.id
  and (select count(*) from sq_child c where c.big_id = b.id) > 0;

drop table sq_small, sq_child, sq_big, sq_d;
