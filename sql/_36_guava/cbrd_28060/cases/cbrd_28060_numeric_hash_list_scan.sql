/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A hash list scan hashes a pair of exact number keys (SMALLINT, INT, BIGINT, NUMERIC) as they are, whatever their
 *  precision and scale and whether they are fixed or float, since they hash by value. Before the change, a pair with a
 *  float NUMERIC side was hashed as DOUBLE, which rounds a value whose coefficient passes 2^53, so the scan missed
 *  pairs of equal values, and CONNECT BY turned the hash list scan off for such a NUMERIC PRIOR key and ran the single
 *  table plan. Each case counts the rows of the query and of its NO_HASH_LIST_SCAN twin, and prints PASS when both
 *  equal the expected count.
 *
 *  Cases 10 to 14 hold edge values that only NUMERIC has: a negative scale, two float NUMERIC keys of up to 32 integer
 *  digits, and a host variable that makes a coefficient pass 2^53. They follow the hash list scan and CONNECT BY cases
 *  that every exact number pair shares.
 *
 *  Coverage:
 *    Case 1:  NUMERIC(20,5) and a float NUMERIC of scale 39 (cb / 1) - hash list scan finds every pair
 *    Case 2:  INT and a float NUMERIC ((cb - 0.25) / 1) - hash list scan finds every pair
 *    Case 3:  NUMERIC(10,2) and NUMERIC(20,5) - hash list scan finds every pair
 *    Case 4:  NUMERIC(20,0) and NUMERIC(30,10), past 38 digits together - hash list scan finds every pair
 *    Case 5:  trace - Cases 1 to 4 run as a hash list scan (SCAN (hash temp(m), ...))
 *    Case 6:  float NUMERIC PRIOR key (prior (id / 1) = pid) - CONNECT BY by a hash list scan returns 5 rows
 *    Case 7:  prior NUMERIC(20,5) = NUMERIC(30,10), keys of 15 integer digits - CONNECT BY by a hash list scan returns
 *             4 rows
 *    Case 8:  prior BIGINT = NUMERIC(38,20) - CONNECT BY by a hash list scan returns 4 rows
 *    Case 9:  trace - Cases 6 to 8 run as a hash list scan
 *    Case 10: NUMERIC(38,0) and a float NUMERIC of scale -5 (a NUMERIC(38,-5) cast to NUMERIC) - hash join and hash
 *             list scan find the pair
 *    Case 11: NUMERIC(38,-5) and a float NUMERIC (a NUMERIC(20,0) cast to NUMERIC) - hash list scan finds every pair
 *    Case 12: two float NUMERIC keys (cb * 1 and cc + 0), values of up to 32 integer digits - hash list scan finds
 *             every pair
 *    Case 13: NUMERIC(18,2) and INT plus a host variable, a coefficient past 2^53 - hash list scan finds the pair
 *    Case 14: trace - Cases 11 to 13 run as a hash list scan
 */

set trace on;

-- Each join reads a derived table with NO_MERGE, the build side of the hash list scan. The joins add parallel(0) so
-- that the trace holds no parallel workers lines, which depend on the number of cores of the server

drop table if exists
  t_numeric_a, t_numeric_b, t_tree_same_scale, t_tree_wider_scale, t_tree_bigint, t_numeric_int,
  t_numeric_negative_scale, t_numeric_negative_scale_rows, t_numeric_digits, t_numeric_host_variable;
create table t_numeric_a (ca int, cb numeric(20,5), cc numeric(10,2), cd numeric(20,0));

-- t_numeric_a, rownum r = 1 to 3000
-- ca   | cb         | cc      | cd
-- -----+------------+---------+------------------
-- 1    | 1.25000    | 1.25    | 1000000000000
-- 2    | 2.25000    | 2.25    | 2000000000000
-- 3000 | 3000.25000 | 3000.25 | 3000000000000000
insert into t_numeric_a select rownum, rownum + 0.25, rownum + 0.25, rownum * 1000000000000 from db_root connect by level <= 3000;

create table t_numeric_b (ca int, cb numeric(20,5), cc numeric(30,10));

