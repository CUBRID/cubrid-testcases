/**
 *  This test case verifies CBRD-27505 : a hash list scan must find the build rows whose NUMERIC key equals the
 *  probe key when the two keys need more digits in common than a DOUBLE holds (equal 14 digit values in
 *  numeric(14,0), numeric(18,4) and numeric(20,6)), or one key has a negative scale.
 *
 *  Every case compares the row count and a checksum of the query with the same query on NO_HASH_LIST_SCAN,
 *  and prints PASS when both equal the expected values.
 *
 *  Coverage:
 *    Case 1-5:   14 digit keys in a join with a NO_MERGE derived table
 *    Case 6-9:   14 digit keys in a CONNECT BY over a join with db_root
 *    Case 10-12: negative scale keys in a join with a NO_MERGE derived table
 *    Case 13-15: negative scale keys in a CONNECT BY over a join with db_root
 *    Case 16:    trace of Cases 1, 6 and 13: each runs as a hash list scan (SCAN (hash temp(m), ...))
 */

drop table if exists nl_a, nl_b, nl_c4, nl_c6, nq_a, nq_b;

create table nl_a (id int, k numeric(14,0));
create table nl_b (id int, k4 numeric(18,4), k6 numeric(20,6));
insert into nl_a values (1,63427896765467),(2,57868758049228),(3,65998847102851),(4,63544859891205),(5,66020943696291),(6,65466921261572),
  (7,64863206855602),(8,93109750165006),(9,77421720172359),(10,81354367132942),(11,62460251046080),(12,53928973673806),(20,1),(21,2),(22,3);
insert into nl_b values (101,63427896765467.0000,NULL),(102,57868758049228.0000,NULL),(103,65998847102851.0000,NULL),
  (104,63544859891205.0000,NULL),(105,66020943696291.0000,NULL),(106,65466921261572.0000,NULL),
  (107,NULL,64863206855602.000000),(108,NULL,93109750165006.000000),(109,NULL,77421720172359.000000),
  (110,NULL,81354367132942.000000),(111,NULL,62460251046080.000000),(112,NULL,53928973673806.000000),
  (120,1.0000,1.000000),(121,2.0000,2.000000),(122,3.0000,3.000000);

create table nl_c4 (id int, a numeric(14,0), b numeric(18,4));
create table nl_c6 (id int, a numeric(14,0), b numeric(20,6));
insert into nl_c4 values (1,63427896765467,NULL),(2,NULL,63427896765467),(3,57868758049228,NULL),(4,NULL,57868758049228),
  (5,65998847102851,NULL),(6,NULL,65998847102851),(7,63544859891205,NULL),(8,NULL,63544859891205),
  (9,66020943696291,NULL),(10,NULL,66020943696291),(11,65466921261572,NULL),(12,NULL,65466921261572),
  (13,1,NULL),(14,NULL,1),(15,2,NULL),(16,NULL,2);
insert into nl_c6 values (1,64863206855602,NULL),(2,NULL,64863206855602),(3,93109750165006,NULL),(4,NULL,93109750165006),
  (5,77421720172359,NULL),(6,NULL,77421720172359),(7,81354367132942,NULL),(8,NULL,81354367132942),
  (9,62460251046080,NULL),(10,NULL,62460251046080),(11,53928973673806,NULL),(12,NULL,53928973673806),
  (13,1,NULL),(14,NULL,1),(15,2,NULL),(16,NULL,2);

create table nq_a (id int, a numeric(38,-5), b numeric(36,-10), c numeric(38,0), d numeric(38,2));
create table nq_b (id int, a numeric(38,-5), b numeric(36,-10), c numeric(38,0), d numeric(38,2));
insert into nq_a values (1,1200000,120000000000,1200000,1200000),(2,100000,10000000000,100000,100000),
  (3,-500000,-50000000000,-500000,-500000),(4,0,0,0,0),(5,1234500000,12340000000000,1234500000,1234500000),(6,NULL,NULL,NULL,NULL),
  (7,0,120000000000,120000000000,120000000000),(8,0,10000000000,10000000000,10000000000);
insert into nq_b select id + 100, a, b, c, d from nq_a;


