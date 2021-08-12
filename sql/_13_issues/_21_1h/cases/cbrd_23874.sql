DROP TABLE IF EXISTS dec_tbl;

CREATE TABLE dec_tbl (a decimal(10,5));
PREPARE stmt from 'INSERT INTO dec_tbl VALUES (IFNULL(?,0))';
EXECUTE stmt USING 12.3456789;
SELECT a FROM dec_tbl;
DROP TABLE dec_tbl;

CREATE TABLE dec_tbl (a decimal(10,5));
PREPARE stmt from 'INSERT INTO dec_tbl VALUES (NVL(?,0))';
EXECUTE stmt USING 12.3456789;
SELECT a FROM dec_tbl;
DROP TABLE dec_tbl;

CREATE TABLE dec_tbl (a decimal(10,5));
PREPARE stmt from 'INSERT INTO dec_tbl VALUES (NVL2(?,?,0)), (NVL2(?,0,?))';
EXECUTE stmt USING 1,12.3456789,NULL,12.3456789;
SELECT a FROM dec_tbl;
DROP TABLE dec_tbl;

CREATE TABLE dec_tbl (a decimal(10,5));
PREPARE stmt from 'INSERT INTO dec_tbl VALUES (COALESCE(?,0))';
EXECUTE stmt USING 12.3456789;
SELECT a FROM dec_tbl;
DROP TABLE dec_tbl;

CREATE TABLE dec_tbl (a decimal(10,5));
PREPARE stmt from 'INSERT INTO dec_tbl VALUES (NULLIF(?,?))';
EXECUTE stmt USING 12.3456789,22.3456789;
SELECT a FROM dec_tbl;
DROP TABLE dec_tbl;

CREATE TABLE dec_tbl (a decimal(10,5));
PREPARE stmt from 'INSERT INTO dec_tbl VALUES (LEAST(?,?,?))';
EXECUTE stmt USING 12.3456789,22.3456789,32.3456789;
SELECT a FROM dec_tbl;
DROP TABLE dec_tbl;

CREATE TABLE dec_tbl (a decimal(10,5));
PREPARE stmt from 'INSERT INTO dec_tbl VALUES (GREATEST(?,?,?))';
EXECUTE stmt USING 12.3456789,22.3456789,32.3456789;
SELECT a FROM dec_tbl;
DROP TABLE dec_tbl;