-- t_numeric_b, rownum r = 1 to 3000
-- ca   | cb         | cc
-- -----+------------+-----------------------------
-- 1    | 1.25000    | 1000000000000.0000000000
-- 2    | 2.25000    | 2000000000000.0000000000
-- 3000 | 3000.25000 | 3000000000000000.0000000000
insert into t_numeric_b select rownum, rownum + 0.25, rownum * 1000000000000 from db_root connect by level <= 3000;

create table t_tree_same_scale (id numeric(20,5), pid numeric(20,5), ca int);

-- id                    | pid                   | ca | note
-- ----------------------+-----------------------+----+---------------
-- 1.25                  | null                  | 1  | root
-- 2.5                   | 1.25                  | 2  | child of ca = 1
-- 3.75                  | 2.5                   | 3  | child of ca = 2
-- 123456789012345.12345 | 3.75                  | 4  | child of ca = 3
-- 5                     | 123456789012345.12345 | 5  | child of ca = 4
insert into t_tree_same_scale values
  (1.25, null, 1),
  (2.5, 1.25, 2),
  (3.75, 2.5, 3),
  (123456789012345.12345, 3.75, 4),
  (5, 123456789012345.12345, 5);
create table t_tree_wider_scale (id numeric(20,5), pid numeric(30,10), ca int);

-- id                    | pid                   | ca | note
-- ----------------------+-----------------------+----+---------------
-- 123456789012345.12345 | null                  | 1  | root
-- 987654321098765.4321  | 123456789012345.12345 | 2  | child of ca = 1
-- 1.5                   | 987654321098765.4321  | 3  | child of ca = 2
-- 2                     | 1.5                   | 4  | child of ca = 3
insert into t_tree_wider_scale values
  (123456789012345.12345, null, 1),
  (987654321098765.4321, 123456789012345.12345, 2),
  (1.5, 987654321098765.4321, 3),
  (2, 1.5, 4);
create table t_tree_bigint (id bigint, pid numeric(38,20), ca int);

-- id                 | pid                | ca | note
-- -------------------+--------------------+----+---------------
-- 123456789012345678 | null               | 1  | root
-- 2                  | 123456789012345678 | 2  | child of ca = 1
-- 999999999999999999 | 2                  | 3  | child of ca = 2
-- 5                  | 999999999999999999 | 4  | child of ca = 3
insert into t_tree_bigint values
  (123456789012345678, null, 1),
  (2, 123456789012345678, 2),
  (999999999999999999, 2, 3),
  (5, 999999999999999999, 4);
create table t_numeric_int (ca numeric(38,0));
insert into t_numeric_int values (1500000);
create table t_numeric_negative_scale (ca numeric(38,-5));
insert into t_numeric_negative_scale values (1500000);
create table t_numeric_negative_scale_rows (ca int, cb numeric(38,-5), cc numeric(20,0));

-- ca | cb      | cc
-- ---+---------+---------
-- 1  | 1500000 | 1500000
-- 2  | 2500000 | 2500000
-- 3  | 100000  | 100000
-- 4  | 0       | 0
-- 5  | -300000 | -300000
insert into t_numeric_negative_scale_rows values
  (1, 1500000, 1500000),
  (2, 2500000, 2500000),
  (3, 100000, 100000),
  (4, 0, 0),
  (5, -300000, -300000);
create table t_numeric_digits (ca int, cb numeric(38,2), cc numeric(38,6));

