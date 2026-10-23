/**
 *  This test case verifies CBRD-27505 : a hash list scan outside CONNECT BY must find the build rows whose
 *  NUMERIC key equals the probe key when one key is a floating NUMERIC expression result and the other a fixed
 *  NUMERIC column, or when both are fixed with different scales. The build side is a derived table, CTE or
 *  subquery kept as a list.
 *
 *  Every case compares the row count and a checksum of the query with the same query on NO_HASH_LIST_SCAN,
 *  and prints PASS when both equal the expected values.
 *
 *  Coverage:
 *    Case 1:  the expression on the build side, x.n1 = d.n1 + 0
 *    Case 2:  the expression in the select list of the derived table
 *    Case 3:  the expression in the select list of the outer derived table
 *    Case 4:  numeric(10,2) probe, numeric(12,4) build
 *    Case 5:  numeric(12,4) probe, numeric(10,2) build
 *    Case 6:  two keys, a floating key and a key of another scale
 *    Case 7:  two keys, an INT key and a key of another scale
 *    Case 8:  a CTE, x.n1 + 0 = c.n1
 *    Case 9:  a CTE, numeric(10,2) probe, numeric(12,4) build
 *    Case 10: a GROUP BY derived table
 *    Case 11: a UNION ALL derived table
 *    Case 12: numeric(5,2) probe, numeric(12,4) build holding a value beyond the probe domain
 *    Case 13: x.n3 + 0 probe, numeric(20,6) build holding a 14 digit value
 *    Case 14: LEFT OUTER JOIN, x.n1 + 0 = d.n1
 *    Case 15: LEFT OUTER JOIN, numeric(10,2) probe, numeric(12,4) build
 *    Case 16: a correlated scalar subquery reopened for every outer row
 */

drop table if exists hn_a, hn_b;

create table hn_a (id int, n1 numeric(10,2), n2 numeric(12,4), n3 numeric(5,2), n4 numeric(20,6));
create table hn_b (id int, n1 numeric(10,2), n2 numeric(12,4), n3 numeric(5,2), n4 numeric(20,6));
insert into hn_a values (1,3.00,3.0000,3.00,3.000000),(2,3.00,3.0000,3.00,3.000000),(3,1.50,1.5000,1.50,1.500000),
  (4,2.25,2.2500,2.25,2.250000),(5,NULL,NULL,NULL,NULL),(6,-3.00,-3.0000,-3.00,-3.000000),(7,100.10,100.1000,100.10,100.100000),
  (8,0.00,0.0000,0.00,0.000000),(9,7.77,7.7700,7.77,7.770000),(10,NULL,NULL,NULL,NULL);
insert into hn_b values (11,3.00,3.0000,3.00,3.000000),(12,3.00,3.0000,3.00,3.000000),(13,1.50,1.5000,1.50,1.500000),
  (14,2.25,2.2500,2.25,2.250000),(15,NULL,NULL,NULL,NULL),(16,-3.00,-3.0000,-3.00,-3.000000),(17,100.10,100.1000,100.10,100.100000),
  (18,0.00,0.0000,0.00,0.000000),(19,8.88,8.8800,8.88,8.880000),(20,99999.99,12345678.9000,999.99,12345678901234.500000),
  (21,1.50,1.5000,1.50,1.500000);


evaluate 'Case 1: the expression on the build side, x.n1 = d.n1 + 0; 10 rows';
select x.id, d.id from hn_a x, (select /*+ NO_MERGE */ id, n1 from hn_b) d where x.n1 = d.n1 + 0 order by 1, 2;
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 3845 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n1 from hn_b) d where x.n1 = d.n1 + 0) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n1 from hn_b) d where x.n1 = d.n1 + 0) b;


evaluate 'Case 2: the expression in the select list of the derived table; 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 3845 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n1 + 0 e from hn_b) d where x.n1 = d.e) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n1 + 0 e from hn_b) d where x.n1 = d.e) b;


evaluate 'Case 3: the expression in the select list of the outer derived table; 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 3845 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(p.id*100+d.id) s from (select /*+ NO_MERGE */ id, n1 + 0 e from hn_a) p, (select /*+ NO_MERGE */ id, n1 from hn_b) d where p.e = d.n1) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(p.id*100+d.id) s from (select /*+ NO_MERGE */ id, n1 + 0 e from hn_a) p, (select /*+ NO_MERGE */ id, n1 from hn_b) d where p.e = d.n1) b;


evaluate 'Case 4: numeric(10,2) probe, numeric(12,4) build; 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 3845 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n2 from hn_b) d where x.n1 = d.n2) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n2 from hn_b) d where x.n1 = d.n2) b;


evaluate 'Case 5: numeric(12,4) probe, numeric(10,2) build; 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 3845 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n1 from hn_b) d where x.n2 = d.n1) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n1 from hn_b) d where x.n2 = d.n1) b;


