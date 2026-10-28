/**
 *  CBRD-27187: a GROUP BY over a join can read the rows in the order of an index on the first
 *  table and skip the sort, as a GROUP BY on a single table already does.
 *
 *  An index scan with no key range is offered only because it returns the rows in GROUP BY
 *  order. Before the fix that scan was thrown away as soon as the statement had a join, even
 *  with a USING INDEX hint, so a GROUP BY over a join was always sorted. Now the sort is skipped
 *  when the join passes the rows of its first table on in index order: a nested loop join (inner
 *  or left outer) does, a hash join does not, and with a right outer join the GROUP BY column
 *  comes from the side that is filled with NULL. A partitioned table or a class hierarchy as the
 *  inner does not either: it is read one partition or class at a time and the first table is read
 *  again for each, so the rows of a group come apart.
 *
 *  Coverage:
 *  1    the reported queries: GROUP BY on t_a alone as the reference, and the same with a
 *       one-row cross join
 *  2    an inner join under a cross join, the index of t_a is two joins down
 *  3    left outer join, a t_a row without a match in t_b is counted in its group
 *  4    hash join, the GROUP BY is still sorted
 *  5    right outer join, the GROUP BY is still sorted and the t_b row without a match makes
 *       the NULL group
 *  6    partitioned table as the inner, the GROUP BY is still sorted
 *  7    class hierarchy as the inner, the GROUP BY is still sorted
 */

drop table if exists t_a, t_b, t_one, t_p;
drop table if exists t_h1, t_h2;
drop table if exists t_h;

create table t_a (id int primary key, g int not null);
create index i_a_g on t_a (g);
create table t_b (id int primary key, a_id int);
create index i_b_aid on t_b (a_id);
create table t_one (x int);
create table t_p (id int primary key, a_id int)
  partition by range (id) (partition p1 values less than (100), partition p2 values less than (200));
create index i_p_aid on t_p (a_id);
create table t_h (id int primary key, a_id int);
create table t_h1 under t_h;
create table t_h2 under t_h;
create index i_h_aid on t_h (a_id);

insert into t_a values (1, 3), (2, 1), (3, 2), (4, 1), (5, 3), (6, 2);
insert into t_b values (11, 1), (12, 2), (13, 2), (14, 4), (15, 5), (16, 6), (17, 6), (18, 9);
insert into t_one values (1);
insert into t_p values (11, 1), (12, 2), (13, 2), (14, 4), (115, 5), (116, 6), (117, 6), (118, 9);
insert into t_h1 values (11, 1), (12, 2), (13, 2), (14, 4);
insert into t_h2 values (115, 5), (116, 6), (117, 6), (118, 9);

update statistics on t_a, t_b, t_one, t_p, t_h, t_h1, t_h2 with fullscan;


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


evaluate 'Case 5: right outer join, the GROUP BY is still sorted and the t_b row without a match makes the NULL group';
--@queryplan
select /*+ recompile */ a.g, count(*) as cnt
  from t_a a right outer join t_b b on b.a_id = a.id
 group by a.g
 using index a.i_a_g;


evaluate 'Case 6: partitioned table as the inner, the GROUP BY is still sorted';
--@queryplan
select /*+ recompile ordered use_idx */ a.g, count(*) as cnt
  from t_a a, t_p p
 where p.a_id = a.id
 group by a.g
 using index a.i_a_g;


evaluate 'Case 7: class hierarchy as the inner, the GROUP BY is still sorted';
--@queryplan
select /*+ recompile ordered */ a.g, count(*) as cnt
  from t_a a, all t_h h
 where h.a_id = a.id
 group by a.g
 using index a.i_a_g;


drop table t_a, t_b, t_one, t_p;
drop table t_h1, t_h2;
drop table t_h;
