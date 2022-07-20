/*
 * This is a test case to verify the CBRD-24424 issue.
 *
 * No core dump should occur when executing the queries below.
 *   - SHOW [ALL] HEAP HEADER OF <table_name>
 *   - SHOW [ALL] HEAP CAPACITY OF <table_name>
 *   - SHOW INDEX HEADER OF <table_name> DOT <index_name>
 *   - SHOW ALL INDEXES HEADER OF <table_name>
 *   - SHOW INDEX CAPACITY OF <table_name> DOT <index_name>
 *   - SHOW ALL INDEXES CAPACITY OF <table_name>
 *   - SHOW [FULL] COLUMNS {FROM | IN} <table_name> [LIKE '<pattern>' | WHERE <expr>]
 *   - DESC[RIBE]/EXPLAIN <table_name>
 *   - SHOW CREATE TABLE <table_name>
 *   - SHOW CREATE VIEW <view_name>
 *   - SHOW {INDEX | INDEXES | KEYS} {FROM | IN} <table_name>
 *
 * We do not test for optional keywords available here.
 *   - [ALL], [FULL], [LIKE '<pattern>' | WHERE <expr>]
 *
 * For keywords that can be used selectively among several, only one of them is tested.
 *   - {FROM | IN}, {INDEX | INDEXES | KEYS}, DESC[RIBE]/EXPLAIN
 * 
 */

/*
 * AS-IS:
 *   - Segmentation fault (core dumped)
 *
 * TO-BE: (Current)
 *   - ERROR: before ' ; '
 *     It is not allowed to specify an owner in the system class name.
 */
show heap header of dba._db_class;
show heap capacity of dba._db_class;
show index header of dba._db_class.i__db_class_unique_name;
show all indexes header of dba._db_class;
show index capacity of dba._db_class.i__db_class_unique_name;
show all indexes capacity of dba._db_class;
show columns from dba._db_class;
desc dba._db_class;
show create table dba._db_class;
show create view dba.db_class;
show index from dba._db_class;

/*
 * AS-IS:
 *   - Segmentation fault (core dumped)
 *
 * TO-BE: (Current)
 *   - ERROR: before ...
 *     User name [________10________20________30________40] not allowed. It cannot exceed 32 bytes.
 */
show heap header of ________10________20________30________40.t1;
show heap capacity of ________10________20________30________40.t1;
show index header of ________10________20________30________40.t1.i1;
show all indexes header of ________10________20________30________40.t1;
show index capacity of ________10________20________30________40.t1.i1;
show all indexes capacity of ________10________20________30________40.t1;
show columns from ________10________20________30________40.t1;
desc ________10________20________30________40.t1;
show create table ________10________20________30________40.t1;
show create view ________10________20________30________40.t1;
show index from ________10________20________30________40.t1;

/*
 * AS-IS:
 *   - Segmentation fault (core dumped)
 *
 * TO-BE: (Current)
 *   - ERROR: before ...
 *     Object name [u1.[________10________20________30________40________50______...] not allowed. It cannot exceed 223 bytes.
 */
show heap header of u1.________10________20________30________40________50________60________70________80________90_______100_______110_______120_______130_______140_______150_______160_______170_______180_______190_______200_______210_______220_______230;
show heap capacity of u1.________10________20________30________40________50________60________70________80________90_______100_______110_______120_______130_______140_______150_______160_______170_______180_______190_______200_______210_______220_______230;
show index header of u1.________10________20________30________40________50________60________70________80________90_______100_______110_______120_______130_______140_______150_______160_______170_______180_______190_______200_______210_______220_______230.i1;
show all indexes header of u1.________10________20________30________40________50________60________70________80________90_______100_______110_______120_______130_______140_______150_______160_______170_______180_______190_______200_______210_______220_______230;
show index capacity of u1.________10________20________30________40________50________60________70________80________90_______100_______110_______120_______130_______140_______150_______160_______170_______180_______190_______200_______210_______220_______230.i1;
show all indexes capacity of u1.________10________20________30________40________50________60________70________80________90_______100_______110_______120_______130_______140_______150_______160_______170_______180_______190_______200_______210_______220_______230;
show columns from u1.________10________20________30________40________50________60________70________80________90_______100_______110_______120_______130_______140_______150_______160_______170_______180_______190_______200_______210_______220_______230;
desc u1.________10________20________30________40________50________60________70________80________90_______100_______110_______120_______130_______140_______150_______160_______170_______180_______190_______200_______210_______220_______230;
show create table u1.________10________20________30________40________50________60________70________80________90_______100_______110_______120_______130_______140_______150_______160_______170_______180_______190_______200_______210_______220_______230;
show create view u1.________10________20________30________40________50________60________70________80________90_______100_______110_______120_______130_______140_______150_______160_______170_______180_______190_______200_______210_______220_______230;
show index from u1.________10________20________30________40________50________60________70________80________90_______100_______110_______120_______130_______140_______150_______160_______170_______180_______190_______200_______210_______220_______230;
