/**
 *  CBRD-27187: a GROUP BY over a join can read the rows in the order of an index on the first
 *  table and skip the sort, as a GROUP BY on a single table already does.
 *
 *  An index scan with no key range is offered only because it returns the rows in GROUP BY
 *  order. Before the fix that scan was thrown away as soon as the statement had a join, even
 *  with a USING INDEX hint, so a GROUP BY over a join was always sorted. Now the sort is skipped
 *  when the join passes the rows of its first table on in index order: a nested loop join (inner
 *  or left outer) does, a hash join does not, and with a right outer join the GROUP BY column
 *  comes from the side that is filled with NULL.
 *
 *  Coverage:
 *  1    the reported queries: GROUP BY on t_a alone as the reference, and the same with a
 *       one-row cross join
 *  2    an inner join under a cross join, the index of t_a is two joins down
 *  3    left outer join, a t_a row without a match in t_b is counted in its group
 *  4    hash join, the GROUP BY is still sorted
 *  5    right outer join, the t_b row without a match makes the NULL group
 */

drop table if exists t_a, t_b, t_one;

create table t_a (id int primary key, g int not null);
create index i_a_g on t_a (g);
create table t_b (id int primary key, a_id int);
create index i_b_aid on t_b (a_id);
create table t_one (x int);

insert into t_a values (1, 3), (2, 1), (3, 2), (4, 1), (5, 3), (6, 2);
insert into t_b values (11, 1), (12, 2), (13, 2), (14, 4), (15, 5), (16, 6), (17, 6), (18, 9);
insert into t_one values (1);

update statistics on t_a, t_b, t_one with fullscan;


evaluate 'Case 1: the reported queries -- GROUP BY on t_a alone, and the same with a one-row cross join';
--@queryplan
select /*+ recompile */ a.g, count(*) as cnt from t_a a group by a.g using index a.i_a_g;
--@queryplan
select /*+ recompile */ a.g, count(*) as cnt from t_a a, t_one o group by a.g using index a.i_a_g;


evaluate 'Case 2: an inner join under a cross join, the index of t_a is two joins down';
--@queryplan
select /*+ recompile ordered use_idx */ a.g, count(*) as cnt
  from t_a a, t_b b, t_one o
 where b.a_id = a.id
 group by a.g
 using index a.i_a_g, b.i_b_aid;


evaluate 'Case 3: left outer join, a t_a row without a match in t_b is counted in its group';
--@queryplan
select /*+ recompile use_idx */ a.g, count(*) as cnt, count(b.id) as cnt_b
  from t_a a left outer join t_b b on b.a_id = a.id
 group by a.g
 using index a.i_a_g, b.i_b_aid;


evaluate 'Case 4: hash join, the GROUP BY is still sorted';
--@queryplan
select /*+ recompile ordered use_hash */ a.g, count(*) as cnt
  from t_a a, t_b b
 where b.a_id = a.id
 group by a.g
 using index a.i_a_g, b.i_b_aid;


evaluate 'Case 5: right outer join, the t_b row without a match makes the NULL group';
select /*+ recompile */ a.g, count(*) as cnt
  from t_a a right outer join t_b b on b.a_id = a.id
 group by a.g
 using index a.i_a_g;


drop table t_a, t_b, t_one;