evaluate 'Case 6: two keys, a floating key and a key of another scale; 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 3845 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n1, n2 from hn_b) d where x.n1 + 0 = d.n1 and x.n2 = d.n1) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n1, n2 from hn_b) d where x.n1 + 0 = d.n1 and x.n2 = d.n1) b;


evaluate 'Case 7: two keys, an INT key and a key of another scale; 7 rows';
select case when a.c = b.c and a.s = b.s and a.c = 7 and a.s = 3201 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n1, n2 from hn_b) d where x.id + 10 = d.id and x.n1 = d.n2) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n1, n2 from hn_b) d where x.id + 10 = d.id and x.n1 = d.n2) b;


evaluate 'Case 8: a CTE, x.n1 + 0 = c.n1; 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 3845 then 'PASS' else 'FAIL' end res, a.c cnt
from (with c as (select /*+ NO_MERGE */ id, n1 from hn_b) select count(*) c, sum(x.id*100+c.id) s from hn_a x, c where x.n1 + 0 = c.n1) a,
     (with c as (select /*+ NO_MERGE */ id, n1 from hn_b) select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+c.id) s from hn_a x, c where x.n1 + 0 = c.n1) b;


evaluate 'Case 9: a CTE, numeric(10,2) probe, numeric(12,4) build; 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 3845 then 'PASS' else 'FAIL' end res, a.c cnt
from (with c as (select /*+ NO_MERGE */ id, n2 from hn_b) select count(*) c, sum(x.id*100+c.id) s from hn_a x, c where x.n1 = c.n2) a,
     (with c as (select /*+ NO_MERGE */ id, n2 from hn_b) select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+c.id) s from hn_a x, c where x.n1 = c.n2) b;


evaluate 'Case 10: a GROUP BY derived table; 7 rows';
select case when a.c = b.c and a.s = b.s and a.c = 7 and a.s = 3110 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+d.k) s from hn_a x, (select n1, count(*) k from hn_b group by n1) d where x.n1 + 0 = d.n1) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+d.k) s from hn_a x, (select n1, count(*) k from hn_b group by n1) d where x.n1 + 0 = d.n1) b;


evaluate 'Case 11: a UNION ALL derived table; 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 3845 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+d.id) s from hn_a x, (select id, n1 from hn_b union all select id, n1 from hn_b where id < 0) d where x.n1 + 0 = d.n1) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+d.id) s from hn_a x, (select id, n1 from hn_b union all select id, n1 from hn_b where id < 0) d where x.n1 + 0 = d.n1) b;


evaluate 'Case 12: numeric(5,2) probe, numeric(12,4) build holding a value beyond the probe domain; 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 3845 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n2 from hn_b) d where x.n3 = d.n2) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n2 from hn_b) d where x.n3 = d.n2) b;


evaluate 'Case 13: x.n3 + 0 probe, numeric(20,6) build holding a 14 digit value; 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 3845 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n4 from hn_b) d where x.n3 + 0 = d.n4) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+d.id) s from hn_a x, (select /*+ NO_MERGE */ id, n4 from hn_b) d where x.n3 + 0 = d.n4) b;


evaluate 'Case 14: LEFT OUTER JOIN, x.n1 + 0 = d.n1; 13 rows';
select case when a.c = b.c and a.s = b.s and a.c = 13 and a.s = 6245 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+coalesce(d.id,0)) s from hn_a x left outer join (select /*+ NO_MERGE */ id, n1 from hn_b) d on x.n1 + 0 = d.n1) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+coalesce(d.id,0)) s from hn_a x left outer join (select /*+ NO_MERGE */ id, n1 from hn_b) d on x.n1 + 0 = d.n1) b;


evaluate 'Case 15: LEFT OUTER JOIN, numeric(10,2) probe, numeric(12,4) build; 13 rows';
select case when a.c = b.c and a.s = b.s and a.c = 13 and a.s = 6245 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*100+coalesce(d.id,0)) s from hn_a x left outer join (select /*+ NO_MERGE */ id, n2 from hn_b) d on x.n1 = d.n2) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*100+coalesce(d.id,0)) s from hn_a x left outer join (select /*+ NO_MERGE */ id, n2 from hn_b) d on x.n1 = d.n2) b;


evaluate 'Case 16: a correlated scalar subquery reopened for every outer row; 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 5510 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.id*100+t.k) s from (select x.id, (select count(*) from hn_a y, (select /*+ NO_MERGE */ id, n2 from hn_b) d where y.n1 = d.n2 and y.id = x.id) k from hn_a x) t) a,
     (select count(*) c, sum(t.id*100+t.k) s from (select x.id, (select /*+ NO_HASH_LIST_SCAN */ count(*) from hn_a y, (select /*+ NO_MERGE */ id, n2 from hn_b) d where y.n1 = d.n2 and y.id = x.id) k from hn_a x) t) b;


drop table hn_a, hn_b;
