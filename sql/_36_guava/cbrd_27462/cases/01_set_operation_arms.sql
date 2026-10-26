/**
 *  This test case verifies CBRD-27462 (problem 1): INSERT ... SELECT into an
 *  updatable view whose source is a set operation, while the INSERT column list
 *  omits a view column that has a DEFAULT.
 *
 *  The omitted DEFAULT column is appended to the INSERT column list and its
 *  DEFAULT value to the select list of the source query. For a UNION, INTERSECT
 *  or EXCEPT source, the result of the right arm was stored into the left arm,
 *  so both arms became the right arm.
 *
 *  Every DEFAULT here is an INT literal or a clock expression, so this file does
 *  not depend on problem 2 (the column domain of the DEFAULT value).
 *  A view on a REUSE_OID table is not updatable, so the base tables use DONT_REUSE_OID.
 *
 *  Coverage:
 *    Case 1: UNION ALL of two table arms
 *    Case 2: set operations nested on both sides
 *    Case 3: UNION over three arms removes duplicates
 *    Case 4: INTERSECT
 *    Case 5: EXCEPT
 *    Case 6: three omitted DEFAULT columns, one of them an expression
 *    Case 7: base table with a primary key (the repeated last arm raised a unique violation)
 */

drop view if exists v1;
drop view if exists v2;
drop view if exists v3;
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists src1;
drop table if exists src2;

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


evaluate 'Case 2: set operations nested on both sides';
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


evaluate 'Case 6: three omitted DEFAULT columns, one of them an expression';
create table t2 (id int, d int default 5, ts datetime default sys_datetime, e int default 7) dont_reuse_oid;
create view v2 as select id, d, ts, e from t2;
insert into v2 (id) select id from src1 union all select id from src2;
select id, d, e, ts is not null from t2 order by id;


evaluate 'Case 7: base table with a primary key';
create table t3 (id int primary key, d int default 5) dont_reuse_oid;
create view v3 as select id, d from t3;
insert into v3 (id) select 9 union all select 10;
select id, d from t3 order by id;


drop view v1;
drop view v2;
drop view v3;
drop table t1;
drop table t2;
drop table t3;
drop table src1;
drop table src2;
