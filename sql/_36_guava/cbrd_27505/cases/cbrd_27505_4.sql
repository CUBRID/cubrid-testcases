/**
 *  This test case verifies CBRD-27505 : a single table CONNECT BY without an index on the child key runs its
 *  connect condition as a hash list scan also when the PRIOR key and the child key differ in type or in NUMERIC
 *  scale, since both keys are hashed in one domain common to the pair, and must return the same rows as the
 *  single table plan (the NO_HASH_LIST_SCAN hint).
 *
 *  Every case counts the rows of the query and a checksum of its levels, compares both with the same query with
 *  NO_HASH_LIST_SCAN, and prints PASS when both equal the expected values.
 *
 *  Coverage:
 *    Case 1:  SMALLINT parent key, INT child key holding 100000
 *    Case 2:  INT parent key holding 70000, SMALLINT child key
 *    Case 3:  CHAR(3) parent key, VARCHAR(10) child key holding 'abcdef'
 *    Case 4:  BIGINT 9007199254740993 parent key, DOUBLE child key 9007199254740992 (equal as DOUBLE)
 *    Case 5:  DOUBLE parent key, BIGINT child keys
 *    Case 6:  NUMERIC(12,4) parent key, NUMERIC(10,2) child key
 *    Case 7:  NUMERIC(10,2) parent key, NUMERIC(12,4) child key, 1.0001 must not match 1
 *    Case 8:  NUMERIC expression on the child side, prior k = pk + 0
 *    Case 9:  NUMERIC expression on the parent side, prior k + 0 = pk
 *    Case 10: INT parent key, NUMERIC(10,2) child key
 *    Case 11: NUMERIC(10,2) parent key, INT child key
 *    Case 12: DOUBLE parent key, NUMERIC(20,2) child key
 *    Case 13: FLOAT parent key, DOUBLE child key
 *    Case 14: two keys, INT = BIGINT and SMALLINT = INT
 *    Case 15: INT parent key, VARCHAR child key holding 'abc', no START WITH row: no error, 0 rows.
 *             The child key is cast to DOUBLE, which the hash list scan would evaluate on every row,
 *             so this query keeps the single table plan.
 *    Case 16: as Case 15 with a NULL root key: 1 row, no error
 *    Case 17: query plans: Cases 1, 6 and 4 scan the table without sargs (hash list scan), Case 15
 *             keeps the connect condition in sargs (single table plan)
 */

drop table if exists hs_si, hs_is, hs_cv, hs_bd, hs_db, hs_na, hs_nb, hs_in, hs_ni, hs_dn, hs_fd, hs_mk, hs_iv, hs_ivn;

create table hs_si (id smallint, pid int, n int);
insert into hs_si values (1, null, 1), (2, 1, 2), (3, 100000, 3), (4, 2, 4);
create table hs_is (id int, pid smallint, n int);
insert into hs_is values (1, null, 1), (70000, 1, 2), (3, 1, 3), (4, 3, 4);
create table hs_cv (id char(3), pid varchar(10), n int);
insert into hs_cv values ('abc', null, 1), ('def', 'abc', 2), ('x', 'abcdef', 3), ('y', 'def', 4);
create table hs_bd (id bigint, pid double, n int);
insert into hs_bd values (9007199254740993, null, 1), (2, 9007199254740992, 2), (3, 2, 3);
create table hs_db (id double, pid bigint, n int);
insert into hs_db values (9007199254740992, null, 1), (2, 9007199254740993, 2), (3, 2, 3), (4, 9007199254740992, 4);
create table hs_na (id numeric(12,4), pid numeric(10,2), n int);
insert into hs_na values (1, null, 1), (2, 1, 2), (3, 2, 3), (4, 1.5, 4), (1.5, null, 5);
create table hs_nb (id numeric(10,2), pid numeric(12,4), n int);
insert into hs_nb values (1, null, 1), (2, 1.0, 2), (3, 2.0000, 3), (4, 1.0001, 4);
create table hs_in (id int, pid numeric(10,2), n int);
insert into hs_in values (1, null, 1), (2, 1.00, 2), (3, 1.50, 3), (4, 2, 4);
create table hs_ni (id numeric(10,2), pid int, n int);
insert into hs_ni values (1.00, null, 1), (2, 1, 2), (1.5, 2, 3), (3, 2, 4);
create table hs_dn (id double, pid numeric(20,2), n int);
insert into hs_dn values (1.5, null, 1), (2, 1.50, 2), (3, 2, 3), (4, 2.01, 4);
create table hs_fd (id float, pid double, n int);
insert into hs_fd values (0.5, null, 1), (0.1, 0.5, 2), (3, 0.1, 3), (4, 0.5, 4);
create table hs_mk (id int, pid bigint, g smallint, pg int, n int);
insert into hs_mk values (1, null, 1, 1, 1), (2, 1, 1, 2, 2), (3, 1, 1, 1, 3), (4, 2, 1, 1, 4), (5, 3, 1, 1, 5);
create table hs_iv (id int, pid varchar(10), n int);
insert into hs_iv values (1, null, 1), (2, '1', 2), (3, 'abc', 3);
create table hs_ivn (id int, pid varchar(10), n int);
insert into hs_ivn values (null, null, 1), (2, '1', 2), (3, 'abc', 3);


