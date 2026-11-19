/**
 *  CBRD-27822: ROW_NUMBER, RANK, DENSE_RANK and FIRST_VALUE must take in the rows a LIMIT offset skips
 *  under a forced index scan, also when that scan drives a nested-loop join.
 *
 *  Under the LIMIT optimization (ROW_NUMBER, RANK, DENSE_RANK, FIRST_VALUE whose OVER order is empty
 *  or covered by the index) the analytic values are computed while the rows are read. With an index
 *  scan the offset became a lower key limit, so the scan skipped those rows before they were counted
 *  and the first returned row was numbered as the first row. And a row read before the first returned
 *  row was taken as the first row without comparing it with the row before it, so a partition or a
 *  group of RANK peers that began in the skipped rows did not go on in the returned rows. Under a
 *  nested-loop join the scan loop did not pass the skipped rows to the analytic functions at all.
 *
 *  The queries have no ORDER BY (it would turn LIMIT into orderby_num ()), so their rows come in the
 *  order of the forced index on (c1, c2).
 *
 *  Coverage:
 *  1    an empty OVER clause: the skipped row is counted
 *  2    PARTITION BY c1 ORDER BY c2: the first returned row in the partition of the skipped row, then
 *       the first returned row starting the next partition (a control: the same result before the fix)
 *  3    RANK over c1: the first returned row is a peer of the skipped row
 *  4    ROWNUM in the select list: each row keeps its ROWNUM while the skipped row is counted
 *  5    a nested-loop join driven by the index scan (ORDERED USE_NL): the join loop counts the
 *       skipped row
 *  6    FIRST_VALUE: the first value of the partition is the value of the skipped row
 *  7    DENSE_RANK over c1: the skipped rows are a whole rank, and the first returned row takes the
 *       next rank
 *  8    a correlated subquery: each run of the subquery starts the count of the rows it reads again,
 *       so every run counts the row its offset skips
 *  9    a condition on a column the index does not hold (c3): the offset never became a key limit, so
 *       the skipped row was read before the fix too, and RANK must compare the first returned row with it
 */

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

create table t1 (c1 int, c2 int);
insert into t1 values (1, 10), (1, 20), (2, 30), (2, 40);
create index t1_idx on t1 (c1, c2);
create table t2 (c1 int primary key);
insert into t2 values (1), (2);
create table t3 (c1 int, c2 int, c3 int);
insert into t3 select c1, c2, 1 from t1;
create index t3_idx on t3 (c1, c2);


evaluate 'Case 1: an empty OVER clause -- ROW_NUMBER counts the row the offset skips';
select /*+ recompile */ row_number() over () as r, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 1, 3;


evaluate 'Case 2: PARTITION BY c1 ORDER BY c2 -- offset 1 returns a row in the partition of the skipped row, offset 2 a row that starts the next partition (a control: the same result before the fix)';
select /*+ recompile */ row_number() over (partition by c1 order by c2) as r, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 1, 3;
select /*+ recompile */ row_number() over (partition by c1 order by c2) as r, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 2, 2;


evaluate 'Case 3: RANK over c1 -- the first returned row is a peer of the skipped row, and the next rows rank after both';
select /*+ recompile */ rank() over (order by c1) as r, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 1, 3;


evaluate 'Case 4: ROWNUM in the select list -- each row keeps its ROWNUM while ROW_NUMBER counts the skipped row';
select /*+ recompile */ rownum as rn, row_number() over () as r, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 1, 3;


evaluate 'Case 5: a nested-loop join driven by the index scan -- the join loop counts the row the offset skips';
select /*+ recompile ordered use_nl */ row_number() over (partition by t1.c1 order by t1.c2) as r, t1.c1, t1.c2 from t1, t2 where t1.c1 = t2.c1 and t1.c1 > 0 using index t1.t1_idx(+) limit 1, 3;


evaluate 'Case 6: FIRST_VALUE over PARTITION BY c1 ORDER BY c2 -- the first value of the partition is the value of the row the offset skips';
select /*+ recompile */ first_value(c2) over (partition by c1 order by c2) as f, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 1, 3;


evaluate 'Case 7: DENSE_RANK over c1 -- the offset skips a whole rank, and the first returned row takes the next rank';
select /*+ recompile */ dense_rank() over (order by c1) as d, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 2, 2;


evaluate 'Case 8: a correlated subquery -- each run of the subquery starts its count again and counts the row its offset skips';
select /*+ recompile */ o.c1, o.c2, (select row_number() over (partition by i.c1 order by i.c2) from t1 i where i.c1 = o.c1 using index t1_idx(+) limit 1, 1) as s from t1 o order by o.c1, o.c2;


evaluate 'Case 9: a condition on c3, which the index does not hold -- the offset does not become a key limit, and RANK still compares the first returned row with the skipped row';
select /*+ recompile */ rank() over (order by c1) as r, c1, c2 from t3 where c1 > 0 and c3 > 0 using index t3_idx(+) limit 1, 3;


drop table t1;
drop table t2;
drop table t3;
