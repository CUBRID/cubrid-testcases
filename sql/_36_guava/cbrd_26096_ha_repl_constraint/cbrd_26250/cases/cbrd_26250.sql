-- This test case verifies CBRD-26250 issue - REPLICATION option behavior
-- 
-- Test Overview:
-- This test verifies REPLICATION option behavior for tables with different key constraints.
-- Tests CREATE TABLE with default/ON/OFF options, ALTER TABLE state changes, and data operations.
-- Verifies that default replication setting is ON when not specified.
-- Tests various key constraint types: no key, PRIMARY KEY, NOT NULL UNIQUE, and UNIQUE only.
--
-- Test Scenarios:
-- 1. CREATE TABLE with different replication options (default/ON/OFF) for each constraint type
-- 2. ALTER TABLE to change replication state (default->OFF, ON->OFF, OFF->ON)
-- 3. ALTER TABLE duplicate changes (ON->ON, OFF->OFF) for stability verification
-- 4. Data operations (INSERT/SELECT) to verify DML behavior

DROP TABLE IF EXISTS no_rk_default;
DROP TABLE IF EXISTS no_rk_on;
DROP TABLE IF EXISTS no_rk_off;
DROP TABLE IF EXISTS pk_default;
DROP TABLE IF EXISTS pk_on;
DROP TABLE IF EXISTS pk_off;
DROP TABLE IF EXISTS nn_uk_default;
DROP TABLE IF EXISTS nn_uk_on;
DROP TABLE IF EXISTS nn_uk_off;
DROP TABLE IF EXISTS uk_default;
DROP TABLE IF EXISTS uk_on;
DROP TABLE IF EXISTS uk_off;

-- 1. CREATE TABLE (with different replication options and key constraints)
CREATE TABLE no_rk_default(a INT);
CREATE TABLE no_rk_on(a INT) REPLICATION ON;
CREATE TABLE no_rk_off(a INT) REPLICATION OFF;

CREATE TABLE pk_default(a INT PRIMARY KEY);
CREATE TABLE pk_on(a INT PRIMARY KEY) REPLICATION ON;
CREATE TABLE pk_off(a INT PRIMARY KEY) REPLICATION OFF;

CREATE TABLE nn_uk_default(a INT NOT NULL UNIQUE);
CREATE TABLE nn_uk_on(a INT NOT NULL UNIQUE) REPLICATION ON;
CREATE TABLE nn_uk_off(a INT NOT NULL UNIQUE) REPLICATION OFF;

CREATE TABLE uk_default(a INT UNIQUE);
CREATE TABLE uk_on(a INT UNIQUE) REPLICATION ON;
CREATE TABLE uk_off(a INT UNIQUE) REPLICATION OFF;

-- [Verification 1] Check state after CREATE (verify default is ON, etc.)
SELECT class_name, is_replication_class 
FROM db_class 
WHERE class_name IN ('no_rk_default', 'no_rk_on', 'no_rk_off', 'pk_default', 'pk_on', 'pk_off', 'nn_uk_default', 'nn_uk_on', 'nn_uk_off', 'uk_default', 'uk_on', 'uk_off')
ORDER BY class_name;

-- 2. ALTER TABLE
-- default -> OFF / ON -> OFF / OFF -> ON
ALTER TABLE no_rk_default REPLICATION=OFF;
ALTER TABLE no_rk_on REPLICATION=OFF;
ALTER TABLE no_rk_off REPLICATION=ON;

ALTER TABLE pk_default REPLICATION=OFF;
ALTER TABLE pk_on REPLICATION=OFF;
ALTER TABLE pk_off REPLICATION=ON;

ALTER TABLE nn_uk_default REPLICATION=OFF;
ALTER TABLE nn_uk_on REPLICATION=OFF;
ALTER TABLE nn_uk_off REPLICATION=ON;

ALTER TABLE uk_default REPLICATION=OFF;
ALTER TABLE uk_on REPLICATION=OFF;
ALTER TABLE uk_off REPLICATION=ON;

-- [Verification 2] Check state after ALTER (state reversal)
SELECT class_name, is_replication_class 
FROM db_class 
WHERE class_name IN ('no_rk_default', 'no_rk_on', 'no_rk_off', 'pk_default', 'pk_on', 'pk_off', 'nn_uk_default', 'nn_uk_on', 'nn_uk_off', 'uk_default', 'uk_on', 'uk_off')
ORDER BY class_name;

-- 3. ALTER TABLE duplicate changes (ON->ON, OFF->OFF) stability verification
-- Should not cause errors and maintain state
ALTER TABLE no_rk_off REPLICATION=ON;  -- Already ON, set to ON again
ALTER TABLE pk_default REPLICATION=OFF; -- Already OFF, set to OFF again
ALTER TABLE nn_uk_default REPLICATION=OFF; -- Already OFF, set to OFF again
ALTER TABLE uk_default REPLICATION=OFF; -- Already OFF, set to OFF again

-- [Verification 3] Check state after duplicate changes
SELECT class_name, is_replication_class 
FROM db_class 
WHERE class_name IN ('no_rk_off', 'pk_default', 'nn_uk_default', 'uk_default')
ORDER BY class_name;

-- 4. Data replication verification (Single mode DML operations)
INSERT INTO no_rk_default VALUES (1);
INSERT INTO no_rk_on VALUES (2);
INSERT INTO no_rk_off VALUES (3);

INSERT INTO pk_default VALUES (10);
INSERT INTO pk_on VALUES (20);
INSERT INTO pk_off VALUES (30);

INSERT INTO nn_uk_default VALUES (100);
INSERT INTO nn_uk_on VALUES (200);
INSERT INTO nn_uk_off VALUES (300);

INSERT INTO uk_default VALUES (1000);
INSERT INTO uk_on VALUES (2000);
INSERT INTO uk_off VALUES (3000);

-- [Verification 4] Check state after data replication
SELECT 'no_rk_default' AS tb_name, a FROM no_rk_default ORDER BY a;
SELECT 'no_rk_on' AS tb_name, a FROM no_rk_on ORDER BY a;
SELECT 'no_rk_off' AS tb_name, a FROM no_rk_off ORDER BY a;

SELECT 'pk_default' AS tb_name, a FROM pk_default ORDER BY a;
SELECT 'pk_on' AS tb_name, a FROM pk_on ORDER BY a;
SELECT 'pk_off' AS tb_name, a FROM pk_off ORDER BY a;

SELECT 'nn_uk_default' AS tb_name, a FROM nn_uk_default ORDER BY a;
SELECT 'nn_uk_on' AS tb_name, a FROM nn_uk_on ORDER BY a;
SELECT 'nn_uk_off' AS tb_name, a FROM nn_uk_off ORDER BY a;

SELECT 'uk_default' AS tb_name, a FROM uk_default ORDER BY a;
SELECT 'uk_on' AS tb_name, a FROM uk_on ORDER BY a;
SELECT 'uk_off' AS tb_name, a FROM uk_off ORDER BY a;

DROP TABLE IF EXISTS no_rk_default;
DROP TABLE IF EXISTS no_rk_on;
DROP TABLE IF EXISTS no_rk_off;
DROP TABLE IF EXISTS pk_default;
DROP TABLE IF EXISTS pk_on;
DROP TABLE IF EXISTS pk_off;
DROP TABLE IF EXISTS nn_uk_default;
DROP TABLE IF EXISTS nn_uk_on;
DROP TABLE IF EXISTS nn_uk_off;
DROP TABLE IF EXISTS uk_default;
DROP TABLE IF EXISTS uk_on;
DROP TABLE IF EXISTS uk_off;

