/**
 *  This test case verifies CBRD-26900: Evaluate eligible after-join predicates in the hash join probe loop
 *
 *  The parallel probe and the parallel hash join evaluate the residual condition of a matched pair in each worker. Each
 *  case runs one join as a hash join and as a nested loop join with the same statement apart from the hint, and the two
 *  results must match. CTP prints the digits of a trace as a question mark, so the trace of each hash join case is
 *  checked by the PARALLEL lines under HASHJOIN, not by their digits. The file is split from cbrd_26900.sql because its
 *  data must be large enough for the parallel paths.
 *
 *  Coverage:
 *    Case 1:  Inner join with a residual condition, parallel probe
 *    Case 2:  Inner join with a residual condition, parallel hash join
 *    Case 3:  Outer join with an after-join condition, parallel probe
 *    Case 4:  Outer join with an after-join condition, parallel hash join
 */

-- ta: 100,000 rows in 193 heap pages and tb: 50,000 rows in 97 heap pages, about 6 and 3 times the parallel heap
-- scan threshold of test_mode (32 pages), so that both scans run in parallel
drop table if exists ta, tb;
create table ta (ca bigint primary key, cb int);
create table tb (ca bigint primary key, cb int);
insert into ta
  with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 1000)
  select rn, mod(rn * 7, 1000) from (select rownum as rn from cte x, cte y limit 100000);
insert into tb select ca, mod(ca * 13, 1000) from ta where mod(ca, 2) = 0;

set trace on;

evaluate 'Case 1: Inner join with a residual condition, parallel probe';

select /*+ ordered use_hash parallel(4) */
       count(*) as cnt, sum(ta.ca) as total
  from ta, tb
 where ta.ca = tb.ca
   and ta.cb < tb.cb;

show trace;

select /*+ ordered use_nl */
       count(*) as cnt, sum(ta.ca) as total
  from ta, tb
 where ta.ca = tb.ca
   and ta.cb < tb.cb;

-- a hash list size of 256k, far below the default of 8M and the size of tb, makes the hash join partition its input,
-- which runs it as a parallel hash join
set system parameters 'max_hash_list_scan_size=256k';

evaluate 'Case 2: Inner join with a residual condition, parallel hash join';

select /*+ use_hash parallel(4) */
       count(*) as cnt, sum(ta.ca) as total
  from ta, tb
 where ta.ca = tb.ca
   and ta.cb < tb.cb;

show trace;

select /*+ use_nl */
       count(*) as cnt, sum(ta.ca) as total
  from ta, tb
 where ta.ca = tb.ca
   and ta.cb < tb.cb;

set system parameters 'max_hash_list_scan_size=default';

evaluate 'Case 3: Outer join with an after-join condition, parallel probe';

select /*+ ordered use_hash parallel(4) */
       count(*) as cnt, sum(ta.ca) as total, count(tb.ca) as matched
  from ta left join tb on ta.ca = tb.ca
 where tb.cb is null
    or ta.cb < tb.cb;

show trace;

select /*+ ordered use_nl */
       count(*) as cnt, sum(ta.ca) as total, count(tb.ca) as matched
  from ta left join tb on ta.ca = tb.ca
 where tb.cb is null
    or ta.cb < tb.cb;

set system parameters 'max_hash_list_scan_size=256k';

evaluate 'Case 4: Outer join with an after-join condition, parallel hash join';

select /*+ use_hash parallel(4) */
       count(*) as cnt, sum(ta.ca) as total, count(tb.ca) as matched
  from ta left join tb on ta.ca = tb.ca
 where tb.cb is null
    or ta.cb < tb.cb;

show trace;

select /*+ use_nl */
       count(*) as cnt, sum(ta.ca) as total, count(tb.ca) as matched
  from ta left join tb on ta.ca = tb.ca
 where tb.cb is null
    or ta.cb < tb.cb;

set system parameters 'max_hash_list_scan_size=default';
set trace off;
drop table if exists ta, tb;
