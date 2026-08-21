-- ============================================
-- CBRD-26891
-- Enforce strict identifier length validation (max 254 bytes)
-- Previously, column/index/constraint/partition names exceeding 254 bytes
-- were silently truncated. Now they produce an error.
-- Also validates length after lowercase conversion for multi-byte (UTF-8).
-- ============================================

-- ============================================
-- Case 1: Column name at exactly 254 bytes (boundary - should succeed)
-- ============================================
evaluate 'Case 1: column name exactly 254 bytes - should succeed';
drop table if exists tbl;
create table tbl (c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c__z int);
select attr_name, char_length(attr_name), length(attr_name) from db_attribute where class_name = 'tbl';
drop table tbl;

-- ============================================
-- Case 2: Column name exceeding 254 bytes (should error)
-- ============================================
evaluate 'Case 2: column name exceeding 254 bytes - should error';
drop table if exists tbl;
/* err */ create table tbl (c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx int);

-- ============================================
-- Case 3: ALTER TABLE CHANGE column name exceeding 254 bytes (should error)
-- ============================================
evaluate 'Case 3: alter table change column name exceeding 254 bytes - should error';
drop table if exists tbl;
create table tbl (col1 int);
/* err */ alter table tbl change column col1 c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx int;
drop table tbl;

-- ============================================
-- Case 4: Index name at exactly 254 bytes (boundary - should succeed)
-- ============================================
evaluate 'Case 4: index name exactly 254 bytes - should succeed';
drop table if exists tbl;
create table tbl (id int);
create index i_______10i_______20i_______30i_______40i_______50i_______60i_______70i_______80i_______90i______100i______110i______120i______130i______140i______150i______160i______170i______180i______190i______200i______210i______220i______230i______240i______250i__z on tbl(id);
select index_name, char_length(index_name), length(index_name) from db_index where class_name = 'tbl' and index_name not like 'pk_%';
drop table tbl;

-- ============================================
-- Case 5: Index name exceeding 254 bytes (should error)
-- ============================================
evaluate 'Case 5: index name exceeding 254 bytes - should error';
drop table if exists tbl;
create table tbl (id int);
/* err */ create index i_______10i_______20i_______30i_______40i_______50i_______60i_______70i_______80i_______90i______100i______110i______120i______130i______140i______150i______160i______170i______180i______190i______200i______210i______220i______230i______240i______250i___xx on tbl(id);
drop table tbl;

-- ============================================
-- Case 6: Constraint name exceeding 254 bytes (should error)
-- ============================================
evaluate 'Case 6: constraint name exceeding 254 bytes - should error';
drop table if exists tbl;
/* err */ create table tbl (id int, constraint c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx unique(id));

-- ============================================
-- Case 7: Partition name exceeding 254 bytes (should error)
-- ============================================
evaluate 'Case 7: partition name exceeding 254 bytes - should error';
drop table if exists tbl;
/* err */ create table tbl (col1 int, col2 int) partition by range (col2) (partition p_______10p_______20p_______30p_______40p_______50p_______60p_______70p_______80p_______90p______100p______110p______120p______130p______140p______150p______160p______170p______180p______190p______200p______210p______220p______230p______240p______250p___xx values less than (100));

-- ============================================
-- Case 8: Column name with UTF-8 (Korean) characters exceeding 254 bytes
-- 85 Korean chars x 3 bytes = 255 bytes > 254 limit (should error)
-- ============================================
evaluate 'Case 8: column name with Korean chars exceeding 254 bytes - should error';
drop table if exists tbl;
/* err */ create table tbl ("가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가" int);

-- ============================================
-- Case 9: Column name with Korean chars at boundary (84 chars x 3 = 252 bytes, should succeed)
-- ============================================
evaluate 'Case 9: column name with Korean chars at boundary (252 bytes) - should succeed';
drop table if exists tbl;
create table tbl ("가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하" int);
select attr_name, char_length(attr_name), length(attr_name) from db_attribute where class_name = 'tbl';
drop table tbl;

-- ============================================
-- Case 10: Index name with UTF-8 (Korean) characters exceeding 254 bytes (should error)
-- ============================================
evaluate 'Case 10: index name with Korean chars exceeding 254 bytes - should error';
drop table if exists tbl;
create table tbl (id int);
/* err */ create index "가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가" on tbl(id);
drop table tbl;

-- ============================================
-- Case 11: Delimited identifier (double-quoted) exceeding 254 bytes (should error)
-- ============================================
evaluate 'Case 11: delimited identifier exceeding 254 bytes - should error';
drop table if exists tbl;
/* err */ create table tbl ("c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx" int);

-- ============================================
-- Case 12: Backtick delimited identifier exceeding 254 bytes (should error)
-- ============================================
evaluate 'Case 12: backtick delimited identifier exceeding 254 bytes - should error';
drop table if exists tbl;
/* err */ create table tbl (`c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx` int);

-- ============================================
-- Case 13: Bracket delimited identifier exceeding 254 bytes (should error)
-- ============================================
evaluate 'Case 13: bracket delimited identifier exceeding 254 bytes - should error';
drop table if exists tbl;
/* err */ create table tbl ([c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx] int);

-- ============================================
-- Case 14: ADD COLUMN with name exceeding 254 bytes (should error)
-- ============================================
evaluate 'Case 14: add column with name exceeding 254 bytes - should error';
drop table if exists tbl;
create table tbl (id int);
/* err */ alter table tbl add column c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx int;
drop table tbl;

-- ============================================
-- Case 15: Multiple columns - one valid, one exceeding limit (should error)
-- ============================================
evaluate 'Case 15: multiple columns with one exceeding limit - should error';
drop table if exists tbl;
/* err */ create table tbl (valid_col int, c_______10c_______20c_______30c_______40c_______50c_______60c_______70c_______80c_______90c______100c______110c______120c______130c______140c______150c______160c______170c______180c______190c______200c______210c______220c______230c______240c______250c___xx int);

-- ============================================
-- Cleanup
-- ============================================
drop table if exists tbl;
