/**
 *  This test case verifies CBRD-27505 : a hash list scan must find the build rows whose NUMERIC key equals the
 *  probe key when the two keys have different scales (equal 9 digit values in numeric(14,0), numeric(18,4) and
 *  numeric(20,6)). The pair is hashed as DOUBLE, so the values are kept within what a DOUBLE holds exactly.
 *
 *  Every case compares the row count and a checksum of the query with the same query on NO_HASH_LIST_SCAN,
 *  and prints PASS when both equal the expected values.
 *
 *  Coverage:
 *    Case 1-5:   different scale keys in a join with a NO_MERGE derived table
 *    Case 6-9:   different scale keys in a CONNECT BY over a join with db_root
 *    Case 10:    trace of Cases 1 and 6: each runs as a hash list scan (SCAN (hash temp(m), ...))
 */

drop table if exists nl_a, nl_b, nl_c4, nl_c6;

create table nl_a (id int, k numeric(14,0));
create table nl_b (id int, k4 numeric(18,4), k6 numeric(20,6));
insert into nl_a values (1,634278967),(2,578687580),(3,659988471),(4,635448598),(5,660209436),(6,654669212),
  (7,648632068),(8,931097501),(9,774217201),(10,813543671),(11,624602510),(12,539289736),(20,1),(21,2),(22,3);
insert into nl_b values (101,634278967.0000,NULL),(102,578687580.0000,NULL),(103,659988471.0000,NULL),
  (104,635448598.0000,NULL),(105,660209436.0000,NULL),(106,654669212.0000,NULL),
  (107,NULL,648632068.000000),(108,NULL,931097501.000000),(109,NULL,774217201.000000),
  (110,NULL,813543671.000000),(111,NULL,624602510.000000),(112,NULL,539289736.000000),
  (120,1.0000,1.000000),(121,2.0000,2.000000),(122,3.0000,3.000000);

create table nl_c4 (id int, a numeric(14,0), b numeric(18,4));
create table nl_c6 (id int, a numeric(14,0), b numeric(20,6));
insert into nl_c4 values (1,634278967,NULL),(2,NULL,634278967),(3,578687580,NULL),(4,NULL,578687580),
  (5,659988471,NULL),(6,NULL,659988471),(7,635448598,NULL),(8,NULL,635448598),
  (9,660209436,NULL),(10,NULL,660209436),(11,654669212,NULL),(12,NULL,654669212),
  (13,1,NULL),(14,NULL,1),(15,2,NULL),(16,NULL,2);
insert into nl_c6 values (1,648632068,NULL),(2,NULL,648632068),(3,931097501,NULL),(4,NULL,931097501),
  (5,774217201,NULL),(6,NULL,774217201),(7,813543671,NULL),(8,NULL,813543671),
  (9,624602510,NULL),(10,NULL,624602510),(11,539289736,NULL),(12,NULL,539289736),
  (13,1,NULL),(14,NULL,1),(15,2,NULL),(16,NULL,2);


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


evaluate 'Case 10: trace of Cases 1 and 6, each scans hash temp';
set trace on;
select count(*) from nl_a x, (select /*+ NO_MERGE */ id, k4 from nl_b) d where x.k = d.k4;
show trace;
select count(*) from (select level lv, sys_connect_by_path(x.id,'/') pth from nl_c4 x, db_root r start with x.a is not null connect by nocycle prior x.a = x.b) t;
show trace;
set trace off;


drop table nl_a, nl_b, nl_c4, nl_c6;
