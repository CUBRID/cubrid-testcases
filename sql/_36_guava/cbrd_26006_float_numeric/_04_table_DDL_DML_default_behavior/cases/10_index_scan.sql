/* 10. index scan */

-- ===========================================================================
-- Section 1: Index scan Float/Fixed NUMERIC as leading/trailing key
-- ===========================================================================
evaluate '1. Index scan: Float NUMERIC and Fixed NUMERIC as leading/trailing key';
DROP TABLE IF EXISTS ta;
DROP TABLE IF EXISTS tb;
DROP TABLE IF EXISTS tc;
DROP TABLE IF EXISTS td;
DROP TABLE IF EXISTS te;

evaluate '1-1. int, numeric';
CREATE TABLE ta (cola INT, colb NUMERIC);
CREATE INDEX idx_ta ON ta(cola, colb);
INSERT INTO ta VALUES (60,0.1);
SELECT * FROM ta where cola > 0;
SELECT * FROM ta where cola > 0 and colb > 0;


evaluate '1-2. int, numeric(4,0)';
create table tb (cola int, colb numeric(4,0));
CREATE INDEX idx_tb ON tb(cola, colb);
INSERT INTO tb VALUES (1,1234);
select * from tb where cola > 0;
SELECT * FROM tb where cola > 0 and colb > 0;


evaluate '1-3. numeric(4,0), int';
create table tc (cola numeric(4,0), colb int);
CREATE INDEX idx_tc ON tc(cola, colb);
INSERT INTO tc VALUES (1234,1);
select * from tc where cola > 0;
SELECT * FROM tc where cola > 0 and colb > 0;


evaluate '1-4. numeric, int';
create table td (cola numeric, colb int);
CREATE INDEX idx_td ON td(cola, colb);
INSERT INTO td VALUES (1234,1);
select * from td where cola > 0;
SELECT * FROM td where cola > 0 and colb > 0;


evaluate '1-5. numeric, numeric';
CREATE TABLE te (cola NUMERIC, colb NUMERIC);
CREATE INDEX idx_te ON te(cola, colb);
INSERT INTO te VALUES (1,123456789);
SELECT * FROM te where cola > 0;
SELECT * FROM te where cola > 0 and colb > 0;

DROP TABLE IF EXISTS ta;
DROP TABLE IF EXISTS tb;
DROP TABLE IF EXISTS tc;
DROP TABLE IF EXISTS td;
DROP TABLE IF EXISTS te;


-- ===========================================================================
-- Section 2: Equality scan and index-ordered retrieval
-- ===========================================================================
evaluate '2. Equality index scan and index-ordered retrieval on a NUMERIC key';
DROP TABLE IF EXISTS ta;
CREATE TABLE ta (cola NUMERIC, colb NUMERIC);
CREATE INDEX idx_ta ON ta(cola, colb);
INSERT INTO ta VALUES (10.5, 1), (2.25, 2), (100, 3), (0.001, 4);
SELECT * FROM ta WHERE cola = 2.25;
SELECT * FROM ta WHERE cola > 1 ORDER BY cola;
DROP TABLE IF EXISTS ta;


-- ===========================================================================
-- Section 3: Index scan on Float NUMERIC keys at extreme magnitudes
-- ===========================================================================
evaluate '3. Index scan on Float NUMERIC keys at extreme magnitudes';
DROP TABLE IF EXISTS tb;
CREATE TABLE tb (cola NUMERIC, colb NUMERIC);
CREATE INDEX idx_tb ON tb(cola, colb);
INSERT INTO tb VALUES
  (10000000000000000000000000000000000000000000000000, 1),
  (0.0000000000000000000000000000000000000000000000001, 2),
  (-10000000000000000000000000000000000000000000000000, 3);
SELECT * FROM tb WHERE cola > 0 ORDER BY cola;
DROP TABLE IF EXISTS tb;


-- ===========================================================================
-- Section 4: Index probe does not round the search key to the column scale
-- ===========================================================================
evaluate '4. Index probe does not round the search key to the column scale';
DROP TABLE IF EXISTS tc;
CREATE TABLE tc (cola NUMERIC(4,0), colb INT);
CREATE INDEX idx_tc ON tc(cola, colb);
INSERT INTO tc VALUES (1234, 1);
-- rounding applies only when storing a value, not when comparing
-- so the search key 1234.4 stays 1234.4 and does not match the stored 1234
SELECT * FROM tc WHERE cola = 1234.4;
SELECT * FROM tc WHERE cola = 1235;
DROP TABLE IF EXISTS tc;