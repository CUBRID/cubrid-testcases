/**
 * This test case verifies CBRD-26891: Perform clear checks on length limits
 * for column, index, constraint, and partition names.
 *
 * Specification Change:
 * - Enforce a maximum identifier length of 254 bytes.
 * - Apply the length validation to column, index, constraint, and partition names.
 *   - column name: max 254 bytes
 *   - index name: max 254 bytes
 *   - constraint name: max 254 bytes
 *   - partition name: max 254 bytes
 *
 * Note: the limit is byte-based, so the character count at the boundary
 * depends on the database charset. CTP creates the test database as UTF-8,
 * so this verification is for UTF-8, where each Korean character is 3 bytes
 * (the multibyte cases below). Other charsets follow the same byte-based
 * rule and would be verified the same way, by counting bytes.
 *
 * Note: a 254-byte partition name is not tested yet. It currently fails with
 * Error:-1374 because the combined table and partition name must be less than
 * 223 bytes. This is a defect confirmed with the developer, and the case
 * will be added after it is fixed.
 *
 * Coverage:
 *   Case 1:  column name of 254 bytes succeeds
 *   Case 2:  column name of 255 bytes fails
 *   Case 3:  alter table change column - 254 bytes succeeds, 255 bytes fails
 *   Case 4:  alter table change column - 268 bytes, longer than the lexer cut, fails
 *   Case 5:  alter table rename column - 254 bytes succeeds, 255 bytes fails
 *   Case 6:  alter table add column - 254 bytes succeeds, 255 bytes fails
 *   Case 7:  view column name of 254 bytes succeeds
 *   Case 8:  view column name of 255 bytes fails
 *   Case 9:  index name of 254 bytes succeeds
 *   Case 10: index name of 255 bytes fails
 *   Case 11: alter table add index - 254 bytes succeeds, 255 bytes fails
 *   Case 12: create unique index - 254 bytes succeeds, 255 bytes fails
 *   Case 13: unique constraint name of 254 bytes succeeds
 *   Case 14: unique constraint name of 255 bytes fails
 *   Case 15: primary key constraint name - 254 bytes succeeds, 255 bytes fails
 *   Case 16: foreign key constraint name - 254 bytes succeeds, 255 bytes fails
 *   Case 17: alter table add constraint - 254 bytes succeeds, 255 bytes fails
 *   Case 18: short partition name succeeds, partition name of 255 bytes fails
 *   Case 19: Korean column name of 255 bytes fails
 *   Case 20: Korean column name of 252 bytes succeeds
 *   Case 21: mixed ASCII and Korean column name of 254 bytes succeeds
 *   Case 22: double-quoted identifier - 254 bytes succeeds, 255 bytes fails
 *   Case 23: backtick identifier - 254 bytes succeeds, 255 bytes fails
 *   Case 24: bracket identifier - 254 bytes succeeds, 255 bytes fails
 *   Case 25: qualified column reference - 254 bytes succeeds, 255 bytes fails
 */

evaluate 'Case 1: column name exactly 254 bytes - should succeed';
drop table if exists tbl;
create table tbl (c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z int);
select attr_name, char_length(attr_name), octet_length(attr_name) from db_attribute where class_name = 'tbl';

evaluate 'Case 2: column name 255 bytes - should error';
drop table if exists tbl;
create table tbl (c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x int);

evaluate 'Case 3: alter table change column 254 bytes succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl (col1 int, col2 int);
alter table tbl change column col1 c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z int;
alter table tbl change column col2 c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x int;
select attr_name, octet_length(attr_name) from db_attribute where class_name = 'tbl' order by def_order;

-- 268 bytes, not 255: Case 3 already covers 255. The lexer cuts a name of
-- 265 bytes or more to 265 bytes (DB_MAX_IDENTIFIER_LENGTH + 10), so only a
-- longer name takes that path, and the cut name must still fail.
evaluate 'Case 4: alter table change column 268 bytes - should error';
drop table if exists tbl;
create table tbl (col1 int);
alter table tbl change column col1 c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c________________z int;
select attr_name from db_attribute where class_name = 'tbl';

evaluate 'Case 5: alter table rename column 254 bytes succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl (col1 int, col2 int);
alter table tbl rename column col1 as c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z;
alter table tbl rename column col2 as c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x;
select attr_name, octet_length(attr_name) from db_attribute where class_name = 'tbl' order by def_order;

evaluate 'Case 6: alter table add column 254 bytes succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl (id int);
alter table tbl add column c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z int;
alter table tbl add column c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x int;
select attr_name, octet_length(attr_name) from db_attribute where class_name = 'tbl' order by def_order;

evaluate 'Case 7: view column name exactly 254 bytes - should succeed';
drop view if exists v;
drop table if exists tbl;
create table tbl (id int);
create view v (c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z) as select id from tbl;
select attr_name, char_length(attr_name), octet_length(attr_name) from db_attribute where class_name = 'v';

-- Case 8 reuses tbl created in Case 7
evaluate 'Case 8: view column name 255 bytes - should error';
drop view if exists v;
create view v (c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x) as select id from tbl;
select count(*) from db_class where class_name = 'v';

evaluate 'Case 9: index name exactly 254 bytes - should succeed';
drop table if exists tbl;
create table tbl (id int);
create index i_______10i_______20i_______30i_______40i_______50i_______60i_______70i_______80i_______90i______100i______110i______120i______130i______140i______150i______160i______170i______180i______190i______200i______210i______220i______230i______240i______250i__z on tbl(id);
select index_name, char_length(index_name), octet_length(index_name) from db_index where class_name = 'tbl';

