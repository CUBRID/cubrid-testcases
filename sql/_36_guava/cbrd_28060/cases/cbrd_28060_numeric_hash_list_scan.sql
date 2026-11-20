/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A hash list scan hashes a pair of exact number keys (SMALLINT, INT, BIGINT, NUMERIC) as they are,
 *  whatever their precision and scale and whether they are fixed or float, since they hash by value.
 *  Before the change, a pair with a float NUMERIC side was hashed as DOUBLE, which rounds a value whose
 *  coefficient passes 2^53, so the scan missed pairs of equal values, and CONNECT BY turned the hash list
 *  scan off for such a NUMERIC PRIOR key and ran the single table plan. Each case counts the rows of its
 *  query, compares them with the same query with NO_HASH_LIST_SCAN, and prints PASS when both equal the
 *  expected values.
 *
 *  Coverage:
 *    Case 1:  NUMERIC(20,5) against a float NUMERIC of scale 39 (cn / 1): the hash list scan finds every pair
 *    Case 2:  INT against a float NUMERIC ((cn - 0.25) / 1): the hash list scan finds every pair
 *    Case 3:  NUMERIC(10,2) against NUMERIC(20,5): the hash list scan finds every pair
 *    Case 4:  NUMERIC(20,0) against NUMERIC(30,10), past 38 digits together: the hash list scan finds every pair
 *    Case 5:  trace: Cases 1 to 4 run as a hash list scan (SCAN (hash temp(m), ...))
 *    Case 6:  CONNECT BY with a float NUMERIC PRIOR key (prior (id / 1) = pid): 5 rows
 *    Case 7:  CONNECT BY with prior NUMERIC(20,5) = NUMERIC(30,10) and keys of 15 integer digits: 4 rows
 *    Case 8:  CONNECT BY with prior BIGINT = NUMERIC(38,20): 4 rows
 *    Case 9:  trace: Cases 6 to 8 run as a hash list scan
 *    Case 10: NUMERIC(38,0) against a float NUMERIC of scale -5 (a NUMERIC(38,-5) cast to NUMERIC): the hash join
 *             and the hash list scan find the pair
 */

drop table if exists hl_na, hl_nb, hl_cf, hl_cl, hl_cb, hl_nx, hl_ns;

-- each join reads a derived table with NO_MERGE, the build side of the hash list scan, and parallel(0)
-- keeps the join serial so that the trace lines do not depend on the server
create table hl_na (ca int, cn numeric(20,5), cs numeric(10,2), cz numeric(20,0));
insert into hl_na select rownum, rownum + 0.25, rownum + 0.25, rownum * 1000000000000 from db_root connect by level <= 3000;
create table hl_nb (ca int, cn numeric(20,5), cw numeric(30,10));
insert into hl_nb select rownum, rownum + 0.25, rownum * 1000000000000 from db_root connect by level <= 3000;

create table hl_cf (id numeric(20,5), pid numeric(20,5), n int);
insert into hl_cf values (1.25, null, 1), (2.5, 1.25, 2), (3.75, 2.5, 3), (123456789012345.12345, 3.75, 4), (5, 123456789012345.12345, 5);
create table hl_cl (id numeric(20,5), pid numeric(30,10), n int);
insert into hl_cl values (123456789012345.12345, null, 1), (987654321098765.4321, 123456789012345.12345, 2), (1.5, 987654321098765.4321, 3), (2, 1.5, 4);
create table hl_cb (id bigint, pid numeric(38,20), n int);
insert into hl_cb values (123456789012345678, null, 1), (2, 123456789012345678, 2), (999999999999999999, 2, 3), (5, 999999999999999999, 4);
create table hl_nx (x numeric(38,0));
insert into hl_nx values (1500000);
create table hl_ns (n numeric(38,-5));
insert into hl_ns values (1500000);


evaluate 'Case 1: NUMERIC(20,5) against a float NUMERIC of scale 39 (cn / 1): the hash list scan finds every pair';
select case when a.c = b.c and a.c = 3000 then 'PASS' else 'FAIL' end res
from (select /*+ ordered parallel(0) */ count(*) c from hl_na x, (select /*+ NO_MERGE */ ca, cn / 1 as cf from hl_nb where ca >= 1) y where x.cn = y.cf) a,
     (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ count(*) c from hl_na x, (select /*+ NO_MERGE */ ca, cn / 1 as cf from hl_nb where ca >= 1) y where x.cn = y.cf) b;


evaluate 'Case 2: INT against a float NUMERIC ((cn - 0.25) / 1): the hash list scan finds every pair';
select case when a.c = b.c and a.c = 3000 then 'PASS' else 'FAIL' end res
from (select /*+ ordered parallel(0) */ count(*) c from hl_na x, (select /*+ NO_MERGE */ ca, (cn - 0.25) / 1 as cf from hl_nb where ca >= 1) y where x.ca = y.cf) a,
     (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ count(*) c from hl_na x, (select /*+ NO_MERGE */ ca, (cn - 0.25) / 1 as cf from hl_nb where ca >= 1) y where x.ca = y.cf) b;


