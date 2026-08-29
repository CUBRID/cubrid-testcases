-- CBRD-26271 - PROMOTE PARTITION column attribute inheritance tests
-- Verifies that PK, NOT NULL, NOT NULL UNIQUE constraints are correctly
-- inherited by the promoted independent table after ALTER TABLE ... PROMOTE PARTITION

-- 1: PROMOTE partition from table with no PK (Single mode only)
-- HA mode does not allow such tables, so this test is only run in SINGLE mode
evaluate '1. promote_no_pk';
drop table if exists promote_no_pk;
CREATE TABLE promote_no_pk (
    host_year INT,
    nation CHAR(3),
    gold INT,
    silver INT,
    bronze INT,
    val varchar(10)
)REPLICATION ON
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
INSERT INTO promote_no_pk VALUES (1999, 'USA', 10, 20, 30, 'test1'), (2001, 'KOR', 11, 21, 31, 'test1');
ALTER TABLE promote_no_pk PROMOTE PARTITION before_2000;
-- Simple data validation
SELECT * FROM promote_no_pk ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_no_pk%' ORDER BY 1;
SELECT class_name, index_name FROM db_index WHERE class_name LIKE 'promote_no_pk%' ORDER BY 1;
drop table if exists promote_no_pk;
drop table if exists promote_no_pk__p__before_2000;

-- 2: REPLICATION OFF variant of 1 (no PK)
evaluate '2. promote_no_pk_off';
drop table if exists promote_no_pk_off;
CREATE TABLE promote_no_pk_off (
    host_year INT,
    nation CHAR(3),
    gold INT,
    silver INT,
    bronze INT,
    val varchar(10)
)REPLICATION OFF
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
INSERT INTO promote_no_pk_off VALUES (1999, 'USA', 10, 20, 30, 'test2'), (2001, 'KOR', 11, 21, 31, 'test2');
ALTER TABLE promote_no_pk_off PROMOTE PARTITION before_2000;
-- Simple data validation
SELECT * FROM promote_no_pk_off ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_no_pk_off%' ORDER BY 1;
SELECT class_name, index_name FROM db_index WHERE class_name LIKE 'promote_no_pk_off%' ORDER BY 1;
drop table if exists promote_no_pk_off;
drop table if exists promote_no_pk_off__p__before_2000;

-- 3: PROMOTE partition from table with PRIMARY KEY. PK inherited
-- ha_repl result: data is replicated and metadata is promoted
evaluate '3. promote_with_pk';  
drop table if exists promote_with_pk;
CREATE TABLE promote_with_pk (
    host_year INT PRIMARY KEY,
    nation CHAR(3),
    gold INT,
    silver INT,
    bronze INT,
    val varchar(10)
)REPLICATION ON
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
INSERT INTO promote_with_pk VALUES (1999, 'USA', 10, 20, 30, 'test3'), (2001, 'KOR', 11, 21, 31, 'test3');
ALTER TABLE promote_with_pk PROMOTE PARTITION before_2000;
-- Simple data validation
SELECT * FROM promote_with_pk ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_with_pk%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_with_pk%' ORDER BY 1;

drop table if exists promote_with_pk;
drop table if exists promote_with_pk__p__before_2000;

-- 4: REPLICATION OFF variant of 3 (PRIMARY KEY)
-- ha_repl result: data is not replicated and metadata is promoted
evaluate '4. promote_with_pk_off';
drop table if exists promote_with_pk_off;
CREATE TABLE promote_with_pk_off (
    host_year INT PRIMARY KEY,
    nation CHAR(3),
    gold INT,
    silver INT,
    bronze INT,
    val varchar(10)
)REPLICATION OFF
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
INSERT INTO promote_with_pk_off VALUES (1999, 'USA', 10, 20, 30, 'test4'), (2001, 'KOR', 11, 21, 31, 'test4');
ALTER TABLE promote_with_pk_off PROMOTE PARTITION before_2000;
-- Simple data validation
SELECT * FROM promote_with_pk_off ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_with_pk_off%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_with_pk_off%' ORDER BY 1;
drop table if exists promote_with_pk_off;
drop table if exists promote_with_pk_off__p__before_2000;

