-- refer to sql/_33_elderberry/cbrd_24011/cases/no_push_predicate_hint.sql

DROP TABLE IF EXISTS tab_a, tab_b;
CREATE TABLE tab_a (col_a VARCHAR(100), col_b VARCHAR(100));
CREATE TABLE tab_b (col_a VARCHAR(100), col_b VARCHAR(100));

INSERT INTO tab_a 
SELECT TO_CHAR(ROWNUM MOD 100) col_a, TO_CHAR(ROWNUM) col_b 
FROM TABLE({0,1,2,3,4,5,6,7,8,9}) a, TABLE({0,1,2,3,4,5,6,7,8,9}) b, 
     TABLE({0,1,2,3,4,5,6,7,8,9}) c, TABLE({0,1,2,3,4,5,6,7,8,9}) d, 
     TABLE({0,1,2,3,4,5,6,7,8,9}) e, TABLE({0,1,2,3,4,5,6,7,8,9}) f 
LIMIT 1000;

INSERT INTO tab_b 
SELECT TO_CHAR(ROWNUM MOD 100) col_a, TO_CHAR(ROWNUM) col_b 
FROM TABLE({0,1,2,3,4,5,6,7,8,9}) a, TABLE({0,1,2,3,4,5,6,7,8,9}) b, 
     TABLE({0,1,2,3,4,5,6,7,8,9}) c, TABLE({0,1,2,3,4,5,6,7,8,9}) d, 
     TABLE({0,1,2,3,4,5,6,7,8,9}) e, TABLE({0,1,2,3,4,5,6,7,8,9}) f 
LIMIT 1000;

CREATE INDEX idx ON tab_a(col_a, col_b);
CREATE INDEX idx ON tab_b(col_a, col_b);

-- Create a view (does not have the no_push_pred hint)
CREATE OR REPLACE VIEW v AS
SELECT col_a, cnt 
FROM ( 
    SELECT col_a, cnt
    FROM ( 
        SELECT col_a, cnt
        FROM ( 
            SELECT col_a, COUNT(*) cnt 
            FROM tab_b 
            GROUP BY col_a
        ) aa
    ) bb 
    WHERE cnt >= 1
) cc;

-- Check result (main query has no_push_pred hint) (mergable)
SELECT /*+ RECOMPILE no_push_pred */ COUNT(*)
FROM tab_a a, v b
WHERE a.col_a = b.col_a AND b.col_a = 1;

-- Convert the view to an inline view (mergable)
DROP VIEW IF EXISTS v;
SELECT /*+ RECOMPILE no_push_pred */ COUNT(*)
FROM tab_a a,
     (SELECT col_a, cnt FROM (
          SELECT col_a, cnt FROM (
              SELECT col_a, cnt FROM (
                  SELECT col_a, COUNT(*) cnt 
                  FROM tab_b 
                  GROUP BY col_a
              ) aa
          ) bb 
          WHERE cnt >= 1
      ) cc
     ) d
WHERE a.col_a = d.col_a AND d.col_a = 1;

-- Create a view with the no_push_pred hint
CREATE OR REPLACE VIEW v AS
SELECT col_a, cnt
FROM (
    SELECT col_a, cnt
    FROM (
        SELECT /*+ no_push_pred */ col_a, cnt
        FROM (
            SELECT col_a, COUNT(*) cnt
            FROM tab_b
            GROUP BY col_a
        ) aa
    ) bb
    WHERE cnt >= 1
) cc;

-- Check result (mergable)
SELECT /*+ RECOMPILE */ COUNT(*)
FROM tab_a a, v b
WHERE a.col_a = b.col_a
  AND b.col_a = 1;

-- Convert the view to an inline view (mergable)
DROP VIEW IF EXISTS v;
SELECT /*+ RECOMPILE */ COUNT(*)
FROM tab_a a,
     (SELECT col_a, cnt FROM (
          SELECT col_a, cnt FROM (
              SELECT /*+ no_push_pred */ col_a, cnt FROM (
                  SELECT col_a, COUNT(*) cnt 
                  FROM tab_b 
                  GROUP BY col_a
              ) aa
          ) bb 
          WHERE cnt >= 1
      ) cc
     ) d
WHERE a.col_a = d.col_a AND d.col_a = 1;

DROP TABLE IF EXISTS tab_a, tab_b;
