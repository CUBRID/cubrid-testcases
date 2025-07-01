/**
 *  This test case verifies CBRD-25708 : Enable partition pruning when the partition key is a function expression and the WHERE clause uses the original column
 *  This test specifically covers the cases of comparison operators: <, <=, >, >=
 */

DROP TABLE IF EXISTS year_tbl;
DROP TABLE IF EXISTS to_days_tbl;
DROP TABLE IF EXISTS unix_timestamp_tbl;
DROP TABLE IF EXISTS abs_tbl;

set trace on;

CREATE TABLE year_tbl(col DATETIME) PARTITION BY RANGE (YEAR(col)) (
        PARTITION pa VALUES LESS THAN (2019),
        PARTITION pb VALUES LESS THAN (2020),
        PARTITION pc VALUES LESS THAN (2021),
        PARTITION pd VALUES LESS THAN (2022),
        PARTITION pe VALUES LESS THAN (2023),
        PARTITION pf VALUES LESS THAN (2024),
        PARTITION p_max VALUES LESS THAN MAXVALUE
        );

INSERT INTO year_tbl VALUES('2024-01-01 23:23:59');

evaluate concat('1. YEAR, <');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col < '2023-01-01 23:23:59';
show trace;

evaluate concat('2. YEAR, <=');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col <= '2023-01-01 23:23:59';
show trace;

evaluate concat('3. YEAR, >=');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col >= '2023-01-01 23:23:59';
show trace;

evaluate concat('4. YEAR, >');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col > '2023-01-01 23:23:59';
show trace;

evaluate concat('1. YEAR, ALSM, <');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col < some{'2023-01-01 23:23:59'};
show trace;

evaluate concat('2. YEAR, ALSM, <=');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col <= some{'2023-01-01 23:23:59'};
show trace;

evaluate concat('3. YEAR, ALSM, >=');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col >= some{'2023-01-01 23:23:59'};
show trace;

evaluate concat('4. YEAR, ALSM, >');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col > some{'2023-01-01 23:23:59'};
show trace;

CREATE TABLE to_days_tbl(col DATETIME) PARTITION BY RANGE (TO_DAYS(col)) (
        PARTITION pa VALUES LESS THAN (375),
        PARTITION pb VALUES LESS THAN (376),
        PARTITION pc VALUES LESS THAN (377),
        PARTITION pd VALUES LESS THAN (378),
        PARTITION pe VALUES LESS THAN (379),
        PARTITION pf VALUES LESS THAN (380),
        PARTITION p_max VALUES LESS THAN MAXVALUE
        );

INSERT INTO to_days_tbl VALUES('1-1-12');

evaluate concat('1. TO_DAYS, <');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col < '1-1-12';
show trace;

evaluate concat('2. TO_DAYS, <=');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col <= '1-1-12';
show trace;

evaluate concat('3. TO_DAYS, >=');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col >= '1-1-12';
show trace;

evaluate concat('4. TO_DAYS, >');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col > '1-1-12';
show trace;

evaluate concat('1. TO_DAYS, ALSM, <');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col < some{'1-1-12'};
show trace;

evaluate concat('2. TO_DAYS, ALSM, <=');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col <= some{'1-1-12'};
show trace;

evaluate concat('3. TO_DAYS, ALSM, >=');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col >= some{'1-1-12'};
show trace;

evaluate concat('4. TO_DAYS, ALSM, >');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col > some{'1-1-12'};
show trace;


CREATE TABLE unix_timestamp_tbl(col DATETIME) PARTITION BY RANGE (UNIX_TIMESTAMP(col)) (
        PARTITION pa VALUES LESS THAN (54000),
        PARTITION pb VALUES LESS THAN (140400),
        PARTITION pc VALUES LESS THAN (226800),
        PARTITION pd VALUES LESS THAN (313200),
        PARTITION pe VALUES LESS THAN (399600),
        PARTITION pf VALUES LESS THAN (486000),
        PARTITION p_max VALUES LESS THAN MAXVALUE
        );
INSERT INTO unix_timestamp_tbl VALUES('1970-01-04 23:23:59');

evaluate concat('1. UNIX_TIMESTAMP, <');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col < '1970-01-04 23:23:59';
show trace;

evaluate concat('2. UNIX_TIMESTAMP, <=');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col <= '1970-01-04 23:23:59';
show trace;

evaluate concat('3. UNIX_TIMESTAMP, >=');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col >= '1970-01-04 23:23:59';
show trace;

evaluate concat('4. UNIX_TIMESTAMP, >');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col > '1970-01-04 23:23:59';
show trace;

evaluate concat('1. UNIX_TIMESTAMP, ALSM, <');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col < some{'1970-01-04 23:23:59'};
show trace;

evaluate concat('2. UNIX_TIMESTAMP, ALSM, <=');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col <= some{'1970-01-04 23:23:59'};
show trace;

evaluate concat('3. UNIX_TIMESTAMP, ALSM, >=');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col >= some{'1970-01-04 23:23:59'};
show trace;

evaluate concat('4. UNIX_TIMESTAMP, ALSM, >');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col > some{'1970-01-04 23:23:59'};
show trace;

CREATE TABLE abs_tbl(col INT) PARTITION BY LIST(ABS(col)) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO abs_tbl VALUES(-10);

--ABS() is non‐monotonic -> RANGE comparisons must NOT prune
evaluate concat('1. ABS, < (no pruning)');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col < 5;
show trace;

evaluate concat('2. ABS, <= (no pruning)');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col <= 5;
show trace;

evaluate concat('3. ABS, >= (no pruning)');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col >= 5;
show trace;

evaluate concat('4. ABS, > (no pruning)');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col > 5;
show trace;

evaluate concat('1. ABS, ALSM, < (no pruning)');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col < some{5};
show trace;

evaluate concat('2. ABS, ALSM, <= (no pruning)');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col <= some{5};
show trace;

evaluate concat('3. ABS, ALSM >= (no pruning)');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col >= some{5};
show trace;

evaluate concat('4. ABS, ALSM > (no pruning)');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col > some{5};
show trace;
set trace off;


DROP TABLE IF EXISTS year_tbl;
DROP TABLE IF EXISTS to_days_tbl;
DROP TABLE IF EXISTS unix_timestamp_tbl;
DROP TABLE IF EXISTS abs_tbl;
