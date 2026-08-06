-- 1_nl_join: NL join query plan comparisons (equality/rounding/scale mismatch)

-- ===========================================================================
-- Section 1: Equality join: 2 vs 2.0 vs 2.00000 (fixed numeric mix)
-- NL: no USE_HASH hint
-- HASH: USE_HASH
-- Index on/off
-- ===========================================================================
DROP TABLE IF EXISTS t_eq1;
DROP TABLE IF EXISTS t_eq2;
DROP TABLE IF EXISTS t_eq3;
DROP TABLE IF EXISTS t_rnd1;
DROP TABLE IF EXISTS t_rnd2;
DROP TABLE IF EXISTS t_ps1;
DROP TABLE IF EXISTS t_ps2;
DROP TABLE IF EXISTS t_ps3;
DROP TABLE IF EXISTS t_ns1;
DROP TABLE IF EXISTS t_ns2;
DROP TABLE IF EXISTS t_ns3;
DROP TABLE IF EXISTS t_ct1;
DROP TABLE IF EXISTS t_ct2;
DROP TABLE IF EXISTS nl_fp_ps1;
DROP TABLE IF EXISTS nl_fp_ps2;
DROP TABLE IF EXISTS nl_fx_ps1;
DROP TABLE IF EXISTS nl_fx_ps2;
DROP TABLE IF EXISTS nl_mix_fp;
DROP TABLE IF EXISTS nl_mix_fx;
CREATE TABLE t_eq1 (id INT, col1 NUMERIC(5,0));
CREATE TABLE t_eq2 (id INT, col2 NUMERIC(6,1));
CREATE TABLE t_eq3 (id INT, col3 NUMERIC(10,5));

INSERT INTO t_eq1 VALUES (1, 2);
INSERT INTO t_eq2 VALUES (1, 2.0);
INSERT INTO t_eq3 VALUES (1, 2.00000);

evaluate '1-1. NL, no index: expect nl-join (1 row)';
SELECT *
FROM t_eq1 a, t_eq2 b
WHERE a.col1 = b.col2;

evaluate '1-2. NL, no index: expect nl-join (1 row)';
SELECT *
FROM t_eq2 a, t_eq3 b
WHERE a.col2 = b.col3;

evaluate '1-3. NL, no index: expect nl-join (1 row)';
SELECT *
FROM t_eq1 a, t_eq3 b
WHERE a.col1 = b.col3;

-- add index (for NL plan variation)
CREATE INDEX idx_eq2_col2 ON t_eq2(col2);
CREATE INDEX idx_eq3_col3 ON t_eq3(col3);

evaluate '1-4. NL with index: expect idx-join (1 row each)';
SELECT *
FROM t_eq1 a, t_eq2 b
WHERE a.col1 = b.col2;

evaluate '1-5. NL with index: expect idx-join (1 row each)';
SELECT *
FROM t_eq2 a, t_eq3 b
WHERE a.col2 = b.col3;

evaluate '1-6. USE_HASH with index: expect hash-join (1 row each)';
SELECT /*+ USE_HASH */ *
FROM t_eq1 a, t_eq2 b
WHERE a.col1 = b.col2;

evaluate '1-7. USE_HASH with index: expect hash-join (1 row each)';
SELECT /*+ USE_HASH */ *
FROM t_eq2 a, t_eq3 b
WHERE a.col2 = b.col3;

-- drop indexes to compare behavior
DROP INDEX idx_eq2_col2 ON t_eq2;
DROP INDEX idx_eq3_col3 ON t_eq3;

evaluate '1-8. USE_HASH, no index: expect hash-join (1 row each)';
SELECT /*+ USE_HASH */ *
FROM t_eq1 a, t_eq2 b
WHERE a.col1 = b.col2;

evaluate '1-9. USE_HASH, no index: expect hash-join (1 row each)';
SELECT /*+ USE_HASH */ *
FROM t_eq1 a, t_eq3 b
WHERE a.col1 = b.col3;