evaluate 'Case 10: index name 255 bytes - should error';
drop table if exists tbl;
create table tbl (id int);
create index i_______10i_______20i_______30i_______40i_______50i_______60i_______70i_______80i_______90i______100i______110i______120i______130i______140i______150i______160i______170i______180i______190i______200i______210i______220i______230i______240i______250i___x on tbl(id);
select count(*) from db_index where class_name = 'tbl';

evaluate 'Case 11: alter table add index 254 bytes succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl (id int);
alter table tbl add index i_______10i_______20i_______30i_______40i_______50i_______60i_______70i_______80i_______90i______100i______110i______120i______130i______140i______150i______160i______170i______180i______190i______200i______210i______220i______230i______240i______250i__z (id);
alter table tbl add index i_______10i_______20i_______30i_______40i_______50i_______60i_______70i_______80i_______90i______100i______110i______120i______130i______140i______150i______160i______170i______180i______190i______200i______210i______220i______230i______240i______250i___x (id);
select index_name, octet_length(index_name) from db_index where class_name = 'tbl' order by index_name;

evaluate 'Case 12: create unique index 254 bytes succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl (id int);
create unique index i_______10i_______20i_______30i_______40i_______50i_______60i_______70i_______80i_______90i______100i______110i______120i______130i______140i______150i______160i______170i______180i______190i______200i______210i______220i______230i______240i______250i__z on tbl(id);
create unique index i_______10i_______20i_______30i_______40i_______50i_______60i_______70i_______80i_______90i______100i______110i______120i______130i______140i______150i______160i______170i______180i______190i______200i______210i______220i______230i______240i______250i___x on tbl(id);
select index_name, is_unique, octet_length(index_name) from db_index where class_name = 'tbl' order by index_name;

evaluate 'Case 13: unique constraint name exactly 254 bytes - should succeed';
drop table if exists tbl;
create table tbl (id int, constraint c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z unique(id));
select index_name, char_length(index_name), octet_length(index_name) from db_index where class_name = 'tbl';

evaluate 'Case 14: unique constraint name 255 bytes - should error';
drop table if exists tbl;
create table tbl (id int, constraint c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x unique(id));

evaluate 'Case 15: primary key constraint name 254 bytes succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl (id int, constraint c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z primary key(id));
select index_name, is_primary_key, octet_length(index_name) from db_index where class_name = 'tbl';
drop table if exists tbl;
create table tbl (id int, constraint c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x primary key(id));

evaluate 'Case 16: foreign key constraint name 254 bytes succeeds, 255 bytes - should error';
drop table if exists fk_tbl, pk_tbl;
create table pk_tbl (id int primary key);
create table fk_tbl (pid int, constraint c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z foreign key(pid) references pk_tbl(id));
select index_name, is_foreign_key, octet_length(index_name) from db_index where class_name = 'fk_tbl';
drop table if exists fk_tbl;
create table fk_tbl (pid int, constraint c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x foreign key(pid) references pk_tbl(id));
drop table if exists fk_tbl, pk_tbl;

evaluate 'Case 17: alter table add constraint 254 bytes succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl (id int, col1 int);
alter table tbl add constraint c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z unique(id);
alter table tbl add constraint c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x unique(col1);
select index_name, octet_length(index_name) from db_index where class_name = 'tbl' order by index_name;

-- the short name shows the same statement is valid, so the 255-byte error
-- comes from the name length and not from the syntax
evaluate 'Case 18: short partition name succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl (col1 int, col2 int) partition by range (col2) (partition p0 values less than (100));
select partition_name from db_partition where class_name = 'tbl';
drop table if exists tbl;
create table tbl (col1 int, col2 int) partition by range (col2) (partition p_______10p_______20p_______30p_______40p_______50p_______60p_______70p_______80p_______90p______100p______110p______120p______130p______140p______150p______160p______170p______180p______190p______200p______210p______220p______230p______240p______250p___x values less than (100));

evaluate 'Case 19: column name with Korean chars 255 bytes - should error';
drop table if exists tbl;
create table tbl ("가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가" int);

evaluate 'Case 20: column name with Korean chars 252 bytes - should succeed';
drop table if exists tbl;
create table tbl ("가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하" int);
select attr_name, char_length(attr_name), octet_length(attr_name) from db_attribute where class_name = 'tbl';

evaluate 'Case 21: column name mixed ASCII and Korean exactly 254 bytes - should succeed';
drop table if exists tbl;
create table tbl ("ab가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하" int);
select attr_name, char_length(attr_name), octet_length(attr_name) from db_attribute where class_name = 'tbl';

evaluate 'Case 22: double-quoted identifier 254 bytes succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl ("c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z" int);
select attr_name, octet_length(attr_name) from db_attribute where class_name = 'tbl';
drop table if exists tbl;
create table tbl ("c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x" int);

evaluate 'Case 23: backtick identifier 254 bytes succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl (`c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z` int);
select attr_name, octet_length(attr_name) from db_attribute where class_name = 'tbl';
drop table if exists tbl;
create table tbl (`c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x` int);

evaluate 'Case 24: bracket identifier 254 bytes succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl ([c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z] int);
select attr_name, octet_length(attr_name) from db_attribute where class_name = 'tbl';
drop table if exists tbl;
create table tbl ([c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x] int);

-- the 255-byte reference starts with the 254-byte column name, which a build
-- without the fix silently cut to 254 bytes and resolved to that column
evaluate 'Case 25: qualified column reference 254 bytes succeeds, 255 bytes - should error';
drop table if exists tbl;
create table tbl (c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z int);
insert into tbl values (1);
select tbl.c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z from tbl;
select tbl.c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x from tbl;

drop view if exists v;
drop table if exists tbl;
