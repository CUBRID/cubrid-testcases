/*
 * This test case verifies CBRD-27329 : the serial CONNECT BY refactor (hash
 * child-finding and in-memory DFS) keeps the results of hierarchical queries.
 *
 * Case 1: aggregates over a hierarchical query on a table with an index.
 *   Bug (also in develop before this change): the aggregate index optimization
 *   answered COUNT(*) / COUNT(col) from the index alone, so it returned the
 *   table row count (4) instead of the number of hierarchical rows (8) when
 *   there is no START WITH, and 1 instead of 2 or 4 with START WITH id = 2 / 1.
 *   Fix: the optimization is skipped for hierarchical queries. Each check
 *   compares the aggregate with the same aggregate over the hierarchical
 *   query wrapped in a derived table, which never took that shortcut.
 *   develop: 1-1, 1-3, 1-4, 1-5, 1-6 FAIL; this change: all PASS.
 *   MIN/MAX (1-7, 1-8) and START WITH pid IS NULL (1-2) were already correct.
 *
 * Case 2: JSON keys that are equal by comparison but differ in text,
 *   '"true"' vs 'true', '"false"' vs 'false' and '-0.0' vs '0.0'.
 *   The NOCYCLE cycle check must see the second row as a repeat of the first,
 *   so each query returns 1 row with CONNECT_BY_ISCYCLE = 1 (same as develop).
 *   An earlier revision hashed JSON by text and returned 2 rows.
 *
 * Case 3: JSON child keys on a single table without an index. The child keys
 *   '1.0' and '"1"' compare equal to the parent key '1', so both rows are
 *   children of the root (3 rows, same as develop and as the NO_HASH_LIST_SCAN
 *   hint). The query must keep the single-table plan: the hash list scan
 *   hashes JSON by text, so it would not match these keys.
 *
 * Case 4: NUMERIC keys of different scales on a single table without an
 *   index, NUMERIC(12,4) parent key against NUMERIC(10,2) child key and the
 *   reverse. 3 rows each, same as develop and as the NO_HASH_LIST_SCAN hint.
 *   An earlier revision moved these queries to the hash list scan, which
 *   hashes NUMERIC by its unscaled digits, and returned only the root.
 *
 * Case 5: keys of different types on a single table without an index,
 *   SMALLINT parent key against INT child key, CHAR(3) against VARCHAR(10)
 *   and BIGINT against DOUBLE. Each query returns the same rows as develop
 *   and as the NO_HASH_LIST_SCAN hint (3, 3 and 3 rows). An earlier revision
 *   moved these queries to the hash list scan, which coerces the child keys to
 *   the parent key's type: it failed with "Cannot coerce value of domain" on
 *   the child keys 100000 and 'abcdef' and missed the child of
 *   9007199254740993 whose key 9007199254740992 is equal as DOUBLE.
 *
 * Case 6: LEVEL generator (CONNECT BY without PRIOR) over a one-row table
 *   whose CONNECT BY assigns a session variable, directly or inside the
 *   condition of CASE, IF, DECODE or a predicate. The condition changes at each
 *   level, so the generator fast-path, which evaluates the child scan once,
 *   must not be taken. Each check compares the count with develop (4 or 2),
 *   while evaluating the child scan once returns 10. Case 6-7 is a
 *   deterministic CONNECT BY LEVEL <= 5 that may take the fast-path (5 rows).
 *
 * Case 7: CONNECT BY PRIOR id = pid AND grp = 7, grp IN (7, 8) and
 *   (grp = 7 OR grp = 8) with an index on (grp, pid). The index serves the
 *   child lookup, so the plan must keep the single-table hierarchical
 *   iteration (index scan on i_gt) as in develop. An earlier revision moved
 *   these queries to the hash list scan. The rows are the same either way,
 *   so the plan is checked: iscan on i_gt for the single-table plan, sscan
 *   for the hash list scan. The last query is the negative control: with
 *   index (grp, x, pid) and x not fixed by the CONNECT BY, the hash list scan
 *   is used.
 */
drop table if exists tc_pk;
drop table if exists tj;
drop table if exists tj2;
drop table if exists tj3;
drop table if exists m3;
drop table if exists tn;
drop table if exists tn4;
drop table if exists tt1;
drop table if exists tt2;
drop table if exists tt3;
drop table if exists t1row;
drop table if exists gt;
drop table if exists gx;

-- Case 1
create table tc_pk (id int primary key, pid int);
insert into tc_pk values (1, null), (2, 1), (3, 1), (4, 2);

