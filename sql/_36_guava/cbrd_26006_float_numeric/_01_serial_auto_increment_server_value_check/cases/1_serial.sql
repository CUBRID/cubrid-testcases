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
-- 39 digits
ALTER SERIAL s1 START WITH 100000000000000000000000000000000000000;
ALTER SERIAL s1 START WITH -100000000000000000000000000000000000000;

CREATE SERIAL s2 START WITH 100000000000000000000000000000000000000;
CREATE SERIAL s2 START WITH -100000000000000000000000000000000000000;


evaluate '1-2. INCREMENT BY (error)';
-- Expect error when the increment is out of the supported range (±10^38)
-- 39 digits
ALTER SERIAL s1 INCREMENT BY 100000000000000000000000000000000000000;
ALTER SERIAL s1 INCREMENT BY -100000000000000000000000000000000000000;

CREATE SERIAL s2 INCREMENT BY 100000000000000000000000000000000000000;
CREATE SERIAL s2 INCREMENT BY -100000000000000000000000000000000000000;


evaluate '1-3. MINVALUE (error)';
-- Expect error when MINVALUE is out of the supported range (±10^38)
-- 39 digits
ALTER SERIAL s1 MINVALUE 100000000000000000000000000000000000000;
ALTER SERIAL s1 MINVALUE -100000000000000000000000000000000000000;

CREATE SERIAL s2 MINVALUE 100000000000000000000000000000000000000;
CREATE SERIAL s2 MINVALUE -100000000000000000000000000000000000000;


evaluate '1-4. MAXVALUE (error)';
-- Expect error when MAXVALUE is out of the supported range (±10^38)
-- 39 digits
ALTER SERIAL s1 MAXVALUE 100000000000000000000000000000000000000;
ALTER SERIAL s1 MAXVALUE -100000000000000000000000000000000000000;

CREATE SERIAL s2 MAXVALUE 100000000000000000000000000000000000000;
CREATE SERIAL s2 MAXVALUE -100000000000000000000000000000000000000;


evaluate '1-5. NEXT_VALUE crossing the 38-digit max into 39 digits (error)';
-- Serial climbs to the 38-digit max via NEXT_VALUE, the next value would be 10^38 (39 digits) and overflow
DROP SERIAL IF EXISTS s_max;
CREATE SERIAL s_max START WITH 99999999999999999999999999999999999998 INCREMENT BY 1 MAXVALUE 99999999999999999999999999999999999999;
SELECT s_max.NEXT_VALUE;
SELECT s_max.NEXT_VALUE;
-- next value would be 10^38 (39 digits), expect overflow error (error)
SELECT s_max.NEXT_VALUE;
DROP SERIAL IF EXISTS s_max;


-- ===========================================================================
-- Section 2: CACHE
-- ===========================================================================
evaluate '2-1. CACHE basic (cached_num reflected in catalog)';
-- Verify cached serial value in db_serial catalog
ALTER SERIAL s1 CACHE 5;
SELECT unique_name, cached_num FROM _db_serial WHERE unique_name = 'dba.s1';

DROP SERIAL IF EXISTS s1;

SELECT unique_name, current_val, increment_val, max_val, min_val, start_val, cyclic, started, cached_num FROM _db_serial WHERE unique_name = 'dba.s1';


evaluate '2-2. CACHE reservation exceeds MAXVALUE under NOCYCLE (CREATE error)';
-- With NOCYCLE the cache reservation (start + cached_num x increment) must stay within max, else CREATE fails
DROP SERIAL IF EXISTS s_cache;
CREATE SERIAL s_cache START WITH 99999999999999999999999999999999999995
  INCREMENT BY 1 MAXVALUE 99999999999999999999999999999999999999 CACHE 5;
DROP SERIAL IF EXISTS s_cache;


evaluate '2-3. cached_num out-of-range (39-digit) (error)';
-- cached_num beyond the supported numeric range, expect the same validation as other parameters
DROP SERIAL IF EXISTS s_cache4;
CREATE SERIAL s_cache4;
ALTER SERIAL s_cache4 CACHE 100000000000000000000000000000000000000;
DROP SERIAL IF EXISTS s_cache4;


evaluate '2-4. CACHE + CYCLE wrap at MAXVALUE';
-- Cache batch spans the max to min cycle boundary, the value after max wraps to minvalue
DROP SERIAL IF EXISTS s_cache5;
CREATE SERIAL s_cache5 START WITH 99999999999999999999999999999999999998
  INCREMENT BY 1 MAXVALUE 99999999999999999999999999999999999999 MINVALUE 1 CACHE 3 CYCLE;
SELECT s_cache5.NEXT_VALUE;
SELECT s_cache5.NEXT_VALUE;
-- wraps to MINVALUE (1)
SELECT s_cache5.NEXT_VALUE;
DROP SERIAL IF EXISTS s_cache5;
