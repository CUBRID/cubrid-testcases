-- CBRD-26624 – LEADING hint after single-view / derived merge (merged cases)

DROP VIEW IF EXISTS v_leading_a;
DROP TABLE IF EXISTS b_test;
DROP TABLE IF EXISTS a_test;

CREATE TABLE a_test (seq NUMERIC, title VARCHAR(100));

evaluate 'Case 1: inline derived table merged into outer SELECT';
SELECT /*+ recompile */ *
FROM (
  SELECT /*+ LEADING(a) */ a.seq
  FROM a_test a, a_test b
  WHERE a.seq = b.seq
) a;

evaluate 'Case 2: Single view merge: CREATE VIEW with LEADING, then SELECT * FROM view';
CREATE VIEW v_leading_a AS
SELECT /*+ LEADING(a) */ a.seq
FROM a_test a, a_test b
WHERE a.seq = b.seq;

SELECT /*+ recompile */ * FROM v_leading_a;

evaluate 'Case 3: LEADING on the inner alias (b)';
SELECT /*+ recompile */ *
FROM (
  SELECT /*+ LEADING(b) */ b.seq
  FROM a_test a, a_test b
  WHERE a.seq = b.seq
) t;

DROP VIEW IF EXISTS v_leading_a;
DROP TABLE IF EXISTS a_test;

CREATE TABLE a_test (id INT, seq NUMERIC, title VARCHAR(100));
CREATE TABLE b_test (id INT, seq NUMERIC, title VARCHAR(100));

evaluate 'Case 4: Two base tables: LEADING(a_test) on distinct a_test / b_test';
SELECT /*+ recompile */ *
FROM (
  SELECT /*+ LEADING(a_test) */ a_test.id
  FROM a_test, b_test
  WHERE a_test.id = b_test.id
) q;

evaluate 'Case 5: NO_MERGE keeps LEADING(a) in inner query';

SELECT /*+ recompile */ *
FROM (
  SELECT /*+ NO_MERGE LEADING(a) */ a.seq
  FROM a_test a, a_test b
  WHERE a.seq = b.seq
) x;

evaluate 'Case 6: Multiple hints preserve LEADING(a) after derived merge';
SELECT /*+ recompile */ *
FROM (
  SELECT /*+ LEADING(a) USE_NL(b) */ a.seq
  FROM a_test a, a_test b
  WHERE a.seq = b.seq
) x;

evaluate 'Case 7: Schema-qualified LEADING(dba.a_test) is preserved after merge';
SELECT /*+ recompile */ *
FROM (
  SELECT /*+ LEADING(dba.a_test) */ a_test.id
  FROM dba.a_test, dba.b_test
  WHERE a_test.id = b_test.id
) q;

evaluate 'Case 8: Alias-based LEADING(a) on distinct base tables is preserved after merge';
SELECT /*+ recompile */ *
FROM (
  SELECT /*+ LEADING(a) */ a.id
  FROM a_test a, b_test b
  WHERE a.id = b.id
) q;

DROP TABLE IF EXISTS b_test;
DROP TABLE IF EXISTS a_test;
