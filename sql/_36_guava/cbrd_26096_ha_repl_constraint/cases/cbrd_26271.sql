-- CBRD-26271
-- This test verifies replication option inheritance for partitioned tables.
-- It checks that child partitions (including newly added partitions) keep the parent's REPLICATION ON/OFF setting,
-- and validates both metadata (is_replication_class) and basic data behavior (INSERT/SELECT).

-- 1: CREATE TABLE PARTITION. Replication option inherited by child partitions (REPLICATION ON)
-- ha_repl result: child partitions inherit parent's REPLICATION ON
evaluate '1. create_partition_repl_on';
drop table if exists t_part_repl_on;
CREATE TABLE t_part_repl_on (
    host_year INT PRIMARY KEY,
    nation CHAR(3),
    val varchar(10)
)REPLICATION ON
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 't_part_repl_on%' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_part_repl_on VALUES (1999, 'USA', 'test1');
SELECT * FROM t_part_repl_on ORDER BY 1;
drop table if exists t_part_repl_on;

-- 2: ALTER TABLE ADD PARTITION. Newly added partitions inherit replication option
-- ha_repl result: newly added partitions inherit parent's REPLICATION ON
evaluate '2. alter table add partition';
drop table if exists t_part_repl_on;
CREATE TABLE t_part_repl_on (
    host_year INT PRIMARY KEY,
    nation CHAR(3),
    val varchar(10)
)REPLICATION ON
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
ALTER TABLE t_part_repl_on ADD PARTITION (
    PARTITION before_2012 VALUES LESS THAN (2012),
    PARTITION last_one VALUES LESS THAN MAXVALUE
);
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 't_part_repl_on%' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_part_repl_on VALUES (2011, 'KOR', 'test2');
SELECT * FROM t_part_repl_on ORDER BY 1;

-- ha_repl result:
-- ALTER TABLE ... REPLICATION=OFF is blocked in HA mode (expected failure).
-- Replication option remains unchanged, and subsequent INSERT/SELECT is executed with original option.
evaluate '2-1. alter table repl on->off';
ALTER TABLE t_part_repl_on REPLICATION=OFF;
-- HA replication: master/slave data validation
INSERT INTO t_part_repl_on VALUES (2013, 'GER', 'test2-1');
SELECT * FROM t_part_repl_on ORDER BY 1;
drop table if exists t_part_repl_on;

-- 3: CREATE TABLE PARTITION with REPLICATION OFF. Child partitions inherit REPLICATION OFF
-- ha_repl result: child partitions inherit parent's REPLICATION OFF (no replication)
evaluate '3. create_partition_repl_off';
drop table if exists t_part_repl_off;
CREATE TABLE t_part_repl_off (
    host_year INT PRIMARY KEY,
    nation CHAR(3),
    val varchar(10)
) REPLICATION OFF
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class
WHERE class_name LIKE 't_part_repl_off%'
ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_part_repl_off VALUES (1999, 'USA', 'test3');
SELECT * FROM t_part_repl_off ORDER BY 1;

-- 4: ALTER TABLE ADD PARTITION. Newly added partitions inherit replication option
-- ha_repl result: newly added partitions inherit parent's REPLICATION OFF
evaluate '4. alter table add partition (repl off)';
ALTER TABLE t_part_repl_off ADD PARTITION (
    PARTITION before_2012 VALUES LESS THAN (2012),
    PARTITION last_one VALUES LESS THAN MAXVALUE
);
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 't_part_repl_off%' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_part_repl_off VALUES (2011, 'KOR', 'test4'); 
SELECT * FROM t_part_repl_off ORDER BY 1;

evaluate '4-1. alter table repl off->on';
-- ha_repl result:
-- ALTER TABLE ... REPLICATION=ON is blocked in HA mode (expected failure).
-- Replication option remains unchanged, and subsequent INSERT/SELECT is executed with original option.
ALTER TABLE t_part_repl_off REPLICATION=ON;
-- HA replication: master/slave data validation
INSERT INTO t_part_repl_off VALUES (2013, 'GER', 'test4-1');
SELECT * FROM t_part_repl_off ORDER BY 1;
drop table if exists t_part_repl_off;