-- ===========================================================================
-- Section 2: Equality join via rounding: 41-digit vs 10^41 (float numeric)
-- 999..99999 (41 digits) == 1000..00000 (10^41) after rounding
-- ===========================================================================
CREATE TABLE t_rnd1 (k INT, v NUMERIC);
CREATE TABLE t_rnd2 (k INT, v NUMERIC);

INSERT INTO t_rnd1 VALUES (1, 99999999999999999999999999999999999999999);
INSERT INTO t_rnd2 VALUES (1, 100000000000000000000000000000000000000000);

evaluate '2-1. sanity: should be 1 (true)';
SELECT a.v = b.v
FROM t_rnd1 a, t_rnd2 b
WHERE a.k = b.k;

evaluate '2-2. NL, no index: expect nl-join (1 row)';
SELECT *
FROM t_rnd1 a, t_rnd2 b
WHERE a.v = b.v;

evaluate '2-3. USE_HASH, no index: expect hash-join (1 row)';
SELECT /*+ USE_HASH */ *
FROM t_rnd1 a, t_rnd2 b
WHERE a.v = b.v;

-- index on join keys/cols
CREATE INDEX idx_rnd1_v ON t_rnd1(v);
CREATE INDEX idx_rnd2_v ON t_rnd2(v);

evaluate '2-4. NL with index: expect idx-join (1 row)';
SELECT *
FROM t_rnd1 a, t_rnd2 b
WHERE a.v = b.v;

evaluate '2-5. USE_HASH with index: expect hash-join (1 row)';
SELECT /*+ USE_HASH */ *
FROM t_rnd1 a, t_rnd2 b
WHERE a.v = b.v;


-- ===========================================================================
-- Section 3: Large scale-mismatch examples (positive scale)
-- literal length/rounding can make "visually similar" values NOT equal
-- keep your original intent but make it explicit
-- ===========================================================================
CREATE TABLE t_ps1 (col1 NUMERIC);
CREATE TABLE t_ps2 (col2 NUMERIC);
CREATE TABLE t_ps3 (col3 NUMERIC);

-- (example A) smaller fractional (stores some tail)
INSERT INTO t_ps1 VALUES (
  0.0000000000000000000000000000000000000000000000000000000001234567890123456789012345678901234567890123
);

-- (example B) much longer fractional (may be trimmed/rounded differently)
INSERT INTO t_ps2 VALUES (
  0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001234567890123456789012345678901234567890123
);

-- (example C) identical to B
INSERT INTO t_ps3 VALUES (
  0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001234567890123456789012345678901234567890123
);

evaluate '3-1. USE_HASH (hash-join): t_ps1 vs t_ps2 -> 0 rows (different magnitudes)';
SELECT /*+ USE_HASH */ *
FROM t_ps1 a, t_ps2 b
WHERE a.col1 = b.col2;

evaluate '3-2. USE_HASH (hash-join): t_ps2 vs t_ps3 -> 1 row (equal)';
SELECT /*+ USE_HASH */ *
FROM t_ps2 a, t_ps3 b
WHERE a.col2 = b.col3;

evaluate '3-3. NL (no hint, nl-join): t_ps1 vs t_ps2 -> 0 rows';
SELECT *
FROM t_ps1 a, t_ps2 b
WHERE a.col1 = b.col2;

evaluate '3-4. NL (no hint, nl-join): t_ps2 vs t_ps3 -> 1 row';
SELECT *
FROM t_ps2 a, t_ps3 b
WHERE a.col2 = b.col3;


-- ===========================================================================
-- Section 4: Large scale-mismatch examples (negative scale)
-- still float numeric, but pushes negative scale side
-- ===========================================================================
CREATE TABLE t_ns1 (col1 NUMERIC);
CREATE TABLE t_ns2 (col2 NUMERIC);
CREATE TABLE t_ns3 (col3 NUMERIC);

