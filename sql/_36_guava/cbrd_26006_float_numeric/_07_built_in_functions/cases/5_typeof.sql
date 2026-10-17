/* 5. Verify TYPEOF behavior */

-- ===========================================================================
-- Section 1: Fixed Numeric
-- ===========================================================================
evaluate '1. Fixed Numeric';
DROP TABLE IF EXISTS t_typeof_fixed_numeric;
DROP TABLE IF EXISTS t_typeof_fixed_numeric2;
DROP TABLE IF EXISTS t_typeof_fixed_numeric3;
CREATE TABLE t_typeof_fixed_numeric (
  a NUMERIC(38,0)
);

INSERT INTO t_typeof_fixed_numeric VALUES (12345678901234567890123456789012345678);

SELECT a, TYPEOF(a) FROM t_typeof_fixed_numeric;

DROP TABLE IF EXISTS t_typeof_fixed_numeric;


DROP TABLE IF EXISTS t_typeof_fixed_numeric2;
CREATE TABLE t_typeof_fixed_numeric2 (
  a NUMERIC(38,-84)
);

INSERT INTO t_typeof_fixed_numeric2 VALUES (12345678901234567890123456789012345678000000000000000000000000000000000000000000000000000000000000000000000000000000000000);

SELECT a, TYPEOF(a) FROM t_typeof_fixed_numeric2;

DROP TABLE IF EXISTS t_typeof_fixed_numeric2;


DROP TABLE IF EXISTS t_typeof_fixed_numeric3;
CREATE TABLE t_typeof_fixed_numeric3 (
  a NUMERIC(38,127)
);

INSERT INTO t_typeof_fixed_numeric3 VALUES (0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678);

SELECT a, TYPEOF(a) FROM t_typeof_fixed_numeric3;

DROP TABLE IF EXISTS t_typeof_fixed_numeric3;



-- ===========================================================================
-- Section 2: Float Numeric
-- ===========================================================================
evaluate '2. Float Numeric';
SELECT TYPEOF(12345678901234567890);

SELECT TYPEOF((99999998000000000000000000000000000000000000000) + (88888888888888888888888888888888888888));

SELECT (0.0000000000000000000999999999999999999999999999999999999980
      + 0.0000000000000000000000000000000000000000000019),
       TYPEOF(0.0000000000000000000999999999999999999999999999999999999980
            + 0.0000000000000000000000000000000000000000000019);


-- ===========================================================================
-- Section 3: Literal type boundaries
-- ===========================================================================
evaluate '3. Literal type boundaries';
SELECT TYPEOF(5);                     -- integer
SELECT TYPEOF(2147483648);            -- bigint (above INT max)
SELECT TYPEOF(9223372036854775807);   -- bigint (BIGINT max)
SELECT TYPEOF(9223372036854775808);   -- numeric (above BIGINT max, becomes Float NUMERIC)
SELECT TYPEOF(1.5);                   -- numeric (bare decimal is Float NUMERIC)
SELECT TYPEOF(1.5e3);                 -- double (e-notation)


-- ===========================================================================
-- Section 4: CAST yields Fixed NUMERIC(p,s), bare decimal stays Float
-- ===========================================================================
evaluate '4. CAST yields Fixed NUMERIC(p,s), bare stays Float';
SELECT TYPEOF(CAST(1.5 AS NUMERIC(10,2)));   -- numeric (10, 2)
SELECT TYPEOF(CAST(1 AS NUMERIC(1,-84)));    -- numeric (1, -84)
SELECT TYPEOF(1.5);                          -- numeric (Float, for contrast)


DROP TABLE IF EXISTS t_typeof_fixed_numeric;
DROP TABLE IF EXISTS t_typeof_fixed_numeric2;
DROP TABLE IF EXISTS t_typeof_fixed_numeric3;