-- 5: PROMOTE partition from table with NOT NULL UNIQUE. Constraint inherited
-- ha_repl result: success, data is replicated and metadata is promoted
evaluate '5. promote_not_null_unique';
drop table if exists promote_not_null_unique;
CREATE TABLE promote_not_null_unique (
    host_year INT NOT NULL UNIQUE,
    nation CHAR(3),
    gold INT,
    silver INT,
    bronze INT,
    val varchar(10)
)REPLICATION ON
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
INSERT INTO promote_not_null_unique VALUES (1999, 'USA', 10, 20, 30, 'test5'), (2001, 'KOR', 11, 21, 31, 'test5');
ALTER TABLE promote_not_null_unique PROMOTE PARTITION before_2000;
-- Simple data validation
SELECT * FROM promote_not_null_unique ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_not_null_unique%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_not_null_unique%' ORDER BY 1;
drop table if exists promote_not_null_unique;
drop table if exists promote_not_null_unique__p__before_2000;

-- 6: REPLICATION OFF variant of 5 (NOT NULL UNIQUE)
-- ha_repl result: data is not replicated and metadata is promoted
evaluate '6. promote_not_null_unique_off';
drop table if exists promote_not_null_unique_off;
CREATE TABLE promote_not_null_unique_off (
    host_year INT NOT NULL UNIQUE,
    nation CHAR(3),
    gold INT,
    silver INT,
    bronze INT,
    val varchar(10)
)REPLICATION OFF
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
INSERT INTO promote_not_null_unique_off VALUES (1999, 'USA', 10, 20, 30, 'test6'), (2001, 'KOR', 11, 21, 31, 'test6');
ALTER TABLE promote_not_null_unique_off PROMOTE PARTITION before_2000;
-- Simple data validation
SELECT * FROM promote_not_null_unique_off ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_not_null_unique_off%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_not_null_unique_off%' ORDER BY 1;
drop table if exists promote_not_null_unique_off;
drop table if exists promote_not_null_unique_off__p__before_2000;

-- 7: PROMOTE partition from table with NOT NULL only (no UNIQUE). NOT NULL inherited, no index
-- ha_repl result: HA mode does not allow such tables, so this test is only run in SINGLE mode
evaluate '7. promote_not_null_only';
drop table if exists promote_not_null_only;
CREATE TABLE promote_not_null_only (
    host_year INT NOT NULL,
    nation CHAR(3),
    gold INT,
    silver INT,
    bronze INT,
    val varchar(10)
)REPLICATION ON
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
INSERT INTO promote_not_null_only VALUES (1999, 'USA', 10, 20, 30, 'test7'), (2001, 'KOR', 11, 21, 31, 'test7');
ALTER TABLE promote_not_null_only PROMOTE PARTITION before_2000;
-- Simple data validation
SELECT * FROM promote_not_null_only ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_not_null_only%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_not_null_only%' ORDER BY 1;
drop table if exists promote_not_null_only;
drop table if exists promote_not_null_only__p__before_2000;

-- 8: REPLICATION OFF variant of 7 (NOT NULL only)
-- ha_repl result: data is not replicated and metadata is promoted
evaluate '8. promote_not_null_only_off';
drop table if exists promote_not_null_only_off;
CREATE TABLE promote_not_null_only_off (
    host_year INT NOT NULL,
    nation CHAR(3),
    gold INT,
    silver INT,
    bronze INT,
    val varchar(10)
)REPLICATION OFF
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
INSERT INTO promote_not_null_only_off VALUES (1999, 'USA', 10, 20, 30, 'test8'), (2001, 'KOR', 11, 21, 31, 'test8');
ALTER TABLE promote_not_null_only_off PROMOTE PARTITION before_2000;
-- Simple data validation
SELECT * FROM promote_not_null_only_off ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_not_null_only_off%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_not_null_only_off%' ORDER BY 1;
drop table if exists promote_not_null_only_off;
drop table if exists promote_not_null_only_off__p__before_2000;

