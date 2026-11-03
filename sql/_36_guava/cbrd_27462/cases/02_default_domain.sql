/**
 *  This test case verifies CBRD-27462 (problem 2): the DEFAULT value supplied for
 *  an omitted column of an INSERT ... SELECT into an updatable view keeps the
 *  column domain.
 *
 *  The DEFAULT value node was given an empty data type, which dropped the
 *  precision, scale, codeset and collation of the value. A NUMERIC DEFAULT then
 *  arrived as NULL, and a BIT(n) DEFAULT reached the server with an uninitialized
 *  length and crashed it. The fix keeps the data type of the value, takes the
 *  column domain when the value has none (ENUM, DEFAULT expression, empty
 *  collection), and uses a bare data type when even the column domain has no
 *  element type (a collection declared without element types).
 *
 *  A view on a REUSE_OID table is not updatable, so the base tables use DONT_REUSE_OID.
 *
 *  Coverage:
 *    Case 1: the value carries its own data type: NUMERIC, NUMERIC(p,s), CHAR(n), typed SET
 *    Case 2: the value has none, the column domain is used: ENUM, DEFAULT expressions, empty typed SET
 *    Case 3: no element type anywhere: empty SET, MULTISET and SEQUENCE declared without element types
 *    Case 4: BIT(n), last because it crashed the server, followed by a query that needs the server
 */

drop view if exists v1;
drop view if exists v2;
drop view if exists v3;
drop view if exists v4;
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists src1;

create table src1 (id int);
insert into src1 values (1), (2);


evaluate 'Case 1: the DEFAULT value keeps its own data type (NUMERIC, CHAR, typed SET)';
create table t1 (
  id int,
  n1 numeric default 5,
  n2 numeric(10,2) default -1.25,
  c char(5) default 'ab',
  s set(int) default {1, 2}
) dont_reuse_oid;
create view v1 as select id, n1, n2, c, s from t1;
insert into v1 (id) select id from src1;
select id, n1, n2, c, s from t1 order by id;


evaluate 'Case 2: the column domain is used when the value has none (ENUM, DEFAULT expressions, empty typed SET)';
create table t2 (
  id int,
  e enum('aa', 'bb') default 'bb',
  ts datetime default sys_datetime,
  f varchar(10) default to_char(sys_date, 'YYYY-MM-DD'),
  es set(int) default {}
) dont_reuse_oid;
create view v2 as select id, e, ts, f, es from t2;
insert into v2 (id) select id from src1;
select id, e, ts is not null, f like '____-__-__', es from t2 order by id;


evaluate 'Case 3: empty collections declared without element types';
create table t3 (
  id int,
  u1 set default {},
  u2 multiset default {},
  u3 sequence default {}
) dont_reuse_oid;
create view v3 as select id, u1, u2, u3 from t3;
insert into v3 (id) select id from src1;
select id, u1, u2, u3 from t3 order by id;


evaluate 'Case 4: BIT(n) DEFAULT, then a query that needs the server';
create table t4 (id int, b bit(8) default B'10101010') dont_reuse_oid;
create view v4 as select id, b from t4;
insert into v4 (id) select id from src1;
select id, hex(b) from t4 order by id;
select count(*) from src1;


drop view v1;
drop view v2;
drop view v3;
drop view v4;
drop table t1;
drop table t2;
drop table t3;
drop table t4;
drop table src1;
