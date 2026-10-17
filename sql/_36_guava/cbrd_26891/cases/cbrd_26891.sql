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
 *
 * Note: the limit is byte-based, so the character count at the boundary
 * depends on the database charset. CTP creates the test database as UTF-8,
 * so this verification is for UTF-8, where each Korean character is 3 bytes
 * (the multibyte cases below). Other charsets follow the same byte-based
 * rule and would be verified the same way, by counting bytes.
 */

evaluate 'Case 1: column name exactly 254 bytes - should succeed';
drop table if exists tbl;
create table tbl (c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z int);
select attr_name, char_length(attr_name), octet_length(attr_name) from db_attribute where class_name = 'tbl';

evaluate 'Case 2: column name 255 bytes - should error';
drop table if exists tbl;
create table tbl (c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___x int);

evaluate 'Case 3: column name 256 bytes - should error';
drop table if exists tbl;
create table tbl (c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx int);

evaluate 'Case 4: alter table change column name exceeding 254 bytes - should error';
drop table if exists tbl;
create table tbl (col1 int);
alter table tbl change column col1 c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx int;
select attr_name from db_attribute where class_name = 'tbl';

evaluate 'Case 5: alter table rename column exceeding 254 bytes - should error';
drop table if exists tbl;
create table tbl (col1 int);
alter table tbl rename column col1 as c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx;
select attr_name from db_attribute where class_name = 'tbl';

evaluate 'Case 6: index name exactly 254 bytes - should succeed';
drop table if exists tbl;
create table tbl (id int);
create index i_______10i_______20i_______30i_______40i_______50i_______60i_______70i_______80i_______90i______100i______110i______120i______130i______140i______150i______160i______170i______180i______190i______200i______210i______220i______230i______240i______250i__z on tbl(id);
select index_name, char_length(index_name), octet_length(index_name) from db_index where class_name = 'tbl' and index_name not like 'pk_%';

evaluate 'Case 7: index name 255 bytes - should error';
drop table if exists tbl;
create table tbl (id int);
create index i_______10i_______20i_______30i_______40i_______50i_______60i_______70i_______80i_______90i______100i______110i______120i______130i______140i______150i______160i______170i______180i______190i______200i______210i______220i______230i______240i______250i___x on tbl(id);

evaluate 'Case 8: index name 256 bytes - should error';
drop table if exists tbl;
create table tbl (id int);
create index i_______10i_______20i_______30i_______40i_______50i_______60i_______70i_______80i_______90i______100i______110i______120i______130i______140i______150i______160i______170i______180i______190i______200i______210i______220i______230i______240i______250i___xx on tbl(id);

evaluate 'Case 9: constraint name exactly 254 bytes - should succeed';
drop table if exists tbl;
create table tbl (id int, constraint c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z unique(id));
select index_name, char_length(index_name), octet_length(index_name) from db_index where class_name = 'tbl';

evaluate 'Case 10: constraint name exceeding 254 bytes - should error';
drop table if exists tbl;
create table tbl (id int, constraint c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx unique(id));

evaluate 'Case 11: partition name 256 bytes - should error';
drop table if exists tbl;
create table tbl (col1 int, col2 int) partition by range (col2) (partition p_______10p_______20p_______30p_______40p_______50p_______60p_______70p_______80p_______90p______100p______110p______120p______130p______140p______150p______160p______170p______180p______190p______200p______210p______220p______230p______240p______250p_____ values less than (100));

evaluate 'Case 11-1: partition name 255 bytes - should error';
drop table if exists tbl;
create table tbl (col1 int, col2 int) partition by range (col2) (partition p_______10p_______20p_______30p_______40p_______50p_______60p_______70p_______80p_______90p______100p______110p______120p______130p______140p______150p______160p______170p______180p______190p______200p______210p______220p______230p______240p______250p____ values less than (100));

evaluate 'Case 12: column name with Korean chars 255 bytes - should error';
drop table if exists tbl;
create table tbl ("가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가" int);

evaluate 'Case 13: column name with Korean chars 252 bytes - should succeed';
drop table if exists tbl;
create table tbl ("가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하" int);
select attr_name, char_length(attr_name), octet_length(attr_name) from db_attribute where class_name = 'tbl';

evaluate 'Case 14: column name mixed ASCII and Korean exactly 254 bytes - should succeed';
drop table if exists tbl;
create table tbl ("ab가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하" int);
select attr_name, char_length(attr_name), octet_length(attr_name) from db_attribute where class_name = 'tbl';

evaluate 'Case 15: index name with Korean chars 255 bytes - should error';
drop table if exists tbl;
create table tbl (id int);
create index "가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가" on tbl(id);

evaluate 'Case 16: double-quoted identifier exceeding 254 bytes - should error';
drop table if exists tbl;
create table tbl ("c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx" int);

evaluate 'Case 17: backtick identifier exceeding 254 bytes - should error';
drop table if exists tbl;
create table tbl (`c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx` int);

evaluate 'Case 18: bracket identifier exceeding 254 bytes - should error';
drop table if exists tbl;
create table tbl ([c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx] int);

evaluate 'Case 19: add column with name exceeding 254 bytes - should error';
drop table if exists tbl;
create table tbl (id int);
alter table tbl add column c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx int;
select attr_name from db_attribute where class_name = 'tbl';

evaluate 'Case 20: multiple columns with one exceeding limit - should error';
drop table if exists tbl;
create table tbl (valid_col int, c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx int);

drop table if exists tbl;
