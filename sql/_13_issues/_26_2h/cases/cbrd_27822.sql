/**
 *  CBRD-27822: ROW_NUMBER and RANK must count the rows a LIMIT offset skips under a forced index scan,
 *  also when that scan drives a nested-loop join.
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
 *       the first returned row starting the next partition
 *  3    RANK over c1: the first returned row is a peer of the skipped row
 *  4    ROWNUM in the select list: each row keeps its ROWNUM while the skipped row is counted
 *  5    a nested-loop join driven by the index scan (ORDERED USE_NL): the join loop counts the
 *       skipped row
 */

drop table if exists t1;
drop table if exists t2;

create table t1 (c1 int, c2 int);
insert into t1 values (1, 10), (1, 20), (2, 30), (2, 40);
create index t1_idx on t1 (c1, c2);
create table t2 (c1 int primary key);
insert into t2 values (1), (2);


evaluate 'Case 1: an empty OVER clause -- ROW_NUMBER counts the row the offset skips';
select /*+ recompile */ row_number() over () as r, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 1, 3;


evaluate 'Case 2: PARTITION BY c1 ORDER BY c2 -- offset 1 returns a row in the partition of the skipped row, offset 2 a row that starts the next partition';
select /*+ recompile */ row_number() over (partition by c1 order by c2) as r, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 1, 3;
select /*+ recompile */ row_number() over (partition by c1 order by c2) as r, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 2, 2;


evaluate 'Case 3: RANK over c1 -- the first returned row is a peer of the skipped row, and the next rows rank after both';
select /*+ recompile */ rank() over (order by c1) as r, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 1, 3;


evaluate 'Case 4: ROWNUM in the select list -- each row keeps its ROWNUM while ROW_NUMBER counts the skipped row';
select /*+ recompile */ rownum as rn, row_number() over () as r, c1, c2 from t1 where c1 > 0 using index t1_idx(+) limit 1, 3;


evaluate 'Case 5: a nested-loop join driven by the index scan -- the join loop counts the row the offset skips';
select /*+ recompile ordered use_nl */ row_number() over (partition by t1.c1 order by t1.c2) as r, t1.c1, t1.c2 from t1, t2 where t1.c1 = t2.c1 and t1.c1 > 0 using index t1.t1_idx(+) limit 1, 3;


drop table t1;
drop table t2;