INSERT INTO t_ns1 VALUES (
  100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
);

INSERT INTO t_ns2 VALUES (
  10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
);

INSERT INTO t_ns3 VALUES (
  10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
);

evaluate '4-1. USE_HASH (hash-join): ns1 vs ns2 -> 0 rows (different magnitudes)';
SELECT /*+ USE_HASH */ *
FROM t_ns1 a, t_ns2 b
WHERE a.col1 = b.col2;

evaluate '4-2. USE_HASH (hash-join): ns2 vs ns3 -> 1 row (equal)';
SELECT /*+ USE_HASH */ *
FROM t_ns2 a, t_ns3 b
WHERE a.col2 = b.col3;

-- index variation
CREATE INDEX idx_ns2_col2 ON t_ns2(col2);
CREATE INDEX idx_ns3_col3 ON t_ns3(col3);

evaluate '4-3. NL with index: expect idx-join';
SELECT *
FROM t_ns2 a, t_ns3 b
WHERE a.col2 = b.col3;


-- ===========================================================================
-- Section 5: Legacy/common-type style (fixed numeric + index) (index on/off)
-- ===========================================================================
CREATE TABLE t_ct1 (col1 NUMERIC(7,0));
CREATE TABLE t_ct2 (col2 NUMERIC(4,-3));

INSERT INTO t_ct1 VALUES (2222000);
INSERT INTO t_ct2 VALUES (2222000);

evaluate '5-1. NL, no index: expect nl-join (1 row)';
SELECT *
FROM t_ct1 a, t_ct2 b
WHERE a.col1 = b.col2;

evaluate '5-2. USE_HASH, no index: expect hash-join (1 row)';
SELECT /*+ USE_HASH */ *
FROM t_ct1 a, t_ct2 b
WHERE a.col1 = b.col2;

-- index on fixed numeric side
CREATE INDEX idx_ct2_col2 ON t_ct2(col2);

evaluate '5-3. NL with index: expect idx-join (1 row)';
SELECT *
FROM t_ct1 a, t_ct2 b
WHERE a.col1 = b.col2;

-- ===========================================================================
-- Section 6: Float NUMERIC (f-p numeric) + Positive-scale join
-- huge positive scale near max (<= 252)
-- rounding at 41st significant digit (fp only)
-- duplicates + near-miss
-- ===========================================================================

CREATE TABLE nl_fp_ps1 (gid INT, id INT, v NUMERIC);
CREATE TABLE nl_fp_ps2 (gid INT, id INT, v NUMERIC);

-- GID 60: extreme small (near scale 252), duplicates, equal values
-- 1e-252 (0. + 251 zeros + 1)
INSERT INTO nl_fp_ps1 VALUES (60, 1,
  0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
);
INSERT INTO nl_fp_ps1 VALUES (60, 2,
  0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
);

-- same numeric value, different formatting (trailing zeros)
INSERT INTO nl_fp_ps2 VALUES (60, 11,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010
);
INSERT INTO nl_fp_ps2 VALUES (60, 12,
  0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100
);

-- near-miss: 2e-252 (should NOT match 1e-252)
INSERT INTO nl_fp_ps2 VALUES (60, 13,
  0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002
);

-- GID 61: 40-digit mantissa + (41st digit) rounding check
-- base 40 significant digits after long leading zeros (value X)
INSERT INTO nl_fp_ps1 VALUES (61, 1,
  0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001234567890123456789012345678901234567890
);

-- same value but with extra trailing zeros (equal)
INSERT INTO nl_fp_ps2 VALUES (61, 11,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678900000000000
);

-- 41st significant digit = 4 (round-down => should match base)
INSERT INTO nl_fp_ps2 VALUES (61, 12,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678904
);

-- 41st significant digit = 5 (round-up => likely NOT match base)
INSERT INTO nl_fp_ps2 VALUES (61, 13,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678905
);

