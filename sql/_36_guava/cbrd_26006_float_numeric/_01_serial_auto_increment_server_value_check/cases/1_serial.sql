/* 1. Verify SERIAL values */

--Basic SERIAL create and NEXT_VALUE
DROP SERIAL IF EXISTS s1;
CREATE SERIAL s1;
SELECT unique_name, current_val, increment_val, max_val, min_val, start_val, cyclic, started, cached_num FROM _db_serial WHERE unique_name = 'dba.s1';

SELECT s1.NEXT_VALUE;
SELECT unique_name, current_val, increment_val, max_val, min_val, start_val, cyclic, started, cached_num FROM _db_serial WHERE unique_name = 'dba.s1';


-- ===========================================================================
-- Section 1:START WITH / INCREMENT BY / MINVALUE / MAXVALUE range check
-- ===========================================================================
evaluate '1-1. START WITH (error)';
-- Expect error when the value is out of the supported range (±10^38)
ALTER SERIAL s1 START WITH 100000000000000000000000000000000000000;
ALTER SERIAL s1 START WITH -100000000000000000000000000000000000000;

CREATE SERIAL s2 START WITH 100000000000000000000000000000000000000;
CREATE SERIAL s2 START WITH -100000000000000000000000000000000000000;


evaluate '1-2. INCREMENT BY (error)';
-- Expect error when the increment is out of the supported range (±10^38)
ALTER SERIAL s1 INCREMENT BY 100000000000000000000000000000000000000;
ALTER SERIAL s1 INCREMENT BY -100000000000000000000000000000000000000;

CREATE SERIAL s2 INCREMENT BY 100000000000000000000000000000000000000;
CREATE SERIAL s2 INCREMENT BY -100000000000000000000000000000000000000;


evaluate '1-3. MINVALUE (error)';
-- Expect error when MINVALUE is out of the supported range (±10^38)
ALTER SERIAL s1 MINVALUE 100000000000000000000000000000000000000;
ALTER SERIAL s1 MINVALUE -100000000000000000000000000000000000000;

CREATE SERIAL s2 MINVALUE 100000000000000000000000000000000000000;
CREATE SERIAL s2 MINVALUE -100000000000000000000000000000000000000;


evaluate '1-4. MAXVALUE (error)';
-- Expect error when MAXVALUE is out of the supported range (±10^38)
ALTER SERIAL s1 MAXVALUE 100000000000000000000000000000000000000;
ALTER SERIAL s1 MAXVALUE -100000000000000000000000000000000000000;

CREATE SERIAL s2 MAXVALUE 100000000000000000000000000000000000000;
CREATE SERIAL s2 MAXVALUE -100000000000000000000000000000000000000;


-- ===========================================================================
-- Section 2: CACHE
-- ===========================================================================
evaluate '2. CACHE';
-- Verify cached serial value in db_serial catalog
ALTER SERIAL s1 CACHE 5;
SELECT unique_name, cached_num FROM _db_serial WHERE unique_name = 'dba.s1';

DROP SERIAL IF EXISTS s1;

SELECT unique_name, current_val, increment_val, max_val, min_val, start_val, cyclic, started, cached_num FROM _db_serial WHERE unique_name = 'dba.s1';