-- ca | cb                                  | cc
-- ---+-------------------------------------+-----------------------------------------
-- 1  | 753980177740970.00                  | 753980177740970.000000
-- 2  | 4381872152352264.00                 | 4381872152352264.000000
-- 3  | 1000000000000002.00                 | 1000000000000002.000000
-- 4  | 12345678901234567890123456789012.34 | 12345678901234567890123456789012.340000
-- 5  | -9007199254740993.50                | -9007199254740993.500000
-- 6  | 0.00                                | 0.000000
-- 7  | 1.23                                | 1.230000
-- 8  | 12.30                               | 12.300000
-- 9  | 123.00                              | 123.000000
-- 10 | -123.00                             | -123.000000
-- 11 | 100.00                              | 100.000000
-- 12 | 99999999999999999.99                | 99999999999999999.990000
insert into t_numeric_digits values
  (1, 753980177740970.00, 753980177740970.000000),
  (2, 4381872152352264.00, 4381872152352264.000000),
  (3, 1000000000000002.00, 1000000000000002.000000),
  (4, 12345678901234567890123456789012.34, 12345678901234567890123456789012.340000),
  (5, -9007199254740993.50, -9007199254740993.500000),
  (6, 0.00, 0.000000),
  (7, 1.23, 1.230000),
  (8, 12.30, 12.300000),
  (9, 123.00, 123.000000),
  (10, -123.00, -123.000000),
  (11, 100.00, 100.000000),
  (12, 99999999999999999.99, 99999999999999999.990000);
create table t_numeric_host_variable (ca int, cb numeric(18,2));

-- ca | cb
-- ---+--------------------
-- 1  | 753980177740970.00
-- 2  | 5.00
insert into t_numeric_host_variable values (1, 753980177740970.00), (2, 5.00);

evaluate 'Case 1: NUMERIC(20,5) and a float NUMERIC of scale 39 (cb / 1) - hash list scan finds every pair';
select case when a.c = b.c and a.c = 3000 then 'PASS' else 'FAIL' end res
from
  (select /*+ ordered parallel(0) */ count(*) c
   from t_numeric_a x, (select /*+ NO_MERGE */ ca, cb / 1 as cf from t_numeric_b where ca >= 1) y
   where x.cb = y.cf) a,
  (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ count(*) c
   from t_numeric_a x, (select /*+ NO_MERGE */ ca, cb / 1 as cf from t_numeric_b where ca >= 1) y
   where x.cb = y.cf) b;

evaluate 'Case 2: INT and a float NUMERIC ((cb - 0.25) / 1) - hash list scan finds every pair';
select case when a.c = b.c and a.c = 3000 then 'PASS' else 'FAIL' end res
from
  (select /*+ ordered parallel(0) */ count(*) c
   from t_numeric_a x, (select /*+ NO_MERGE */ ca, (cb - 0.25) / 1 as cf from t_numeric_b where ca >= 1) y
   where x.ca = y.cf) a,
  (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ count(*) c
   from t_numeric_a x, (select /*+ NO_MERGE */ ca, (cb - 0.25) / 1 as cf from t_numeric_b where ca >= 1) y
   where x.ca = y.cf) b;

evaluate 'Case 3: NUMERIC(10,2) and NUMERIC(20,5) - hash list scan finds every pair';
select case when a.c = b.c and a.c = 3000 then 'PASS' else 'FAIL' end res
from
  (select /*+ ordered parallel(0) */ count(*) c
   from t_numeric_a x, (select /*+ NO_MERGE */ ca, cb from t_numeric_b where ca >= 1) y
   where x.cc = y.cb) a,
  (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ count(*) c
   from t_numeric_a x, (select /*+ NO_MERGE */ ca, cb from t_numeric_b where ca >= 1) y
   where x.cc = y.cb) b;

evaluate 'Case 4: NUMERIC(20,0) and NUMERIC(30,10), past 38 digits together - hash list scan finds every pair';
select case when a.c = b.c and a.c = 3000 then 'PASS' else 'FAIL' end res
from
  (select /*+ ordered parallel(0) */ count(*) c
   from t_numeric_a x, (select /*+ NO_MERGE */ ca, cc from t_numeric_b where ca >= 1) y
   where x.cd = y.cc) a,
  (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ count(*) c
   from t_numeric_a x, (select /*+ NO_MERGE */ ca, cc from t_numeric_b where ca >= 1) y
   where x.cd = y.cc) b;

evaluate 'Case 5: trace - Cases 1 to 4 run as a hash list scan (SCAN (hash temp(m), ...))';
select /*+ ordered parallel(0) */ count(*)
from t_numeric_a x, (select /*+ NO_MERGE */ ca, cb / 1 as cf from t_numeric_b where ca >= 1) y
where x.cb = y.cf;
show trace;