evaluate 'Case 3: NUMERIC(10,2) against NUMERIC(20,5): the hash list scan finds every pair';
select case when a.c = b.c and a.c = 3000 then 'PASS' else 'FAIL' end res
from (select /*+ ordered parallel(0) */ count(*) c from hl_na x, (select /*+ NO_MERGE */ ca, cn from hl_nb where ca >= 1) y where x.cs = y.cn) a,
     (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ count(*) c from hl_na x, (select /*+ NO_MERGE */ ca, cn from hl_nb where ca >= 1) y where x.cs = y.cn) b;


evaluate 'Case 4: NUMERIC(20,0) against NUMERIC(30,10), past 38 digits together: the hash list scan finds every pair';
select case when a.c = b.c and a.c = 3000 then 'PASS' else 'FAIL' end res
from (select /*+ ordered parallel(0) */ count(*) c from hl_na x, (select /*+ NO_MERGE */ ca, cw from hl_nb where ca >= 1) y where x.cz = y.cw) a,
     (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ count(*) c from hl_na x, (select /*+ NO_MERGE */ ca, cw from hl_nb where ca >= 1) y where x.cz = y.cw) b;


evaluate 'Case 5: trace: Cases 1 to 4 run as a hash list scan (SCAN (hash temp(m), ...))';
set trace on;
select /*+ ordered parallel(0) */ count(*) from hl_na x, (select /*+ NO_MERGE */ ca, cn / 1 as cf from hl_nb where ca >= 1) y where x.cn = y.cf;
show trace;
select /*+ ordered parallel(0) */ count(*) from hl_na x, (select /*+ NO_MERGE */ ca, (cn - 0.25) / 1 as cf from hl_nb where ca >= 1) y where x.ca = y.cf;
show trace;
select /*+ ordered parallel(0) */ count(*) from hl_na x, (select /*+ NO_MERGE */ ca, cn from hl_nb where ca >= 1) y where x.cs = y.cn;
show trace;
select /*+ ordered parallel(0) */ count(*) from hl_na x, (select /*+ NO_MERGE */ ca, cw from hl_nb where ca >= 1) y where x.cz = y.cw;
show trace;
set trace off;


evaluate 'Case 6: CONNECT BY with a float NUMERIC PRIOR key (prior (id / 1) = pid): 5 rows';
select case when a.c = b.c and a.s = b.s and a.c = 5 and a.s = 165 then 'PASS' else 'FAIL' end res,
       a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hl_cf start with pid is null connect by prior (id / 1) = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hl_cf start with pid is null connect by prior (id / 1) = pid) t) b;


evaluate 'Case 7: CONNECT BY with prior NUMERIC(20,5) = NUMERIC(30,10) and keys of 15 integer digits: 4 rows';
select case when a.c = b.c and a.s = b.s and a.c = 4 and a.s = 110 then 'PASS' else 'FAIL' end res,
       a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hl_cl start with pid is null connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hl_cl start with pid is null connect by prior id = pid) t) b;


evaluate 'Case 8: CONNECT BY with prior BIGINT = NUMERIC(38,20): 4 rows';
select case when a.c = b.c and a.s = b.s and a.c = 4 and a.s = 110 then 'PASS' else 'FAIL' end res,
       a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hl_cb start with pid is null connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hl_cb start with pid is null connect by prior id = pid) t) b;


evaluate 'Case 9: trace: Cases 6 to 8 run as a hash list scan';
set trace on;
select n, level lv from hl_cf start with pid is null connect by prior (id / 1) = pid order siblings by n;
show trace;
select n, level lv from hl_cl start with pid is null connect by prior id = pid order siblings by n;
show trace;
select n, level lv from hl_cb start with pid is null connect by prior id = pid order siblings by n;
show trace;
set trace off;


evaluate 'Case 10: NUMERIC(38,0) against a float NUMERIC of scale -5 (a NUMERIC(38,-5) cast to NUMERIC): the hash join and the hash list scan find the pair';
select case when a.c = 1 and b.c = 1 and c.c = 1 then 'PASS' else 'FAIL' end res
from (select /*+ ordered USE_HASH */ count(*) c from hl_nx x, (select /*+ NO_MERGE */ cast (n as numeric) c from hl_ns) y where x.x = y.c) a,
     (select /*+ ordered parallel(0) */ count(*) c from hl_nx x, (select /*+ NO_MERGE */ cast (n as numeric) c from hl_ns where n > 0) y where x.x = y.c) b,
     (select /*+ ordered USE_NL NO_HASH_LIST_SCAN */ count(*) c from hl_nx x, (select /*+ NO_MERGE */ cast (n as numeric) c from hl_ns where n > 0) y where x.x = y.c) c;


drop table hl_na, hl_nb, hl_cf, hl_cl, hl_cb, hl_nx, hl_ns;
