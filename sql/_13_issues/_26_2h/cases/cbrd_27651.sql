/**
 *  This test case verifies CBRD-27651: a parallel hash join returns the serial result when its join
 *  condition calls a function.
 *
 *  A parallel hash join gives each worker its own copy of the join condition (cubxasl::spawner).
 *  The copy of a function call (a regu variable of TYPE_FUNC)
 *  took its function node from the copy instead of the original,
 *  so the worker's function node was NULL and the server crashed when the worker evaluated it.
 *
 *  The fix copies the original's node and frees what the worker's copy then holds:
 *  the constant arguments of the function and the pattern a REGEXP_* function compiles.
 *  It also frees the pattern RLIKE compiles into the worker's copy, which was never freed.
 *
 *  test_mode lowers the page threshold of the parallel hash join to 0 and CTP masks the digits of the trace,
 *  so the trace shows the parallel workers of the HASHJOIN as tokens.
 *
 *  Each condition keeps about half of the joined rows,
 *  so a condition the worker evaluates wrongly changes the count.
 *  Every function reads columns of both tables:
 *  a function of only one table's columns does not crash a build without the fix.
 *
 *  Coverage:
 *    Case 1 - 4: the hash table fits in memory and only the probe runs in parallel
 *      Case 1:  ELT in the WHERE clause (the reported query)
 *      Case 2:  REGEXP_LIKE
 *      Case 3:  RLIKE (a predicate, not a function)
 *      Case 4:  ELT in the ON clause of a LEFT OUTER JOIN
 *    Case 5 - 7: a small max_hash_list_scan_size splits the join into partitions that run in parallel
 *      Case 5:  ELT in the WHERE clause
 *      Case 6:  REGEXP_LIKE in the WHERE clause
 *      Case 7:  REGEXP_LIKE in the ON clause of a LEFT OUTER JOIN
 */

drop table if exists ta;

-- ca is unique, so the equi-join pairs each row with itself
create table ta (ca int, cb varchar (64));
insert into ta
select rownum, md5 (rownum)
from db_class a, db_class b, db_class c
limit 20000;
update statistics on ta with fullscan;

set trace on;


evaluate 'Case 1: ELT in the WHERE clause, parallel probe; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), sum (b.ca)
from ta a, ta b
where a.ca = b.ca
  and elt (b.ca % 2 + 1, a.cb, null) is not null;
show trace;
-- compare with the parallel query above: serial hash join
select /*+ recompile use_hash no_parallel_hash_join */ count (*), sum (b.ca)
from ta a, ta b
where a.ca = b.ca
  and elt (b.ca % 2 + 1, a.cb, null) is not null;


evaluate 'Case 2: REGEXP_LIKE, parallel probe; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), sum (b.ca)
from ta a, ta b
where a.ca = b.ca
  and regexp_like (a.cb || b.cb, '^[0-7]') = 1;
show trace;
-- compare with the parallel query above: serial hash join
select /*+ recompile use_hash no_parallel_hash_join */ count (*), sum (b.ca)
from ta a, ta b
where a.ca = b.ca
  and regexp_like (a.cb || b.cb, '^[0-7]') = 1;


evaluate 'Case 3: RLIKE, parallel probe; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), sum (b.ca)
from ta a, ta b
where a.ca = b.ca
  and a.cb || b.cb rlike '^[0-7]';
show trace;
-- compare with the parallel query above: serial hash join
select /*+ recompile use_hash no_parallel_hash_join */ count (*), sum (b.ca)
from ta a, ta b
where a.ca = b.ca
  and a.cb || b.cb rlike '^[0-7]';


evaluate 'Case 4: ELT in the ON clause of a LEFT OUTER JOIN, parallel probe; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), count (b.ca), sum (b.ca)
from ta a
  left outer join ta b on a.ca = b.ca
    and elt (b.ca % 2 + 1, a.cb, null) is not null;
show trace;
-- compare with the parallel query above: serial hash join
select /*+ recompile use_hash no_parallel_hash_join */ count (*), count (b.ca), sum (b.ca)
from ta a
  left outer join ta b on a.ca = b.ca
    and elt (b.ca % 2 + 1, a.cb, null) is not null;


set system parameters 'max_hash_list_scan_size=64k';


evaluate 'Case 5: ELT in the WHERE clause, parallel partitions; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), sum (b.ca)
from ta a, ta b
where a.ca = b.ca
  and elt (b.ca % 2 + 1, a.cb, null) is not null;
show trace;
-- compare with the parallel query above: serial hash join
select /*+ recompile use_hash no_parallel_hash_join */ count (*), sum (b.ca)
from ta a, ta b
where a.ca = b.ca
  and elt (b.ca % 2 + 1, a.cb, null) is not null;


evaluate 'Case 6: REGEXP_LIKE in the WHERE clause, parallel partitions; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), sum (b.ca)
from ta a, ta b
where a.ca = b.ca
  and regexp_like (a.cb || b.cb, '^[0-7]') = 1;
show trace;
-- compare with the parallel query above: serial hash join
select /*+ recompile use_hash no_parallel_hash_join */ count (*), sum (b.ca)
from ta a, ta b
where a.ca = b.ca
  and regexp_like (a.cb || b.cb, '^[0-7]') = 1;


evaluate 'Case 7: REGEXP_LIKE in the ON clause of a LEFT OUTER JOIN, parallel partitions; result = no_parallel_hash_join';
select /*+ recompile use_hash */ count (*), count (b.ca), sum (b.ca)
from ta a
  left outer join ta b on a.ca = b.ca
    and regexp_like (a.cb || b.cb, '^[0-7]') = 1;
show trace;
-- no show trace follows the last query, so trace goes off before it
set trace off;
-- compare with the parallel query above: serial hash join
select /*+ recompile use_hash no_parallel_hash_join */ count (*), count (b.ca), sum (b.ca)
from ta a
  left outer join ta b on a.ca = b.ca
    and regexp_like (a.cb || b.cb, '^[0-7]') = 1;


set system parameters 'max_hash_list_scan_size=default';

drop table ta;
