/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A hash join hashes a pair of keys of one type as they are, whatever their precision. Before the change, a BIT(8) key
 *  against a BIT(16) key was converted to BIT(16), which pads the bits 01 to 0100, so the hash join returned a pair
 *  that the comparison tells apart: BIT values of two sizes never compare equal. Each case counts the rows of the hash
 *  join and of its nested loop join twin, and prints PASS when both equal the expected count.
 *
 *  Coverage:
 *    Case 1:  BIT(8) and BIT(16) - hash join finds no pair, as the nested loop join
 *    Case 2:  BIT VARYING(8) and BIT VARYING(16) - hash join finds the pair of equal bits, as the nested loop join
 *    Case 3:  INT and BIT(8) with INT and BIT(16) - hash join of two keys finds no pair, as the nested loop join
 *    Case 4:  trace - Cases 1 to 3 run as a hash join (HASHJOIN)
 */

set trace on;

-- The joins add parallel(0) so that the trace holds no parallel workers lines, which depend on the number of cores of
-- the server

drop table if exists t_bit_short, t_bit_long, t_bit_varying_short, t_bit_varying_long;
create table t_bit_short (ca int, cb bit(8));
create table t_bit_long (ca int, cb bit(16));
create table t_bit_varying_short (cb bit varying(8));
create table t_bit_varying_long (cb bit varying(16));

-- t_bit_short: each value of t_bit_long below is the same byte padded to 16 bits
-- ca | cb
-- ---+-------
-- 1  | X'01'
-- 2  | X'02'
-- 3  | X'00'
insert into t_bit_short values (1, X'01'), (2, X'02'), (3, X'00');

-- t_bit_long
-- ca | cb
-- ---+---------
-- 1  | X'0100'
-- 2  | X'0200'
-- 3  | X'0000'
insert into t_bit_long values (1, X'0100'), (2, X'0200'), (3, X'0000');

-- t_bit_varying_short
-- cb
-- -------
-- X'01'
-- X'02'
insert into t_bit_varying_short values (X'01'), (X'02');

-- t_bit_varying_long: X'01' equals X'01' of t_bit_varying_short, X'0100' has another length
-- cb
-- ---------
-- X'01'
-- X'0100'
insert into t_bit_varying_long values (X'01'), (X'0100');

evaluate 'Case 1: BIT(8) and BIT(16) - hash join finds no pair, as the nested loop join';
select case when a.c = b.c and a.c = 0 then 'PASS' else 'FAIL' end res
from
  (select /*+ ordered USE_HASH parallel(0) */ count(*) c from t_bit_short x, t_bit_long y where x.cb = y.cb) a,
  (select /*+ ordered USE_NL parallel(0) */ count(*) c from t_bit_short x, t_bit_long y where x.cb = y.cb) b;

evaluate 'Case 2: BIT VARYING(8) and BIT VARYING(16) - hash join finds the pair of equal bits, as the nested loop join';
select case when a.c = b.c and a.c = 1 then 'PASS' else 'FAIL' end res
from
  (select /*+ ordered USE_HASH parallel(0) */ count(*) c from t_bit_varying_short x, t_bit_varying_long y where x.cb = y.cb) a,
  (select /*+ ordered USE_NL parallel(0) */ count(*) c from t_bit_varying_short x, t_bit_varying_long y where x.cb = y.cb) b;

evaluate 'Case 3: INT and BIT(8) with INT and BIT(16) - hash join of two keys finds no pair, as the nested loop join';
select case when a.c = b.c and a.c = 0 then 'PASS' else 'FAIL' end res
from
  (select /*+ ordered USE_HASH parallel(0) */ count(*) c from t_bit_short x, t_bit_long y
   where x.ca = y.ca and x.cb = y.cb) a,
  (select /*+ ordered USE_NL parallel(0) */ count(*) c from t_bit_short x, t_bit_long y
   where x.ca = y.ca and x.cb = y.cb) b;

evaluate 'Case 4: trace - Cases 1 to 3 run as a hash join (HASHJOIN)';
select /*+ recompile ordered USE_HASH parallel(0) */ count(*) from t_bit_short x, t_bit_long y where x.cb = y.cb;
show trace;

select /*+ recompile ordered USE_HASH parallel(0) */ count(*) from t_bit_varying_short x, t_bit_varying_long y where x.cb = y.cb;
show trace;

select /*+ recompile ordered USE_HASH parallel(0) */ count(*) from t_bit_short x, t_bit_long y where x.ca = y.ca and x.cb = y.cb;
show trace;

-- cleanup
drop table if exists t_bit_short, t_bit_long, t_bit_varying_short, t_bit_varying_long;

set trace off;