evaluate '6-1. fp(pos) ps1=ps2 join counts: gid 60->4, gid 61->2 (nl-join)';
SELECT 'NL fp(pos) ps1=ps2' AS tag, a.gid, COUNT(*) AS join_rows
FROM nl_fp_ps1 a, nl_fp_ps2 b
WHERE a.gid=b.gid AND a.v=b.v
GROUP BY a.gid
ORDER BY a.gid;

evaluate '6-2. show gid 61 matches (id 13 excluded: 41st digit=5 rounds up)';
SELECT a.gid, a.id AS a_id, b.id AS b_id, a.v, b.v
FROM nl_fp_ps1 a, nl_fp_ps2 b
WHERE a.gid=61 AND b.gid=61 AND a.v=b.v
ORDER BY a.id, b.id;

CREATE INDEX idx_nl_fp_ps1_gv ON nl_fp_ps1(gid, v);
CREATE INDEX idx_nl_fp_ps2_gv ON nl_fp_ps2(gid, v);

evaluate '6-3. fp(pos) ps1=ps2 with index (idx-join)';
SELECT 'NL+IDX fp(pos) ps1=ps2' AS tag, a.gid, COUNT(*) AS join_rows
FROM nl_fp_ps1 a, nl_fp_ps2 b
WHERE a.gid=b.gid AND a.v=b.v
GROUP BY a.gid
ORDER BY a.gid;


-- ===========================================================================
-- Section 7: Fixed NUMERIC + Positive-scale join (e.g., (38,127))
-- fixed positive scale boundary style
-- duplicates + near-miss
-- ===========================================================================

CREATE TABLE nl_fx_ps1 (gid INT, id INT, v NUMERIC(38,127));
CREATE TABLE nl_fx_ps2 (gid INT, id INT, v NUMERIC(38,127));

-- gid 70: 38 significant digits placed at the tail of 127 fraction digits
INSERT INTO nl_fx_ps1 VALUES (38, 89,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678
);
INSERT INTO nl_fx_ps1 VALUES (38, 93,
  0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678
);

-- same numeric value, with extra trailing zeros in literal (still equal)
INSERT INTO nl_fx_ps2 VALUES (38, 89,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678
);
INSERT INTO nl_fx_ps2 VALUES (38, 93,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001234567890123456789012345678901235
);

-- near-miss: last digit different (should not match)
INSERT INTO nl_fx_ps2 VALUES (101, 13,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345679
);

evaluate '7-1. fixed(38,127) ps1=ps2 join counts (nl-join)';
SELECT 'NL fixed(pos) ps1=ps2' AS tag, a.gid, a.id, COUNT(*) AS join_rows
FROM nl_fx_ps1 a, nl_fx_ps2 b
WHERE a.gid=b.gid AND a.v=b.v
GROUP BY a.gid, a.id;

CREATE INDEX idx_nl_fx_ps1_gv ON nl_fx_ps1(gid, v);
CREATE INDEX idx_nl_fx_ps2_gv ON nl_fx_ps2(gid, v);

evaluate '7-2. fixed(38,127) ps1=ps2 with index (idx-join)';
SELECT 'NL+IDX fixed(pos) ps1=ps2' AS tag, a.gid, a.id, COUNT(*) AS join_rows
FROM nl_fx_ps1 a, nl_fx_ps2 b
WHERE a.gid=b.gid AND a.v=b.v
GROUP BY a.gid, a.id;


-- ===========================================================================
-- Section 8: Mixed join: Float NUMERIC (numeric) <-> Fixed NUMERIC(38,127)
-- match cases: same value / trailing zeros
-- non-match cases: fp has extra significant digit / fp supports deeper scale (<=252) but fixed rounds to 0
-- duplicates + signs
-- ===========================================================================