-- 5: CREATE TABLE with LIST PARTITION. Child partitions inherit replication option (REPLICATION ON)
-- ha_repl result: child partitions inherit parent's REPLICATION ON
evaluate '5. create_list_partition_repl_on';
drop table if exists t_list_repl_on;
CREATE TABLE t_list_repl_on (
    event VARCHAR(30) PRIMARY KEY,
    name VARCHAR(40),
    val varchar(10)
)REPLICATION ON
PARTITION BY LIST (event) (
    PARTITION event1 VALUES IN ('Swimming', 'Athletics'),
    PARTITION event2 VALUES IN ('Judo', 'Boxing')
);
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 't_list_repl_on%' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_list_repl_on VALUES ('Swimming', 'Alice', 'test5'), ('Judo', 'Bob', 'test5');
SELECT * FROM t_list_repl_on ORDER BY 1;
drop table if exists t_list_repl_on;

-- 6: CREATE TABLE with LIST PARTITION and REPLICATION OFF. Child partitions inherit REPLICATION OFF
-- ha_repl result: child partitions inherit parent's REPLICATION OFF (no replication)
evaluate '6. create_list_partition_repl_off';
drop table if exists t_list_repl_off;
CREATE TABLE t_list_repl_off (
    event VARCHAR(30) PRIMARY KEY,
    name VARCHAR(40),
    val varchar(10)
)REPLICATION OFF
PARTITION BY LIST (event) (
    PARTITION event1 VALUES IN ('Swimming', 'Athletics'),
    PARTITION event2 VALUES IN ('Judo', 'Boxing')
);
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 't_list_repl_off%' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_list_repl_off VALUES ('Swimming', 'Alice', 'test6'), ('Judo', 'Bob', 'test6');
SELECT * FROM t_list_repl_off ORDER BY 1;
drop table if exists t_list_repl_off;

-- 7: CREATE TABLE with HASH PARTITION. Child partitions inherit replication option (REPLICATION ON)
-- ha_repl result: parent and all 4 hash partition children inherit REPLICATION ON
evaluate '7. create_hash_partition_repl_on';
drop table if exists t_hash_repl_on;
CREATE TABLE t_hash_repl_on (
    code CHAR(3) PRIMARY KEY,
    name VARCHAR(50),
    val varchar(10)
)REPLICATION ON
PARTITION BY HASH (code) PARTITIONS 4;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 't_hash_repl_on%' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_hash_repl_on VALUES ('001', 'hash_on_1', 'test7'), ('002', 'hash_on_2', 'test7');
SELECT * FROM t_hash_repl_on ORDER BY 1;
drop table if exists t_hash_repl_on;

-- 8: CREATE TABLE with HASH PARTITION and REPLICATION OFF. Child partitions inherit REPLICATION OFF
-- ha_repl result: child partitions inherit parent's REPLICATION OFF (no replication)
evaluate '8. create_hash_partition_repl_off';
drop table if exists t_hash_repl_off;
CREATE TABLE t_hash_repl_off (
    code CHAR(3) PRIMARY KEY,
    name VARCHAR(50),
    val varchar(10)
)REPLICATION OFF
PARTITION BY HASH (code) PARTITIONS 4;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 't_hash_repl_off%' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_hash_repl_off VALUES ('001', 'hash_off_1', 'test8'), ('002', 'hash_off_2', 'test8');
SELECT * FROM t_hash_repl_off ORDER BY 1;
drop table if exists t_hash_repl_off;

-- 9: REORGANIZE PARTITION. Replication option preserved after reorganization
-- ha_repl result: reorganized partitions inherit parent's REPLICATION ON
evaluate '9. reorganize_partition_repl';
drop table if exists t_reorg_repl;
CREATE TABLE t_reorg_repl (
    host_year INT PRIMARY KEY,
    val varchar(10)
)REPLICATION ON
PARTITION BY RANGE (host_year) (
    PARTITION p_old VALUES LESS THAN (2010)
);
ALTER TABLE t_reorg_repl REORGANIZE PARTITION p_old INTO (
    PARTITION p_2000 VALUES LESS THAN (2000),
    PARTITION p_2010 VALUES LESS THAN (2010)
);
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 't_reorg_repl%' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_reorg_repl VALUES (1998, 'test9'),(2007, 'test9');
SELECT * FROM t_reorg_repl ORDER BY 1;
drop table if exists t_reorg_repl;