select 'case 1-1' as tc, h.c, case when h.c = d.c then 'PASS' else 'FAIL' end as result
from (select count(*) c from tc_pk connect by prior id = pid) h,
     (select count(*) c from (select id from tc_pk connect by prior id = pid) x) d;

select 'case 1-2' as tc, h.c, case when h.c = d.c then 'PASS' else 'FAIL' end as result
from (select count(*) c from tc_pk start with pid is null connect by prior id = pid) h,
     (select count(*) c from (select id from tc_pk start with pid is null connect by prior id = pid) x) d;

select 'case 1-3' as tc, h.c, case when h.c = d.c then 'PASS' else 'FAIL' end as result
from (select count(*) c from tc_pk start with id = 2 connect by prior id = pid) h,
     (select count(*) c from (select id from tc_pk start with id = 2 connect by prior id = pid) x) d;

select 'case 1-4' as tc, h.c, case when h.c = d.c then 'PASS' else 'FAIL' end as result
from (select count(*) c from tc_pk start with id = 1 connect by prior id = pid) h,
     (select count(*) c from (select id from tc_pk start with id = 1 connect by prior id = pid) x) d;

select 'case 1-5' as tc, h.c, case when h.c = d.c then 'PASS' else 'FAIL' end as result
from (select count(id) c from tc_pk connect by prior id = pid) h,
     (select count(id) c from (select id from tc_pk connect by prior id = pid) x) d;

select 'case 1-6' as tc, h.c, case when h.c = d.c then 'PASS' else 'FAIL' end as result
from (select count(*) c from tc_pk where id > 0 connect by prior id = pid) h,
     (select count(*) c from (select id from tc_pk where id > 0 connect by prior id = pid) x) d;

select 'case 1-7' as tc, h.mn, h.mx, case when h.mn = d.mn and h.mx = d.mx then 'PASS' else 'FAIL' end as result
from (select min(id) mn, max(id) mx from tc_pk connect by prior id = pid) h,
     (select min(id) mn, max(id) mx from (select id from tc_pk connect by prior id = pid) x) d;

select 'case 1-8' as tc, h.mn, h.mx, case when h.mn = d.mn and h.mx = d.mx then 'PASS' else 'FAIL' end as result
from (select min(id) mn, max(id) mx from tc_pk start with id = 2 connect by prior id = pid) h,
     (select min(id) mn, max(id) mx from (select id from tc_pk start with id = 2 connect by prior id = pid) x) d;

-- Case 2
create table tj (id int, pid int, j json);
insert into tj values (1, 1, '"true"'), (1, 1, 'true');
select id, pid, json_type (j) jt, level lv, connect_by_iscycle cyc
from tj start with json_type (j) = 'STRING' connect by nocycle prior id = pid;

create table tj3 (id int, pid int, j json);
insert into tj3 values (1, 1, '"false"'), (1, 1, 'false');
select id, pid, json_type (j) jt, level lv, connect_by_iscycle cyc
from tj3 start with json_type (j) = 'STRING' connect by nocycle prior id = pid;

create table tj2 (id int, pid int, j json);
insert into tj2 values (1, 1, '-0.0'), (1, 1, '0.0');
select id, cast (j as varchar) jv, level lv, connect_by_iscycle cyc
from tj2 start with cast (j as varchar) like '-%' connect by nocycle prior id = pid;

-- Case 3
create table m3 (id int, j json, pj json);
insert into m3 values (1, '1', null), (2, '5', '1.0'), (3, '6', '"1"');
select id, level lv from m3 start with id = 1 connect by prior j = pj order siblings by id;
select /*+ NO_HASH_LIST_SCAN */ id, level lv from m3 start with id = 1 connect by prior j = pj order siblings by id;

-- Case 4
create table tn4 (k numeric(12,4), pk numeric(10,2), n int);
insert into tn4 values (1, null, 1), (2, 1, 2), (3, 2, 3);
select n, level lv from tn4 start with n = 1 connect by prior k = pk order siblings by n;
select /*+ NO_HASH_LIST_SCAN */ n, level lv from tn4 start with n = 1 connect by prior k = pk order siblings by n;

create table tn (k numeric(10,2), pk numeric(12,4), n int);
insert into tn values (1, null, 1), (2, 1.0, 2), (3, 2.0000, 3);
select n, level lv from tn start with n = 1 connect by prior k = pk order siblings by n;
select /*+ NO_HASH_LIST_SCAN */ n, level lv from tn start with n = 1 connect by prior k = pk order siblings by n;