-- 9: PROMOTE partition from table with nullable UNIQUE. UNIQUE not inherited (not an RK)
-- ha_repl result: HA mode does not allow such tables, so this test is only run in SINGLE mode
evaluate '9. promote_nullable_unique';
drop table if exists promote_nullable_unique;
CREATE TABLE promote_nullable_unique (
    host_year INT UNIQUE,
    nation CHAR(3),
    gold INT,
    silver INT,
    bronze INT,
    val varchar(10)
)REPLICATION ON
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
INSERT INTO promote_nullable_unique VALUES (1999, 'USA', 10, 20, 30, 'test9'), (2001, 'KOR', 11, 21, 31, 'test9');
ALTER TABLE promote_nullable_unique PROMOTE PARTITION before_2000;
-- Simple data validation
SELECT * FROM promote_nullable_unique ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_nullable_unique%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_nullable_unique%' ORDER BY 1;
drop table if exists promote_nullable_unique;
drop table if exists promote_nullable_unique__p__before_2000;

-- 10: REPLICATION OFF variant of 9 (nullable UNIQUE)
-- ha_repl result: data is not replicated and metadata is promoted
evaluate '10. promote_nullable_unique_off';
drop table if exists promote_nullable_unique_off;
CREATE TABLE promote_nullable_unique_off (
    host_year INT UNIQUE,
    nation CHAR(3),
    gold INT,
    silver INT,
    bronze INT,
    val varchar(10)
)REPLICATION OFF
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
INSERT INTO promote_nullable_unique_off VALUES (1999, 'USA', 10, 20, 30, 'test10'), (2001, 'KOR', 11, 21, 31, 'test10');
ALTER TABLE promote_nullable_unique_off PROMOTE PARTITION before_2000;
-- Simple data validation
SELECT * FROM promote_nullable_unique_off ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_nullable_unique_off%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_nullable_unique_off%' ORDER BY 1;
drop table if exists promote_nullable_unique_off;
drop table if exists promote_nullable_unique_off__p__before_2000;

-- 11: PROMOTE partition from table with UNIQUE INDEX (not constraint). Index not inherited
-- ha_repl result: HA mode does not allow such tables, so this test is only run in SINGLE mode
evaluate '11. promote_unique_index';
drop table if exists promote_unique_index;
CREATE TABLE promote_unique_index (
    i INT,
    val varchar(10)
)REPLICATION ON
PARTITION BY LIST (i) (
    PARTITION p0 VALUES IN (1, 2),
    PARTITION p1 VALUES IN (3, 4)
);
CREATE UNIQUE INDEX idx_promote_unique_index ON promote_unique_index (i);
INSERT INTO promote_unique_index VALUES (1, 'test11'), (2, 'test11'), (3, 'test11'), (4, 'test11');
ALTER TABLE promote_unique_index PROMOTE PARTITION p1;
-- Simple data validation
SELECT * FROM promote_unique_index ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_unique_index%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_unique_index%' ORDER BY 1;
drop table if exists promote_unique_index;
drop table if exists promote_unique_index__p__p1;

-- 12: REPLICATION OFF variant of 11 (UNIQUE INDEX)
-- ha_repl result: data is not replicated and metadata is promoted
evaluate '12. promote_unique_index_off';
drop table if exists promote_unique_index_off;
CREATE TABLE promote_unique_index_off (
    i INT,
    val varchar(10)
)REPLICATION OFF
PARTITION BY LIST (i) (
    PARTITION p0 VALUES IN (1, 2),
    PARTITION p1 VALUES IN (3, 4)
);
CREATE UNIQUE INDEX idx_promote_unique_index_off ON promote_unique_index_off (i);
INSERT INTO promote_unique_index_off VALUES (1, 'test12'), (2, 'test12'), (3, 'test12'), (4, 'test12');
ALTER TABLE promote_unique_index_off PROMOTE PARTITION p1;
-- Simple data validation
SELECT * FROM promote_unique_index_off ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_unique_index_off%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_unique_index_off%' ORDER BY 1;
drop table if exists promote_unique_index_off;
drop table if exists promote_unique_index_off__p__p1;