evaluate 'Case 1: numeric(14,0) probe, numeric(18,4) build; 9 rows';
select case when a.c = b.c and a.s = b.s and a.c = 9 and a.s = 84984 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*1000+d.id) s from nl_a x, (select /*+ NO_MERGE */ id, k4 from nl_b) d where x.k = d.k4) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*1000+d.id) s from nl_a x, (select /*+ NO_MERGE */ id, k4 from nl_b) d where x.k = d.k4) b;


evaluate 'Case 2: numeric(14,0) probe, numeric(20,6) build; 9 rows';
select case when a.c = b.c and a.s = b.s and a.c = 9 and a.s = 121020 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*1000+d.id) s from nl_a x, (select /*+ NO_MERGE */ id, k6 from nl_b) d where x.k = d.k6) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*1000+d.id) s from nl_a x, (select /*+ NO_MERGE */ id, k6 from nl_b) d where x.k = d.k6) b;


evaluate 'Case 3: numeric(18,4) probe, numeric(14,0) build; 9 rows';
select case when a.c = b.c and a.s = b.s and a.c = 9 and a.s = 984084 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*1000+d.id) s from nl_b x, (select /*+ NO_MERGE */ id, k from nl_a) d where x.k4 = d.k) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*1000+d.id) s from nl_b x, (select /*+ NO_MERGE */ id, k from nl_a) d where x.k4 = d.k) b;


evaluate 'Case 4: numeric(20,6) probe, numeric(14,0) build; 9 rows';
select case when a.c = b.c and a.s = b.s and a.c = 9 and a.s = 1020120 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*1000+d.id) s from nl_b x, (select /*+ NO_MERGE */ id, k from nl_a) d where x.k6 = d.k) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*1000+d.id) s from nl_b x, (select /*+ NO_MERGE */ id, k from nl_a) d where x.k6 = d.k) b;


evaluate 'Case 5: x.k + 0 probe, numeric(18,4) build; 9 rows';
select case when a.c = b.c and a.s = b.s and a.c = 9 and a.s = 84984 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*1000+d.id) s from nl_a x, (select /*+ NO_MERGE */ id, k4 from nl_b) d where x.k + 0 = d.k4) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*1000+d.id) s from nl_a x, (select /*+ NO_MERGE */ id, k4 from nl_b) d where x.k + 0 = d.k4) b;


evaluate 'Case 6: CONNECT BY prior numeric(14,0) = numeric(18,4); 16 rows';
select case when a.c = b.c and a.s = b.s and a.c = 16 and a.s = 24 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.lv) s from (select level lv, sys_connect_by_path(x.id,'/') pth from nl_c4 x, db_root r start with x.a is not null connect by nocycle prior x.a = x.b) t) a,
     (select count(*) c, sum(t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from nl_c4 x, db_root r start with x.a is not null connect by nocycle prior x.a = x.b) t) b;


evaluate 'Case 7: CONNECT BY prior numeric(14,0) = numeric(20,6); 16 rows';
select case when a.c = b.c and a.s = b.s and a.c = 16 and a.s = 24 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.lv) s from (select level lv, sys_connect_by_path(x.id,'/') pth from nl_c6 x, db_root r start with x.a is not null connect by nocycle prior x.a = x.b) t) a,
     (select count(*) c, sum(t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from nl_c6 x, db_root r start with x.a is not null connect by nocycle prior x.a = x.b) t) b;


evaluate 'Case 8: CONNECT BY prior numeric(18,4) = numeric(14,0); 16 rows';
select case when a.c = b.c and a.s = b.s and a.c = 16 and a.s = 24 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.lv) s from (select level lv, sys_connect_by_path(x.id,'/') pth from nl_c4 x, db_root r start with x.b is not null connect by nocycle prior x.b = x.a) t) a,
     (select count(*) c, sum(t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from nl_c4 x, db_root r start with x.b is not null connect by nocycle prior x.b = x.a) t) b;