-- Case 5
create table tt1 (id smallint, pid int, n int);
insert into tt1 values (1, null, 1), (2, 1, 2), (3, 100000, 3), (4, 2, 4);
select n, level lv from tt1 start with n = 1 connect by prior id = pid order siblings by n;
select /*+ NO_HASH_LIST_SCAN */ n, level lv from tt1 start with n = 1 connect by prior id = pid order siblings by n;

create table tt2 (id char(3), pid varchar(10), n int);
insert into tt2 values ('abc', null, 1), ('def', 'abc', 2), ('x', 'abcdef', 3), ('y', 'def', 4);
select n, level lv from tt2 start with n = 1 connect by prior id = pid order siblings by n;
select /*+ NO_HASH_LIST_SCAN */ n, level lv from tt2 start with n = 1 connect by prior id = pid order siblings by n;

create table tt3 (id bigint, pid double, n int);
insert into tt3 values (9007199254740993, null, 1), (2, 9007199254740992, 2), (3, 2, 3);
select n, level lv from tt3 start with n = 1 connect by prior id = pid order siblings by n;
select /*+ NO_HASH_LIST_SCAN */ n, level lv from tt3 start with n = 1 connect by prior id = pid order siblings by n;

-- Case 6
create table t1row (c int);
insert into t1row values (1);

set @w = 0;
select 'case 6-1' as tc, x.c, case when x.c = 4 then 'PASS' else 'FAIL' end as result
from (select count(*) c from t1row connect by (@w := @w + 1) + level * 0 > 0 and c + @w < 4 and level <= 10) x;

set @w = 0;
select 'case 6-2' as tc, x.c, case when x.c = 4 then 'PASS' else 'FAIL' end as result
from (select count(*) c from t1row connect by level <= 10 and case when c + (@w := @w + 1) <= 4 then 1 else 0 end = 1) x;

set @w = 0;
select 'case 6-3' as tc, x.c, case when x.c = 2 then 'PASS' else 'FAIL' end as result
from (select count(*) c from t1row connect by level <= 10 and case c + (@w := @w + 1) when 2 then 1 when 3 then 1 when 4 then 1 else 0 end = 1) x;

set @w = 0;
select 'case 6-4' as tc, x.c, case when x.c = 4 then 'PASS' else 'FAIL' end as result
from (select count(*) c from t1row connect by level <= 10 and if (c + (@w := @w + 1) <= 4, 1, 0) = 1) x;

set @w = 0;
select 'case 6-5' as tc, x.c, case when x.c = 2 then 'PASS' else 'FAIL' end as result
from (select count(*) c from t1row connect by level <= 10 and decode (c + (@w := @w + 1), 2, 1, 3, 1, 4, 1, 0) = 1) x;

set @w = 0;
select 'case 6-6' as tc, x.c, case when x.c = 4 then 'PASS' else 'FAIL' end as result
from (select count(*) c from t1row connect by level <= 10 and (c + (@w := @w + 1) <= 4) + 0 = 1) x;

set @w = 0;
select 'case 6-7' as tc, x.c, case when x.c = 5 then 'PASS' else 'FAIL' end as result
from (select count(*) c from t1row connect by level <= 5) x;

-- Case 7
create table gt (id int, pid int, grp int, x int);
insert into gt values (1, null, 7, 0), (2, 1, 7, 0), (3, 1, 7, 0), (4, 2, 7, 0),
  (11, null, 8, 0), (12, 11, 8, 0), (13, 12, 8, 0), (21, null, 9, 0), (22, 21, 9, 0);
create index i_gt on gt (grp, pid);
create table gx (id int, pid int, grp int, x int);
insert into gx select * from gt;
create index i_gx on gx (grp, x, pid);
update statistics on gt, gx with fullscan;

--@queryplan
select /*+ recompile */ id, level lv from gt start with pid is null and grp = 7 connect by prior id = pid and grp = 7 order siblings by id;
--@queryplan
select /*+ recompile */ id, level lv from gt start with pid is null and grp in (7, 8) connect by prior id = pid and grp in (7, 8) order siblings by id;
--@queryplan
select /*+ recompile */ id, level lv from gt start with pid is null and grp in (7, 8) connect by prior id = pid and (grp = 7 or grp = 8) order siblings by id;
--@queryplan
select /*+ recompile */ id, level lv from gx start with pid is null and grp = 7 connect by prior id = pid and grp = 7 order siblings by id;

drop table tc_pk;
drop table tj;
drop table tj2;
drop table tj3;
drop table m3;
drop table tn;
drop table tn4;
drop table tt1;
drop table tt2;
drop table tt3;
drop table t1row;
drop table gt;
drop table gx;