select /*+ ordered parallel(0) */ count(*)
from t_numeric_a x, (select /*+ NO_MERGE */ ca, (cb - 0.25) / 1 as cf from t_numeric_b where ca >= 1) y
where x.ca = y.cf;
show trace;

select /*+ ordered parallel(0) */ count(*)
from t_numeric_a x, (select /*+ NO_MERGE */ ca, cb from t_numeric_b where ca >= 1) y
where x.cc = y.cb;
show trace;

select /*+ ordered parallel(0) */ count(*)
from t_numeric_a x, (select /*+ NO_MERGE */ ca, cc from t_numeric_b where ca >= 1) y
where x.cd = y.cc;
show trace;

evaluate 'Case 6: float NUMERIC PRIOR key (prior (id / 1) = pid) - CONNECT BY by a hash list scan returns 5 rows';
select case when a.c = b.c and a.s = b.s and a.c = 5 and a.s = 165 then 'PASS' else 'FAIL' end res,
       a.c cnt
from
  (select count(*) c, sum(t.ca * 10 + t.lv) s
   from (select ca, level lv from t_tree_same_scale start with pid is null connect by prior (id / 1) = pid) t) a,
  (select count(*) c, sum(t.ca * 10 + t.lv) s
   from (select /*+ NO_HASH_LIST_SCAN */ ca, level lv from t_tree_same_scale start with pid is null connect by prior (id / 1) = pid) t) b;

evaluate 'Case 7: prior NUMERIC(20,5) = NUMERIC(30,10), keys of 15 integer digits - CONNECT BY by a hash list scan returns 4 rows';
select case when a.c = b.c and a.s = b.s and a.c = 4 and a.s = 110 then 'PASS' else 'FAIL' end res,
       a.c cnt
from
  (select count(*) c, sum(t.ca * 10 + t.lv) s
   from (select ca, level lv from t_tree_wider_scale start with pid is null connect by prior id = pid) t) a,
  (select count(*) c, sum(t.ca * 10 + t.lv) s
   from (select /*+ NO_HASH_LIST_SCAN */ ca, level lv from t_tree_wider_scale start with pid is null connect by prior id = pid) t) b;

evaluate 'Case 8: prior BIGINT = NUMERIC(38,20) - CONNECT BY by a hash list scan returns 4 rows';
select case when a.c = b.c and a.s = b.s and a.c = 4 and a.s = 110 then 'PASS' else 'FAIL' end res,
       a.c cnt
from
  (select count(*) c, sum(t.ca * 10 + t.lv) s
   from (select ca, level lv from t_tree_bigint start with pid is null connect by prior id = pid) t) a,
  (select count(*) c, sum(t.ca * 10 + t.lv) s
   from (select /*+ NO_HASH_LIST_SCAN */ ca, level lv from t_tree_bigint start with pid is null connect by prior id = pid) t) b;

evaluate 'Case 9: trace - Cases 6 to 8 run as a hash list scan';
select ca, level lv from t_tree_same_scale start with pid is null connect by prior (id / 1) = pid order siblings by ca;
show trace;

select ca, level lv from t_tree_wider_scale start with pid is null connect by prior id = pid order siblings by ca;
show trace;

select ca, level lv from t_tree_bigint start with pid is null connect by prior id = pid order siblings by ca;
show trace;

evaluate 'Case 10: NUMERIC(38,0) and a float NUMERIC of scale -5 (a NUMERIC(38,-5) cast to NUMERIC) - hash join and hash list scan find the pair';
select case when a.c = 1 and b.c = 1 and c.c = 1 then 'PASS' else 'FAIL' end res
from
  (select /*+ ordered USE_HASH */ count(*) c
   from t_numeric_int x, (select /*+ NO_MERGE */ cast (ca as numeric) c from t_numeric_negative_scale) y
   where x.ca = y.c) a,
  (select /*+ ordered parallel(0) */ count(*) c
   from t_numeric_int x, (select /*+ NO_MERGE */ cast (ca as numeric) c from t_numeric_negative_scale where ca > 0) y
   where x.ca = y.c) b,
  (select /*+ ordered USE_NL NO_HASH_LIST_SCAN */ count(*) c
   from t_numeric_int x, (select /*+ NO_MERGE */ cast (ca as numeric) c from t_numeric_negative_scale where ca > 0) y
   where x.ca = y.c) c;