-- 10: REORGANIZE PARTITION with REPLICATION OFF. Replication option preserved after reorganization
-- ha_repl result: reorganized partitions inherit parent's REPLICATION OFF (no replication)
evaluate '10. reorganize_partition_repl_off';
drop table if exists t_reorg_repl_off;
CREATE TABLE t_reorg_repl_off (
    host_year INT PRIMARY KEY,
    val varchar(10)
)REPLICATION OFF
PARTITION BY RANGE (host_year) (
    PARTITION p_old VALUES LESS THAN (2010)
);
ALTER TABLE t_reorg_repl_off REORGANIZE PARTITION p_old INTO (
    PARTITION p_2000 VALUES LESS THAN (2000),
    PARTITION p_2010 VALUES LESS THAN (2010)
);
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 't_reorg_repl_off%' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_reorg_repl_off VALUES (1998, 'test10'),(2007, 'test10');
SELECT * FROM t_reorg_repl_off ORDER BY 1;
drop table if exists t_reorg_repl_off;

-- 11: REMOVE PARTITIONING. Replication option preserved after removing partitions
-- ha_repl result: table retains REPLICATION ON after converting to non-partitioned table
evaluate '11. remove_partitioning_repl';
drop table if exists t_remove_part_repl;
CREATE TABLE t_remove_part_repl (
    host_year INT PRIMARY KEY,
    val varchar(10)
)REPLICATION ON
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
ALTER TABLE t_remove_part_repl REMOVE PARTITIONING;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name = 't_remove_part_repl' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_remove_part_repl VALUES (1999, 'test11'), (2006, 'test11');
SELECT * FROM t_remove_part_repl ORDER BY 1;
drop table if exists t_remove_part_repl;

-- 12: REMOVE PARTITIONING with REPLICATION OFF. Replication option preserved after removing partitions
-- ha_repl result: table retains REPLICATION OFF after converting to non-partitioned table
evaluate '12. remove_partitioning_repl_off';
drop table if exists t_remove_part_repl_off;
CREATE TABLE t_remove_part_repl_off (
    host_year INT PRIMARY KEY,
    val varchar(10)
)REPLICATION OFF
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
ALTER TABLE t_remove_part_repl_off REMOVE PARTITIONING;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name = 't_remove_part_repl_off' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_remove_part_repl_off VALUES (1999, 'test12'), (2006, 'test12');
SELECT * FROM t_remove_part_repl_off ORDER BY 1;
drop table if exists t_remove_part_repl_off;

-- 13: DROP PARTITION. Remaining table/partitions retain replication option metadata
-- ha_repl result:
-- is_replication_class remains REPLICATION ON on remaining table/partitions after DROP PARTITION.
-- Data validation: INSERT/SELECT confirms remaining valid ranges are usable.
evaluate '13. drop_partition_repl';
drop table if exists t_drop_part_repl;
CREATE TABLE t_drop_part_repl (
    host_year INT PRIMARY KEY,
    val varchar(10)
)REPLICATION ON
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008),
    PARTITION before_2012 VALUES LESS THAN (2012)
);
ALTER TABLE t_drop_part_repl DROP PARTITION before_2000;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 't_drop_part_repl%' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_drop_part_repl VALUES (2001, 'test13'),(1997, 'test13'),(2009, 'test13');
SELECT * FROM t_drop_part_repl ORDER BY 1;
drop table if exists t_drop_part_repl;

-- 14: DROP PARTITION with REPLICATION OFF. Remaining table/partitions retain replication option metadata
-- ha_repl result:
-- is_replication_class remains REPLICATION OFF on remaining table/partitions after DROP PARTITION.
-- Data validation: INSERT/SELECT confirms remaining valid ranges are usable.
evaluate '14. drop_partition_repl_off';
drop table if exists t_drop_part_repl_off;
CREATE TABLE t_drop_part_repl_off (
    host_year INT PRIMARY KEY,
    val varchar(10)
)REPLICATION OFF
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008),
    PARTITION before_2012 VALUES LESS THAN (2012)
);
ALTER TABLE t_drop_part_repl_off DROP PARTITION before_2000;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 't_drop_part_repl_off%' ORDER BY 1;
-- HA replication: master/slave data validation
INSERT INTO t_drop_part_repl_off VALUES (2001, 'test14'),(1997, 'test14'),(2009, 'test14');
SELECT * FROM t_drop_part_repl_off ORDER BY 1;
drop table if exists t_drop_part_repl_off;
