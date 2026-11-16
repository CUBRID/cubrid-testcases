/**
 *  This test case verifies CBRD-27462: INSERT ... SELECT into an updatable view
 *  that omits a view column with a DEFAULT.
 *
 *  The omitted DEFAULT column is appended to the INSERT column list, and its
 *  DEFAULT value to the select list of the source query. Two defects broke this.
 *
 *  Problem 1 - for a UNION, INTERSECT or EXCEPT source, the result of the right arm
 *  was stored into the left arm, so both arms became the right arm. The fix appends
 *  the DEFAULT values to both arms, and the right arm gets its own copy of them.
 *  Cases 1 to 10 check it with INT and clock DEFAULTs, which do not depend on problem 2.
 *
 *  Problem 2 - the DEFAULT value node was given an empty data type, which dropped
 *  the precision, scale and length of the value. A NUMERIC DEFAULT then arrived as
 *  NULL, and a BIT(n) DEFAULT reached the server with an uninitialized length and
 *  crashed it. The fix keeps the data type of the value, takes the column domain
 *  when the value has none (ENUM, DEFAULT expression, empty collection), and uses a
 *  bare data type when even the column domain has no element type.
 *  Cases 11 to 14 check it with a single SELECT source, which does not depend on problem 1.
 *
 *  Cases 15 and 16 check both together. Case 16 is last because it crashed the server.
 *  A view on a REUSE_OID table is not updatable, so the base tables use DONT_REUSE_OID.
 *
 *  Coverage:
 *    Case 1:  UNION ALL of two table arms keeps both arms
 *    Case 2:  set operations nested on both sides keep every arm
 *    Case 3:  UNION over three arms removes duplicates
 *    Case 4:  INTERSECT keeps only the rows common to both arms
 *    Case 5:  EXCEPT removes the rows of the second arm from the first
 *    Case 6:  ORDER BY and LIMIT of the set operation see the rows of both arms
 *    Case 7:  three omitted DEFAULT columns, one of them an expression
 *    Case 8:  base table with a primary key takes both arms without a unique violation
 *    Case 9:  REPLACE with a set operation source keeps both arms
 *    Case 10: INSERT ON DUPLICATE KEY UPDATE with a set operation source updates the rows of the first arm
 *    Case 11: the DEFAULT value keeps its own data type (NUMERIC, NUMERIC(p,s), CHAR(n), typed SET)
 *    Case 12: the column domain is used when the value has none (ENUM, DEFAULT expressions, empty typed SET)
 *    Case 13: empty collections declared without element types
 *    Case 14: a NOT NULL NUMERIC DEFAULT column takes its DEFAULT
 *    Case 15: both arms of a set operation source keep the data type of the DEFAULT values
 *    Case 16: BIT(n) DEFAULT with a single SELECT and a set operation source, then a query that needs the server
 */

drop view if exists v1, v2, v3, v4, v5, v6, v7, v8, v9;
drop table if exists t1, t2, t3, t4, t5, t6, t7, t8, t9;
drop table if exists src1, src2;

create table src1 (id int);
insert into src1 values (1), (2), (3);
create table src2 (id int);
insert into src2 values (7), (8);

create table t1 (id int, d int default 5) dont_reuse_oid;
create view v1 as select id, d from t1;


evaluate 'Case 1: UNION ALL of two table arms keeps both arms';
insert into v1 (id) select id from src1 union all select id from src2;
select id, d from t1 order by id;
delete from t1;


evaluate 'Case 2: set operations nested on both sides keep every arm';
insert into v1 (id) (select 1 union all select 2) union all (select 3 union all select 4);
select id, d from t1 order by id;
delete from t1;


evaluate 'Case 3: UNION over three arms removes duplicates';
insert into v1 (id) select id from src1 union select 2 union select id from src2;
select id, d from t1 order by id;
delete from t1;


evaluate 'Case 4: INTERSECT keeps only the rows common to both arms';
insert into v1 (id) select 2 intersect select id from src1;
select id, d from t1 order by id;
delete from t1;


evaluate 'Case 5: EXCEPT removes the rows of the second arm from the first';
insert into v1 (id) select id from src1 except select 2;
select id, d from t1 order by id;
delete from t1;


