/**
 *  This test case verifies CBRD-28365: [Regression][analytic] An analytic function over an index scan
 *  of a partitioned table skips its sort and returns wrong values
 *
 *  An analytic function skips its sort when the index scan under it returns the rows in the order
 *  of its OVER clause. A partitioned table or a class hierarchy is scanned one class at a time, so
 *  its rows are in key order only within each class, and before the fix the analytic values were
 *  wrong. An NL join whose inner reads a class hierarchy class by class runs the outer scan again
 *  for each class and loses the outer order the same way. The fix sorts in these cases.
 *
 *  Each query runs inside a derived table ordered by id, and USING INDEX with (+) keeps it on the
 *  index scan that takes the bug path, so a wrong order shows in the values of rn.
 *
 *  Coverage:
 *    Case 1:  an index scan of a partitioned table - the analytic sort runs
 *    Case 2:  the analytic LIMIT optimization over a partitioned table - the sort runs before the LIMIT
 *    Case 3:  an index scan of a class hierarchy - the analytic sort runs
 *    Case 4:  an NL join whose inner reads a class hierarchy class by class - the analytic sort runs
 */

drop table if exists t_child;
drop table if exists t_parent, t_part, t_outer;

-- the hash partitions of t_part hold id 3, 4 and 6 and id 1, 2 and 5, so neither holds the v values in order
create table t_part (id int, v int) partition by hash (id) partitions 2;
insert into t_part values (1, 10), (2, 20), (3, 30), (4, 40), (5, 50), (6, 60);
create index i_part_v on t_part (v);

-- an index scan of all t_parent needs the index on each class of the hierarchy
create table t_parent (id int, v int);
create table t_child under t_parent;
insert into t_parent values (1, 10), (3, 30), (5, 50);
insert into t_child values (2, 20), (4, 40), (6, 60);
create index i_parent_v on t_parent (v);
create index i_parent_v on t_child (v);

create table t_outer (id int);
insert into t_outer values (1), (2), (3), (4), (5), (6);
create index i_outer_id on t_outer (id);


evaluate 'Case 1: an index scan of a partitioned table - the analytic sort runs; result = rn follows v';
select id, v, rn from (select id, v, row_number () over (order by v) as rn from t_part where v > 0 using index i_part_v(+)) x order by id;


evaluate 'Case 2: the analytic LIMIT optimization over a partitioned table - the sort runs before the LIMIT; result = v 10 to 30 with rn 1 to 3';
-- with no ORDER BY in the derived table, LIMIT keeps the first rows of the analytic output, which comes in the order of v
select id, v, rn from (select id, v, row_number () over (order by v) as rn from t_part where v > 0 using index i_part_v(+) limit 3) x order by id;


evaluate 'Case 3: an index scan of a class hierarchy - the analytic sort runs; result = rn follows v';
select id, v, rn from (select id, v, row_number () over (order by v) as rn from all t_parent where v > 0 using index i_parent_v(+)) x order by id;


evaluate 'Case 4: an NL join whose inner reads a class hierarchy class by class - the analytic sort runs; result = rn follows id';
select id, v, rn from (select /*+ ordered use_nl */ o.id, p.v, row_number () over (order by o.id) as rn from t_outer o, all t_parent p where o.id > 0 and p.id = o.id using index i_outer_id(+)) x order by id;


drop table t_child;
drop table t_parent, t_part, t_outer;
