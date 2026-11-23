/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A hash join hashes a pair of keys of one type as they are, whatever their precision. Before the change,
 *  a BIT(8) key against a BIT(16) key was converted to BIT(16), which pads the bits 01 to 0100, so the hash
 *  join returned a pair that the comparison tells apart: BIT values of two sizes never compare equal.
 *  Each case counts the rows of the hash join and of the nested loop join of the same query, and prints
 *  PASS when both equal the expected count.
 *
 *  Coverage:
 *    Case 1: BIT(8) against BIT(16): no pair, as the nested loop join
 *    Case 2: VARBIT(8) against VARBIT(16): the pair of equal bits, as the nested loop join
 *    Case 3: an INT key and a BIT(8) against BIT(16) key: no pair, as the nested loop join
 *    Case 4: trace: Cases 1 to 3 run as a hash join (HASHJOIN)
 */

drop table if exists ta, tb, tc, td;

-- every join has parallel(0) to run serially, so that the trace lines do not depend on the server
create table ta (ca int, cb bit(8));
insert into ta values (1, X'01'), (2, X'02'), (3, X'00');
create table tb (ca int, cb bit(16));
insert into tb values (1, X'0100'), (2, X'0200'), (3, X'0000');
create table tc (cb bit varying(8));
insert into tc values (X'01'), (X'02');
create table td (cb bit varying(16));
insert into td values (X'01'), (X'0100');


evaluate 'Case 1: BIT(8) against BIT(16): no pair, as the nested loop join';
select case when a.c = b.c and a.c = 0 then 'PASS' else 'FAIL' end res
from (
  select /*+ ordered USE_HASH parallel(0) */ count(*) c
  from ta x, tb y
  where x.cb = y.cb
) a, (
  select /*+ ordered USE_NL parallel(0) */ count(*) c
  from ta x, tb y
  where x.cb = y.cb
) b;


evaluate 'Case 2: VARBIT(8) against VARBIT(16): the pair of equal bits, as the nested loop join';
select case when a.c = b.c and a.c = 1 then 'PASS' else 'FAIL' end res
from (
  select /*+ ordered USE_HASH parallel(0) */ count(*) c
  from tc x, td y
  where x.cb = y.cb
) a, (
  select /*+ ordered USE_NL parallel(0) */ count(*) c
  from tc x, td y
  where x.cb = y.cb
) b;


evaluate 'Case 3: an INT key and a BIT(8) against BIT(16) key: no pair, as the nested loop join';
select case when a.c = b.c and a.c = 0 then 'PASS' else 'FAIL' end res
from (
  select /*+ ordered USE_HASH parallel(0) */ count(*) c
  from ta x, tb y
  where x.ca = y.ca and x.cb = y.cb
) a, (
  select /*+ ordered USE_NL parallel(0) */ count(*) c
  from ta x, tb y
  where x.ca = y.ca and x.cb = y.cb
) b;


evaluate 'Case 4: trace: Cases 1 to 3 run as a hash join (HASHJOIN)';
set trace on;
select /*+ recompile ordered USE_HASH parallel(0) */ count(*)
from ta x, tb y
where x.cb = y.cb;
show trace;
select /*+ recompile ordered USE_HASH parallel(0) */ count(*)
from tc x, td y
where x.cb = y.cb;
show trace;
select /*+ recompile ordered USE_HASH parallel(0) */ count(*)
from ta x, tb y
where x.ca = y.ca and x.cb = y.cb;
show trace;
set trace off;


drop table ta, tb, tc, td;
