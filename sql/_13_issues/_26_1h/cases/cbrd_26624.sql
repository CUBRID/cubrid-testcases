-- CBRD-26624 – LEADING hint after single-view / derived merge (merged cases)

DROP VIEW IF EXISTS v_leading_a;
DROP TABLE IF EXISTS b_test;
DROP TABLE IF EXISTS a_test;

CREATE TABLE a_test (seq NUMERIC, title VARCHAR(100));

evaluate 'inline derived table merged into outer SELECT';
SELECT /*+ recompile */ *
FROM (
  SELECT /*+ LEADING(a) */ a.seq
  FROM a_test a, a_test b
  WHERE a.seq = b.seq
) a;

evaluate 'Single view merge: CREATE VIEW with LEADING, then SELECT * FROM view';
CREATE VIEW v_leading_a AS
SELECT /*+ LEADING(a) */ a.seq
FROM a_test a, a_test b
WHERE a.seq = b.seq;

SELECT /*+ recompile */ * FROM v_leading_a;

evaluate 'LEADING on the inner alias (b)';
SELECT /*+ recompile */ *
FROM (
  SELECT /*+ LEADING(b) */ b.seq
  FROM a_test a, a_test b
  WHERE a.seq = b.seq
) t;

DROP VIEW IF EXISTS v_leading_a;
DROP TABLE IF EXISTS a_test;

CREATE TABLE a_test (id INT);
CREATE TABLE b_test (id INT);

evaluate 'Two base tables: LEADING(a_test) on distinct a_test / b_test';
SELECT /*+ recompile */ *
FROM (
  SELECT /*+ LEADING(a_test) */ a_test.id
  FROM a_test, b_test
  WHERE a_test.id = b_test.id
) q;

DROP TABLE IF EXISTS b_test;
DROP TABLE IF EXISTS a_test;