evaluate 'Case 1: prior smallint = int; 3 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 3 and nvl(a.s, -1) = 76 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_si start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_si start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 2: prior int = smallint; 4 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 4 and nvl(a.s, -1) = 108 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_is start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_is start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 3: prior char(3) = varchar(10); 3 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 3 and nvl(a.s, -1) = 76 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_cv start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_cv start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 4: prior bigint = double; 3 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 3 and nvl(a.s, -1) = 66 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_bd start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_bd start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 5: prior double = bigint; 4 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 4 and nvl(a.s, -1) = 108 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_db start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_db start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 6: prior numeric(12,4) = numeric(10,2); 3 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 3 and nvl(a.s, -1) = 66 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_na start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_na start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 7: prior numeric(10,2) = numeric(12,4); 3 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 3 and nvl(a.s, -1) = 66 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_nb start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_nb start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 8: prior numeric(12,4) = numeric(10,2) + 0; 3 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 3 and nvl(a.s, -1) = 66 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_na start with n = 1 connect by prior id = pid + 0) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_na start with n = 1 connect by prior id = pid + 0) t) b;


evaluate 'Case 9: prior numeric(10,2) + 0 = numeric(12,4); 3 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 3 and nvl(a.s, -1) = 66 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_nb start with n = 1 connect by prior id + 0 = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_nb start with n = 1 connect by prior id + 0 = pid) t) b;


evaluate 'Case 10: prior int = numeric(10,2); 3 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 3 and nvl(a.s, -1) = 76 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_in start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_in start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 11: prior numeric(10,2) = int; 4 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 4 and nvl(a.s, -1) = 109 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_ni start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_ni start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 12: prior double = numeric(20,2); 3 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 3 and nvl(a.s, -1) = 66 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_dn start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_dn start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 13: prior float = double; 3 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 3 and nvl(a.s, -1) = 75 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_fd start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_fd start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 14: prior int = bigint and prior smallint = int; 3 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 3 and nvl(a.s, -1) = 96 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_mk start with n = 1 connect by prior id = pid and prior g = pg) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_mk start with n = 1 connect by prior id = pid and prior g = pg) t) b;


evaluate 'Case 15: prior int = varchar holding abc, no START WITH row; 0 rows';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 0 and nvl(a.s, -1) = -1 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_iv start with n = 99 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_iv start with n = 99 connect by prior id = pid) t) b;


evaluate 'Case 16: prior int = varchar holding abc, NULL root key; 1 row';
select case when a.c = b.c and nvl(a.s, -1) = nvl(b.s, -1) and a.c = 1 and nvl(a.s, -1) = 11 then 'PASS' else 'FAIL' end res, a.c cnt
from (select count(*) c, sum(t.n * 10 + t.lv) s from (select n, level lv from hs_ivn start with n = 1 connect by prior id = pid) t) a,
     (select count(*) c, sum(t.n * 10 + t.lv) s from (select /*+ NO_HASH_LIST_SCAN */ n, level lv from hs_ivn start with n = 1 connect by prior id = pid) t) b;


evaluate 'Case 17: query plans of Cases 1, 6, 4 (hash list scan) and 15 (single table plan)';
--@queryplan
select n, level lv from hs_si start with n = 1 connect by prior id = pid order siblings by n;
--@queryplan
select n, level lv from hs_na start with n = 1 connect by prior id = pid order siblings by n;
--@queryplan
select n, level lv from hs_bd start with n = 1 connect by prior id = pid order siblings by n;
--@queryplan
select n, level lv from hs_iv start with n = 99 connect by prior id = pid order siblings by n;


drop table hs_si, hs_is, hs_cv, hs_bd, hs_db, hs_na, hs_nb, hs_in, hs_ni, hs_dn, hs_fd, hs_mk, hs_iv, hs_ivn;
