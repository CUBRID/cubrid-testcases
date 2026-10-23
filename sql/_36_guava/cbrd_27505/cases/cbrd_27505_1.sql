/**
 *  This test case verifies CBRD-27505 : a CONNECT BY over a join, here with db_root, runs its connect condition
 *  as a hash list scan, and must find the child rows whose NUMERIC key equals the PRIOR key when the two keys
 *  differ in precision or scale, or one is a fixed NUMERIC column and the other a floating NUMERIC result such
 *  as x.n1 + 0. The single table form does not use the hash list scan.
 *
 *  Every case counts the rows of the query and of the same query with NO_HASH_LIST_SCAN,
 *  and prints PASS when both equal the expected count.
 *
 *  Coverage:
 *    Case 1:  two keys of different scales, also shown in full
 *    Case 2:  one key, no other select columns
 *    Case 3:  one key, other NUMERIC columns in the select list (a2, b2)
 *    Case 4:  one key, the same columns in the other order (b2, a2)
 *    Case 5:  two keys, the table with NULL, negative and non-matching keys
 *    Case 6:  the expression on the child side, prior x.n1 = x.n1 + 0
 *    Case 7:  prior x.n1 * 1000 = x.n1, a wider probe domain, must not raise an error
 *    Case 8:  a join with a NO_MERGE derived table, a hash list scan outside CONNECT BY
 *    Case 9:  a numeric(3,2) literal probe against a numeric(10,2) build column holding
 *             1000.00, same scale, must not raise an overflow error
 *    Case 10: two keys, both with the expression on the child side
 *    Case 11: the expression on the child side of a numeric(12,4) key
 */

drop table if exists h, h4, t9;

create table h (id int, p int, n1 numeric(10,2), n2 numeric(12,4));
insert into h values (1,0,3.00,2.2500),(2,1,3.00,2.2500),(3,1,1.50,1.0000),(4,2,2.25,0.5000),(5,2,2.25,0.5000);

create table h4 (id int primary key, i int, a numeric(10,2), a2 numeric(10,2), b numeric(12,4), b2 numeric(12,4));
insert into h4 values (1,1,3.00,3.00,2.2500,2.2500),(2,1,3.00,3.00,2.2500,2.2500),(3,2,3.00,3.00,1.0000,1.0000),
  (4,3,2.25,2.25,2.2500,2.2500),(5,3,2.25,2.25,2.2500,2.2500),(6,4,0.50,0.50,0.5000,0.5000),(7,0,0.50,0.50,0.0000,0.0000),
  (8,5,100.10,100.10,100.1000,100.1000),(9,5,100.10,100.10,100.1000,100.1000),(10,6,-3.00,-3.00,-2.2500,-2.2500),
  (11,7,NULL,NULL,NULL,NULL),(12,8,3.50,3.50,2.5000,2.5000),(20,1,10.00,10.00,7.0000,7.0000),
  (21,2,11.00,11.00,8.0000,8.0000),(22,3,12.00,12.00,9.0000,9.0000);

create table t9 (k int, v numeric(10,2));
insert into t9 values (1,1.00),(1,1000.00),(2,1.00),(2,1000.00);


evaluate 'Case 1: the reported query, two keys of different scales; 9 rows';
select level lv, sys_connect_by_path(x.id,'/') pth from h x, db_root r
start with x.id > 0 connect by nocycle prior x.n1 + 0 = x.n1 and prior x.n2 + 0 = x.n2 order by 2;
select case when a.c = b.c and a.c = 9 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c from (select level lv, sys_connect_by_path(x.id,'/') pth from h x, db_root r start with x.id > 0 connect by nocycle prior x.n1 + 0 = x.n1 and prior x.n2 + 0 = x.n2) t) a,
     (select count(*) c from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from h x, db_root r start with x.id > 0 connect by nocycle prior x.n1 + 0 = x.n1 and prior x.n2 + 0 = x.n2) t) b;


evaluate 'Case 2: one key, no other select columns; 33 rows';
select case when a.c = b.c and a.c = 33 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c from (select level lv, sys_connect_by_path(x.id,'/') pth from h4 x, db_root r start with x.id > 0 connect by nocycle prior x.a + 0 = x.a) t) a,
     (select count(*) c from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from h4 x, db_root r start with x.id > 0 connect by nocycle prior x.a + 0 = x.a) t) b;