-- the three largest ids come from both arms: 8 and 7 from src2, 3 from src1
evaluate 'Case 6: ORDER BY and LIMIT of the set operation see the rows of both arms';
insert into v1 (id) select id from src1 union all select id from src2 order by 1 desc limit 3;
select id, d from t1 order by id;
delete from t1;


evaluate 'Case 7: three omitted DEFAULT columns, one of them an expression';
create table t2 (id int, d int default 5, ts datetime default sys_datetime, e int default 7) dont_reuse_oid;
create view v2 as select id, d, ts, e from t2;
insert into v2 (id) select id from src1 union all select id from src2;
select id, d, e, ts is not null from t2 order by id;


evaluate 'Case 8: base table with a primary key takes both arms without a unique violation';
create table t3 (id int primary key, d int default 5) dont_reuse_oid;
create view v3 as select id, d from t3;
insert into v3 (id) select 9 union all select 10;
select id, d from t3 order by id;
delete from t3;


evaluate 'Case 9: REPLACE with a set operation source keeps both arms';
replace into v3 (id) select id from src1 union all select id from src2;
select id, d from t3 order by id;


-- Case 10 runs on the rows 1, 2, 3, 7 and 8 that Case 9 left in t3
evaluate 'Case 10: INSERT ON DUPLICATE KEY UPDATE with a set operation source updates the rows of the first arm';
insert into v3 (id) select id from src1 union all select 9 on duplicate key update d = 6;
select id, d from t3 order by id;


evaluate 'Case 11: the DEFAULT value keeps its own data type (NUMERIC, NUMERIC(p,s), CHAR(n), typed SET)';
create table t4 (
  id int,
  n1 numeric default 5,
  n2 numeric(10,2) default -1.25,
  c char(5) default 'ab',
  s set(int) default {1, 2}
) dont_reuse_oid;
create view v4 as select id, n1, n2, c, s from t4;
insert into v4 (id) select id from src1;
select id, n1, n2, c, s from t4 order by id;


-- Cases 12 and 13 print the same rows without the fix: they guard the paths where the fix takes the column domain or a bare data type
evaluate 'Case 12: the column domain is used when the value has none (ENUM, DEFAULT expressions, empty typed SET)';
create table t5 (
  id int,
  e enum('aa', 'bb') default 'bb',
  ts datetime default sys_datetime,
  f varchar(10) default to_char(sys_date, 'YYYY-MM-DD'),
  es set(int) default {}
) dont_reuse_oid;
create view v5 as select id, e, ts, f, es from t5;
insert into v5 (id) select id from src1;
select id, e, ts is not null, f like '____-__-__', es from t5 order by id;


evaluate 'Case 13: empty collections declared without element types';
create table t6 (
  id int,
  u1 set default {},
  u2 multiset default {},
  u3 sequence default {}
) dont_reuse_oid;
create view v6 as select id, u1, u2, u3 from t6;
insert into v6 (id) select id from src1;
select id, u1, u2, u3 from t6 order by id;


-- without the fix the NUMERIC DEFAULT arrives as NULL, and this INSERT fails on the NOT NULL constraint
evaluate 'Case 14: a NOT NULL NUMERIC DEFAULT column takes its DEFAULT';
create table t7 (id int, n numeric not null default 5) dont_reuse_oid;
create view v7 as select id, n from t7;
insert into v7 (id) select id from src1;
select id, n from t7 order by id;


evaluate 'Case 15: both arms of a set operation source keep the data type of the DEFAULT values';
create table t8 (
  id int,
  n1 numeric default 5,
  n2 numeric(10,2) default -1.25,
  c char(5) default 'ab',
  s set(int) default {1, 2},
  u set default {}
) dont_reuse_oid;
create view v8 as select id, n1, n2, c, s, u from t8;
insert into v8 (id) select id from src1 union select id from src2;
select id, n1, n2, c, s, u from t8 order by id;


evaluate 'Case 16: BIT(n) DEFAULT with a single SELECT and a set operation source, then a query that needs the server';
create table t9 (id int, b bit(8) default B'10101010') dont_reuse_oid;
create view v9 as select id, b from t9;
insert into v9 (id) select id from src1;
insert into v9 (id) select id from src2 union all select 9;
select id, hex(b) from t9 order by id;
select count(*) from src1;


drop view v1, v2, v3, v4, v5, v6, v7, v8, v9;
drop table t1, t2, t3, t4, t5, t6, t7, t8, t9;
drop table src1, src2;