CREATE TABLE nl_mix_fp (gid INT, id INT, v NUMERIC);
CREATE TABLE nl_mix_fx (gid INT, id INT, v NUMERIC(38,127));

-- gid 80: exact match (same value)
INSERT INTO nl_mix_fp VALUES (80, 1,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678
);
INSERT INTO nl_mix_fp VALUES (80, 2,
  0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001234567890123456789012345678901234567800000000000
);

INSERT INTO nl_mix_fx VALUES (80, 11,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678
);
INSERT INTO nl_mix_fx VALUES (80, 12,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678
);

-- gid 81: fx column NUMERIC(38,127) rounds the 38-digit literal to scale 127 (37 sig), which equals fp -> match (1)
INSERT INTO nl_mix_fp VALUES (81, 1,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001234567890123456789012345678901234568
);
INSERT INTO nl_mix_fx VALUES (81, 11,
  0.00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678
);

-- gid 82: fp 1e-253 exceeds float-numeric max scale 252 -> underflows to 0; fx is 0 -> both 0 -> match (1)
INSERT INTO nl_mix_fp VALUES (82, 1,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001
);
INSERT INTO nl_mix_fx VALUES (82, 11, 0);

-- gid 83: sign mix + duplicates (match)
INSERT INTO nl_mix_fp VALUES (83, 1,
 -0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678
);
INSERT INTO nl_mix_fp VALUES (83, 2,
 -0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001234567890123456789012345678901234567800
);

INSERT INTO nl_mix_fx VALUES (83, 11,
 -0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012345678901234567890123456789012345678
);

evaluate '8-1. mixed fp<->fixed join counts: gid 80->4, 81->1, 82->1, 83->2 (nl-join)';
SELECT 'NL mix fp=fixed' AS tag, a.gid, COUNT(*) AS join_rows
FROM nl_mix_fp a, nl_mix_fx b
WHERE a.gid=b.gid AND a.v=b.v
GROUP BY a.gid
ORDER BY a.gid;

evaluate '8-2. show gid 82 (both fp and fx are 0 -> 1 match)';
SELECT a.gid, a.id AS fp_id, b.id AS fx_id, a.v, b.v
FROM nl_mix_fp a, nl_mix_fx b
WHERE a.gid=82 AND b.gid=82 AND a.v=b.v;

CREATE INDEX idx_nl_mix_fp_gv ON nl_mix_fp(gid, v);
CREATE INDEX idx_nl_mix_fx_gv ON nl_mix_fx(gid, v);

evaluate '8-3. mixed fp<->fixed with index (idx-join)';
SELECT 'NL+IDX mix fp=fixed' AS tag, a.gid, COUNT(*) AS join_rows
FROM nl_mix_fp a, nl_mix_fx b
WHERE a.gid=b.gid AND a.v=b.v
GROUP BY a.gid
ORDER BY a.gid;

DROP TABLE IF EXISTS nl_mix_fp;
DROP TABLE IF EXISTS nl_mix_fx;
DROP TABLE IF EXISTS t_eq1;
DROP TABLE IF EXISTS t_eq2;
DROP TABLE IF EXISTS t_eq3;
DROP TABLE IF EXISTS t_rnd1;
DROP TABLE IF EXISTS t_rnd2;
DROP TABLE IF EXISTS t_ps1;
DROP TABLE IF EXISTS t_ps2;
DROP TABLE IF EXISTS t_ps3;
DROP TABLE IF EXISTS t_ns1;
DROP TABLE IF EXISTS t_ns2;
DROP TABLE IF EXISTS t_ns3;
DROP TABLE IF EXISTS t_ct1;
DROP TABLE IF EXISTS t_ct2;
DROP TABLE IF EXISTS nl_fp_ps1;
DROP TABLE IF EXISTS nl_fp_ps2;
DROP TABLE IF EXISTS nl_fx_ps1;
DROP TABLE IF EXISTS nl_fx_ps2;
