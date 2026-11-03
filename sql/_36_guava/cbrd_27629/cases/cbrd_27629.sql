/**
 *  This test case verifies CBRD-27629: collation names are accepted in any letter case, as charset
 *  names already are.
 *
 *  lang_get_collation_by_name compared names with strcmp, so COLLATE utf8_bin worked but
 *  COLLATE UTF8_BIN failed with Unknown collation 'UTF8_BIN'. The fix (engine PR #8162) compares
 *  them with strcasecmp. The COLLATE modifier, column, table and CAST collations, SET NAMES and the
 *  intl_collation parameter all look names up through this function.
 *
 *  Each case checks that the name is accepted and that the named collation is applied: utf8_en_ci
 *  gives 'a' = 'A' and utf8_en_cs does not. The names are printed from the collation id, so
 *  collation(), SHOW CREATE TABLE and SHOW CREATE VIEW show the lowercase name. Only built-in
 *  collations are used, since LDML collations need a locale library.
 *
 *  Coverage:
 *    Case 1:  the reported query, COLLATE modifier with an upper case, quoted and mixed case name
 *    Case 2:  the collation named in upper case is applied to the comparison
 *    Case 3:  column collations, the reported CREATE TABLE
 *    Case 4:  table collation in CREATE TABLE and ALTER TABLE, column collation in ALTER ... MODIFY
 *    Case 5:  CAST with CHARSET and COLLATE
 *    Case 6:  COLLATE in a view definition and in ORDER BY
 *    Case 7:  the intl_collation parameter
 *    Case 8:  SET NAMES ... COLLATE
 *    Case 9:  unknown names and charset mismatches still fail
 */

drop view if exists v1;
drop table if exists t1, t2;


evaluate 'Case 1: the reported query, COLLATE modifier with an upper case, quoted and mixed case name';
select collation ('a' collate utf8_bin);
select collation ('a' collate UTF8_BIN);
select collation ('a' collate 'UTF8_BIN');
select collation ('a' collate uTf8_bIn);


evaluate 'Case 2: the collation named in upper case is applied to the comparison';
select 'a' collate UTF8_EN_CI = 'A', 'a' collate UTF8_EN_CS = 'A', 'a' collate Utf8_En_Ci = 'A';


evaluate 'Case 3: column collations, the reported CREATE TABLE';
create table t1 (id int, c varchar(10) collate UTF8_EN_CI, d varchar(10) charset UTF8 collate Utf8_En_Cs);
insert into t1 values (1, 'a', 'a'), (2, 'A', 'A'), (3, 'b', 'b'), (4, 'B', 'B');
show create table t1;
select id from t1 where c = 'A' order by id;
select id from t1 where d = 'A' order by id;


evaluate 'Case 4: table collation in CREATE TABLE and ALTER TABLE, column collation in ALTER ... MODIFY';
create table t2 (c varchar(10)) collate UTF8_EN_CI;
show create table t2;
alter table t2 collate UTF8_BIN;
alter table t2 modify c varchar(10) collate UTF8_EN_CS;
show create table t2;


evaluate 'Case 5: CAST with CHARSET and COLLATE';
select collation (cast ('a' as varchar(10) charset utf8 collate UTF8_EN_CI));
select cast ('a' as varchar(10) charset utf8 collate UTF8_EN_CI) = 'A';


evaluate 'Case 6: COLLATE in a view definition and in ORDER BY';
create view v1 as select id, c collate UTF8_BIN as c from t1;
show create view v1;
select c from v1 where c = 'A';
select c from t1 order by c collate UTF8_BIN, id;


--+ holdcas on;
evaluate 'Case 7: the intl_collation parameter';
set system parameters 'intl_collation=UTF8_EN_CI';
select collation ('a');
select 'a' = 'A';
set system parameters 'intl_collation=default';
select collation ('a');


evaluate 'Case 8: SET NAMES ... COLLATE';
set names utf8 collate UTF8_EN_CI;
select collation ('a');
set names utf8;
select collation ('a');
--+ holdcas off;


evaluate 'Case 9: unknown names and charset mismatches still fail';
select 'a' collate UTF8_XX;
select cast ('a' as varchar(10) charset utf8 collate ISO88591_BIN);
create table t3 (c varchar(10) charset utf8 collate ISO88591_BIN);


drop view v1;
drop table t1, t2;