evaluate 'Case 11: NUMERIC(38,-5) and a float NUMERIC (a NUMERIC(20,0) cast to NUMERIC) - hash list scan finds every pair';
select case when a.c = b.c and a.c = 5 then 'PASS' else 'FAIL' end res
from
  (select /*+ ordered parallel(0) */ count(*) c
   from t_numeric_negative_scale_rows x,
     (select /*+ NO_MERGE */ ca, cast (cc as numeric) as cf from t_numeric_negative_scale_rows where ca >= 1) y
   where x.cb = y.cf) a,
  (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ count(*) c
   from t_numeric_negative_scale_rows x,
     (select /*+ NO_MERGE */ ca, cast (cc as numeric) as cf from t_numeric_negative_scale_rows where ca >= 1) y
   where x.cb = y.cf) b;

evaluate 'Case 12: two float NUMERIC keys (cb * 1 and cc + 0), values of up to 32 integer digits - hash list scan finds every pair';
select case when a.c = b.c and a.c = 12 then 'PASS' else 'FAIL' end res
from
  (select /*+ ordered parallel(0) */ count(*) c
   from t_numeric_digits x, (select /*+ NO_MERGE */ ca, cc + 0 as cf from t_numeric_digits where ca >= 1) y
   where x.cb * 1 = y.cf) a,
  (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ count(*) c
   from t_numeric_digits x, (select /*+ NO_MERGE */ ca, cc + 0 as cf from t_numeric_digits where ca >= 1) y
   where x.cb * 1 = y.cf) b;

evaluate 'Case 13: NUMERIC(18,2) and INT plus a host variable, a coefficient past 2^53 - hash list scan finds the pair';
-- 753980177740970 is exact in DOUBLE; its coefficient at scale 2 (the value x 10^2) passes 2^53
prepare st_cmp from 'select case when a.c = b.c and a.c = 1 then ''PASS'' else ''FAIL'' end res from (select /*+ ordered parallel(0) */ count(*) c from t_numeric_host_variable x, (select /*+ NO_MERGE */ ca, ca + ? as cf from t_numeric_host_variable where ca >= 1) y where x.cb = y.cf) a, (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ count(*) c from t_numeric_host_variable x, (select /*+ NO_MERGE */ ca, ca + ? as cf from t_numeric_host_variable where ca >= 1) y where x.cb = y.cf) b';
execute st_cmp using 753980177740969.0, 753980177740969.0;
deallocate prepare st_cmp;

evaluate 'Case 14: trace - Cases 11 to 13 run as a hash list scan';
select /*+ ordered parallel(0) */ count(*)
from t_numeric_negative_scale_rows x,
  (select /*+ NO_MERGE */ ca, cast (cc as numeric) as cf from t_numeric_negative_scale_rows where ca >= 1) y
where x.cb = y.cf;
show trace;

select /*+ ordered parallel(0) */ count(*)
from t_numeric_digits x, (select /*+ NO_MERGE */ ca, cc + 0 as cf from t_numeric_digits where ca >= 1) y
where x.cb * 1 = y.cf;
show trace;

prepare st_hash from 'select /*+ ordered parallel(0) */ count(*) from t_numeric_host_variable x, (select /*+ NO_MERGE */ ca, ca + ? as cf from t_numeric_host_variable where ca >= 1) y where x.cb = y.cf';
execute st_hash using 753980177740969.0;
show trace;
deallocate prepare st_hash;

-- cleanup
drop table if exists
  t_numeric_a, t_numeric_b, t_tree_same_scale, t_tree_wider_scale, t_tree_bigint, t_numeric_int,
  t_numeric_negative_scale, t_numeric_negative_scale_rows, t_numeric_digits, t_numeric_host_variable;

set trace off;