evaluate 'Case 3: one key, a2 and b2 in the select list; 33 rows';
select case when a.c = b.c and a.c = 33 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c from (select level lv, sys_connect_by_path(x.id,'/') pth, x.a2, x.b2 from h4 x, db_root r start with x.id > 0 connect by nocycle prior x.a + 0 = x.a) t) a,
     (select count(*) c from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth, x.a2, x.b2 from h4 x, db_root r start with x.id > 0 connect by nocycle prior x.a + 0 = x.a) t) b;


evaluate 'Case 4: one key, b2 and a2 in the select list; 33 rows';
select case when a.c = b.c and a.c = 33 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c from (select level lv, sys_connect_by_path(x.id,'/') pth, x.b2, x.a2 from h4 x, db_root r start with x.id > 0 connect by nocycle prior x.a + 0 = x.a) t) a,
     (select count(*) c from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth, x.b2, x.a2 from h4 x, db_root r start with x.id > 0 connect by nocycle prior x.a + 0 = x.a) t) b;


evaluate 'Case 5: two keys on h4; 21 rows';
select case when a.c = b.c and a.c = 21 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c from (select level lv, sys_connect_by_path(x.id,'/') pth from h4 x, db_root r start with x.id > 0 connect by nocycle prior x.a + 0 = x.a and prior x.b + 0 = x.b) t) a,
     (select count(*) c from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from h4 x, db_root r start with x.id > 0 connect by nocycle prior x.a + 0 = x.a and prior x.b + 0 = x.b) t) b;


evaluate 'Case 6: prior x.n1 = x.n1 + 0; 9 rows';
select case when a.c = b.c and a.c = 9 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c from (select level lv, sys_connect_by_path(x.id,'/') pth from h x, db_root r start with x.id > 0 connect by nocycle prior x.n1 = x.n1 + 0) t) a,
     (select count(*) c from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from h x, db_root r start with x.id > 0 connect by nocycle prior x.n1 = x.n1 + 0) t) b;


evaluate 'Case 7: prior x.n1 * 1000 = x.n1; 5 rows';
select case when a.c = b.c and a.c = 5 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c from (select level lv, sys_connect_by_path(x.id,'/') pth from h x, db_root r start with x.id > 0 connect by nocycle prior x.n1 * 1000 = x.n1) t) a,
     (select count(*) c from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from h x, db_root r start with x.id > 0 connect by nocycle prior x.n1 * 1000 = x.n1) t) b;


evaluate 'Case 8: join with a derived table outside CONNECT BY; 9 rows';
select x.id, d.id from h x, (select /*+ NO_MERGE */ id, n1 from h) d where x.n1 + 0 = d.n1 order by 1, 2;
select case when a.c = b.c and a.c = 9 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c from h x, (select /*+ NO_MERGE */ id, n1 from h) d where x.n1 + 0 = d.n1) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c from h x, (select /*+ NO_MERGE */ id, n1 from h) d where x.n1 + 0 = d.n1) b;


evaluate 'Case 9: numeric(3,2) literal probe, numeric(10,2) build with 1000.00; 4 rows';
select case when a.c = b.c and a.c = 4 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c from (select level lv, sys_connect_by_path(x.k,'/') pth from t9 x, db_root r start with x.k = 1 connect by nocycle prior x.k + 1 = x.k and 1.00 = x.v) t) a,
     (select count(*) c from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.k,'/') pth from t9 x, db_root r start with x.k = 1 connect by nocycle prior x.k + 1 = x.k and 1.00 = x.v) t) b;


evaluate 'Case 10: prior x.a = x.a + 0 and prior x.b = x.b + 0; 21 rows';
select case when a.c = b.c and a.c = 21 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c from (select level lv, sys_connect_by_path(x.id,'/') pth from h4 x, db_root r start with x.id > 0 connect by nocycle prior x.a = x.a + 0 and prior x.b = x.b + 0) t) a,
     (select count(*) c from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from h4 x, db_root r start with x.id > 0 connect by nocycle prior x.a = x.a + 0 and prior x.b = x.b + 0) t) b;


evaluate 'Case 11: prior x.n2 = x.n2 + 0; 9 rows';
select case when a.c = b.c and a.c = 9 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c from (select level lv, sys_connect_by_path(x.id,'/') pth from h x, db_root r start with x.id > 0 connect by nocycle prior x.n2 = x.n2 + 0) t) a,
     (select count(*) c from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from h x, db_root r start with x.id > 0 connect by nocycle prior x.n2 = x.n2 + 0) t) b;


drop table h, h4, t9;