-- 13: LIST PROMOTE. PK inherited (PROMOTE fix applies to LIST partition as well)
-- ha_repl result: data is replicated and metadata is promoted
evaluate '13. promote_list_pk';
drop table if exists promote_list_pk;
CREATE TABLE promote_list_pk (
    category VARCHAR(10) PRIMARY KEY,
    name VARCHAR(10),
    val varchar(10)
)REPLICATION ON
PARTITION BY LIST (category) (
    PARTITION cat_a VALUES IN ('A', 'B'),
    PARTITION cat_b VALUES IN ('C', 'D')
);
INSERT INTO promote_list_pk VALUES ('A', 'Alice', 'test13'), ('B', 'Bob', 'test13'), ('C', 'Charlie', 'test13');
ALTER TABLE promote_list_pk PROMOTE PARTITION cat_a;
-- Simple data validation
SELECT * FROM promote_list_pk ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_list_pk%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_list_pk%' ORDER BY 1;
drop table if exists promote_list_pk;
drop table if exists promote_list_pk__p__cat_a;

-- 14: REPLICATION OFF variant of 13 (LIST + PK)
-- ha_repl result: data is not replicated and metadata is promoted
evaluate '14. promote_list_pk_off';
drop table if exists promote_list_pk_off;
CREATE TABLE promote_list_pk_off (
    category VARCHAR(10) PRIMARY KEY,
    name VARCHAR(10),
    val varchar(10)
)REPLICATION OFF
PARTITION BY LIST (category) (
    PARTITION cat_a VALUES IN ('A', 'B'),
    PARTITION cat_b VALUES IN ('C', 'D')
);
INSERT INTO promote_list_pk_off VALUES ('A', 'Alice', 'test14'), ('B', 'Bob', 'test14'), ('C', 'Charlie', 'test14');
ALTER TABLE promote_list_pk_off PROMOTE PARTITION cat_a;
-- Simple data validation
SELECT * FROM promote_list_pk_off ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_list_pk_off%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_list_pk_off%' ORDER BY 1;
drop table if exists promote_list_pk_off;
drop table if exists promote_list_pk_off__p__cat_a;

-- 15-16: Single-server SQL only. ha_repl tooling can mangle composite-PK DDL; HA coverage lives in ha_shell.
-- 15: PROMOTE from table with composite PK. All composite PK columns inherited with NOT NULL
-- ha_repl: N/A here (see note above)
evaluate '15. promote_composite_pk';
drop table if exists promote_composite_pk;
CREATE TABLE promote_composite_pk (
    host_year INT,
    nation CHAR(3),
    gold INT,
    val varchar(10),
    PRIMARY KEY (host_year, nation)
)REPLICATION ON
PARTITION BY RANGE (host_year) (
    PARTITION p_old VALUES LESS THAN (2000),
    PARTITION p_new VALUES LESS THAN (2010)
);
INSERT INTO promote_composite_pk VALUES (1999, 'USA', 10, 'test15'), (2001, 'KOR', 11, 'test15');
ALTER TABLE promote_composite_pk PROMOTE PARTITION p_old;
-- Simple data validation
SELECT * FROM promote_composite_pk ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_composite_pk%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_composite_pk%' ORDER BY 1;
drop table if exists promote_composite_pk;
drop table if exists promote_composite_pk__p__p_old;

-- 16: REPLICATION OFF variant of 15 (composite PK)
-- ha_repl: N/A here (see note above)
evaluate '16. promote_composite_pk_off';
drop table if exists promote_composite_pk_off;
CREATE TABLE promote_composite_pk_off (
    host_year INT,
    nation CHAR(3),
    gold INT,
    val varchar(10),
    PRIMARY KEY (host_year, nation)
)REPLICATION OFF
PARTITION BY RANGE (host_year) (
    PARTITION p_old VALUES LESS THAN (2000),
    PARTITION p_new VALUES LESS THAN (2010)
);
INSERT INTO promote_composite_pk_off VALUES (1999, 'USA', 10, 'test16'), (2001, 'KOR', 11, 'test16');
ALTER TABLE promote_composite_pk_off PROMOTE PARTITION p_old;
-- Simple data validation
SELECT * FROM promote_composite_pk_off ORDER BY 1;
-- Metadata validation
SELECT class_name, is_replication_class FROM db_class WHERE class_name LIKE 'promote_composite_pk_off%' ORDER BY 1;
SELECT class_name, index_name, is_unique, is_primary_key FROM db_index WHERE class_name LIKE 'promote_composite_pk_off%' ORDER BY 1;
drop table if exists promote_composite_pk_off;
drop table if exists promote_composite_pk_off__p__p_old;