evaluate 'Case 9: CONNECT BY prior x.a + 0 = numeric(18,4); 16 rows';
select case when a.c = b.c and a.s = b.s and a.c = 16 and a.s = 24 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.lv) s from (select level lv, sys_connect_by_path(x.id,'/') pth from nl_c4 x, db_root r start with x.a is not null connect by nocycle prior x.a + 0 = x.b) t) a,
     (select count(*) c, sum(t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from nl_c4 x, db_root r start with x.a is not null connect by nocycle prior x.a + 0 = x.b) t) b;


evaluate 'Case 10: numeric(38,-5) probe, numeric(38,0) build; 7 rows';
select case when a.c = b.c and a.s = b.s and a.c = 7 and a.s = 30723 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*1000+d.id) s from nq_a x, (select /*+ NO_MERGE */ id, c from nq_b) d where x.a = d.c) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*1000+d.id) s from nq_a x, (select /*+ NO_MERGE */ id, c from nq_b) d where x.a = d.c) b;


evaluate 'Case 11: numeric(36,-10) probe, numeric(38,0) build; 5 rows';
select case when a.c = b.c and a.s = b.s and a.c = 5 and a.s = 22534 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*1000+d.id) s from nq_a x, (select /*+ NO_MERGE */ id, c from nq_b) d where x.b = d.c) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*1000+d.id) s from nq_a x, (select /*+ NO_MERGE */ id, c from nq_b) d where x.b = d.c) b;


evaluate 'Case 12: numeric(36,-10) probe, d.c + 0 build; 5 rows';
select case when a.c = b.c and a.s = b.s and a.c = 5 and a.s = 22534 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(x.id*1000+d.id) s from nq_a x, (select /*+ NO_MERGE */ id, c from nq_b) d where x.b = d.c + 0) a,
     (select /*+ NO_HASH_LIST_SCAN */ count(*) c, sum(x.id*1000+d.id) s from nq_a x, (select /*+ NO_MERGE */ id, c from nq_b) d where x.b = d.c + 0) b;


evaluate 'Case 13: CONNECT BY prior numeric(36,-10) = numeric(38,0); 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 12 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.lv) s from (select level lv, sys_connect_by_path(x.id,'/') pth from nq_a x, db_root r start with x.id > 0 connect by nocycle prior x.b = x.c) t) a,
     (select count(*) c, sum(t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from nq_a x, db_root r start with x.id > 0 connect by nocycle prior x.b = x.c) t) b;


evaluate 'Case 14: CONNECT BY prior numeric(36,-10) = x.b + 0; 12 rows';
select case when a.c = b.c and a.s = b.s and a.c = 12 and a.s = 16 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.lv) s from (select level lv, sys_connect_by_path(x.id,'/') pth from nq_a x, db_root r start with x.id > 0 connect by nocycle prior x.b = x.b + 0) t) a,
     (select count(*) c, sum(t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from nq_a x, db_root r start with x.id > 0 connect by nocycle prior x.b = x.b + 0) t) b;


evaluate 'Case 15: CONNECT BY prior numeric(36,-10) = numeric(38,2); 10 rows';
select case when a.c = b.c and a.s = b.s and a.c = 10 and a.s = 12 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.lv) s from (select level lv, sys_connect_by_path(x.id,'/') pth from nq_a x, db_root r start with x.id > 0 connect by nocycle prior x.b = x.d) t) a,
     (select count(*) c, sum(t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ level lv, sys_connect_by_path(x.id,'/') pth from nq_a x, db_root r start with x.id > 0 connect by nocycle prior x.b = x.d) t) b;


evaluate 'Case 16: trace of Cases 1, 6 and 13, each scans hash temp';
set trace on;
select count(*) from nl_a x, (select /*+ NO_MERGE */ id, k4 from nl_b) d where x.k = d.k4;
show trace;
select count(*) from (select level lv, sys_connect_by_path(x.id,'/') pth from nl_c4 x, db_root r start with x.a is not null connect by nocycle prior x.a = x.b) t;
show trace;
select count(*) from (select level lv, sys_connect_by_path(x.id,'/') pth from nq_a x, db_root r start with x.id > 0 connect by nocycle prior x.b = x.c) t;
show trace;
set trace off;


drop table nl_a, nl_b, nl_c4, nl_c6, nq_a, nq_b;
