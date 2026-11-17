-- CBRD-27657 LEFT OUTER JOIN drops unmatched rows when a merged inline view brings a correlated scalar subquery
--            into the ON clause
-- A single-table inline view on the preserved side of a LEFT JOIN is merged (CBRD-26260). When a select list
-- item holding a subquery is referenced by an ON clause, the merge must be refused: the subquery term would be
-- evaluated after the inner scan decided its NULL padding. A view on the null-padded side is not merged when the
-- statement reads a select list item that is not a plain column, so NVL()/COUNT(*) items are still padded with NULL.

DROP VIEW IF EXISTS va;
DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (5, 5), (7, 7), (9, 9);
INSERT INTO tb VALUES (1, 0), (1, 100), (5, 0), (7, 100), (7, 0);
INSERT INTO tc VALUES (1, 1), (5, 5), (7, 7), (9, 9);
CREATE VIEW va AS SELECT ca, cb, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = ta.ca) AS cc FROM ta;

-- 1. inline view, correlated scalar subquery column referenced by the ON clause: 4 rows, (5, NULL) and (9, NULL) kept
SELECT /*+ RECOMPILE NO_USE_HASH */ d.ca, tb.cb
FROM (SELECT ca, cb, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = ta.ca) AS cc FROM ta) d
  LEFT JOIN tb ON tb.ca = d.cb AND tb.cb > d.cb + d.cc
ORDER BY 1, 2;

-- 2. same with NO_MERGE (reference)
SELECT /*+ RECOMPILE NO_USE_HASH */ d.ca, tb.cb
FROM (SELECT /*+ NO_MERGE */ ca, cb, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = ta.ca) AS cc FROM ta) d
  LEFT JOIN tb ON tb.ca = d.cb AND tb.cb > d.cb + d.cc
ORDER BY 1, 2;

-- 3. same with the join hints: the view stays unmerged and the hinted join method is chosen
--@queryplan
SELECT /*+ RECOMPILE USE_HASH */ d.ca, tb.cb
FROM (SELECT ca, cb, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = ta.ca) AS cc FROM ta) d
  LEFT JOIN tb ON tb.ca = d.cb AND tb.cb > d.cb + d.cc
ORDER BY 1, 2;

--@queryplan
SELECT /*+ RECOMPILE USE_MERGE */ d.ca, tb.cb
FROM (SELECT ca, cb, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = ta.ca) AS cc FROM ta) d
  LEFT JOIN tb ON tb.ca = d.cb AND tb.cb > d.cb + d.cc
ORDER BY 1, 2;

-- 4. a view instead of the inline view
SELECT /*+ RECOMPILE NO_USE_HASH */ va.ca, tb.cb
FROM va
  LEFT JOIN tb ON tb.ca = va.cb AND tb.cb > va.cb + va.cc
ORDER BY 1, 2;

-- 5. uncorrelated scalar subquery column referenced by the ON clause: evaluated once, so the view is still merged
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ d.ca, tb.cb
FROM (SELECT ca, cb, (SELECT MIN(cb) FROM tb) AS cc FROM ta) d
  LEFT JOIN tb ON tb.ca = d.cb AND tb.cb > d.cb + d.cc
ORDER BY 1, 2;

-- 6. the subquery column is referenced by the ON clause of the second LEFT JOIN: (9, NULL, NULL) kept
SELECT /*+ RECOMPILE NO_USE_HASH */ d.ca, tb.cb, tc.cb
FROM (SELECT ca, cb, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = ta.ca) AS cc FROM ta) d
  LEFT JOIN tb ON tb.ca = d.cb
  LEFT JOIN tc ON tc.ca = d.ca AND tc.cb > d.cc
ORDER BY 1, 2, 3;

-- 6a. the view reaches the LEFT JOIN through an INNER JOIN (same defect in 11.4): (5, NULL) and (9, NULL) kept
SELECT /*+ RECOMPILE NO_USE_HASH */ d.ca, tb.cb
FROM (SELECT ca, cb, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = ta.ca) AS cc FROM ta) d
  JOIN tc ON tc.ca = d.ca
  LEFT JOIN tb ON tb.ca = d.cb AND tb.cb > d.cb + d.cc
ORDER BY 1, 2;

SELECT /*+ RECOMPILE NO_USE_HASH */ d.ca, tb.cb
FROM (SELECT /*+ NO_MERGE */ ca, cb, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = ta.ca) AS cc FROM ta) d
  JOIN tc ON tc.ca = d.ca
  LEFT JOIN tb ON tb.ca = d.cb AND tb.cb > d.cb + d.cc
ORDER BY 1, 2;

-- 6b. the view is the preserved side of a RIGHT JOIN
SELECT /*+ RECOMPILE NO_USE_HASH */ d.ca, tb.cb
FROM tb
  RIGHT JOIN (SELECT ca, cb, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = ta.ca) AS cc FROM ta) d
    ON tb.ca = d.cb AND tb.cb > d.cb + d.cc
ORDER BY 1, 2;

-- 7. the subquery column is not referenced by an ON clause: the view is still merged
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ d.ca, d.cc, tb.cb
FROM (SELECT ca, cb, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = ta.ca) AS cc FROM ta) d
  LEFT JOIN tb ON tb.ca = d.cb
ORDER BY 1, 2, 3;

-- 8. view on the null-padded side: NVL() and COUNT(*) items are padded with NULL
SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca, d.k
FROM ta
  LEFT JOIN (SELECT ca, NVL(cb, -1) AS k FROM tc) d ON d.ca = ta.ca + 100
ORDER BY 1, 2;

SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca, d.k
FROM ta
  LEFT JOIN (SELECT ca, (SELECT COUNT(*) FROM tb x WHERE x.ca = tc.ca) AS k FROM tc) d ON d.ca = ta.ca + 100
ORDER BY 1, 2;

-- 10. view on the null-padded side whose WHERE holds a correlated subquery: the merge would move it into the
--     ON clause, so the view stays unmerged and (9, NULL) is kept
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca, d.cb
FROM ta
  LEFT JOIN (SELECT ca, cb FROM tb WHERE cb < (SELECT COUNT(*) FROM tc x WHERE x.ca = tb.ca)) d ON d.ca = ta.ca
ORDER BY 1, 2;

SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca, d.cb
FROM ta
  LEFT JOIN (SELECT /*+ NO_MERGE */ ca, cb FROM tb WHERE cb < (SELECT COUNT(*) FROM tc x WHERE x.ca = tb.ca)) d
    ON d.ca = ta.ca
ORDER BY 1, 2;

-- 11. view on the null-padded side whose WHERE holds an uncorrelated subquery: not merged either (an IN subquery
--     there would break the outer join optimization), and correct
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca, d.cb
FROM ta
  LEFT JOIN (SELECT ca, cb FROM tb WHERE cb < (SELECT MAX(cb) FROM tc)) d ON d.ca = ta.ca
ORDER BY 1, 2;

-- 13. UPDATE / DELETE through the same shape: the unmatched rows 5 and 9 are the ones the DML must touch
UPDATE ta
  JOIN (SELECT ca, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = t2.ca) AS cc FROM ta t2) d ON d.ca = ta.ca
  LEFT JOIN tb ON tb.ca = ta.cb AND tb.cb > ta.cb + d.cc
  SET ta.cb = -1
WHERE tb.cb IS NULL;
SELECT * FROM ta ORDER BY 1;
UPDATE ta SET cb = ca;

DELETE ta FROM ta
  JOIN (SELECT ca, (SELECT MIN(x.cb) FROM tb x WHERE x.ca = t2.ca) AS cc FROM ta t2) d ON d.ca = ta.ca
  LEFT JOIN tb ON tb.ca = ta.cb AND tb.cb > ta.cb + d.cc
WHERE tb.cb IS NULL;
SELECT * FROM ta ORDER BY 1;
INSERT INTO ta VALUES (5, 5), (9, 9);

-- 14. a correlated subquery nested in the argument that follows an uncorrelated subquery: still refused
SELECT /*+ RECOMPILE NO_USE_HASH */ d.ca, tb.cb
FROM (SELECT ca, cb, NVL((SELECT MIN(cb) FROM tb WHERE cb > 1000), 0 + (SELECT MIN(x.cb) FROM tb x WHERE x.ca = ta.ca)) AS cc
      FROM ta) d
  LEFT JOIN tb ON tb.ca = d.cb AND tb.cb > d.cb + d.cc
ORDER BY 1, 2;

-- 15. null-padded view WHERE: an uncorrelated term before the correlated one, and an IN subquery
SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca, d.cb
FROM ta
  LEFT JOIN (SELECT ca, cb FROM tb WHERE ca > (SELECT -100 FROM db_root) AND cb < (SELECT COUNT(*) FROM tc x WHERE x.ca = tb.ca)) d
    ON d.ca = ta.ca
ORDER BY 1, 2;

SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca, d.cb
FROM ta
  LEFT JOIN (SELECT ca, cb FROM tb WHERE ca IN (SELECT ca FROM tc)) d ON d.ca = ta.ca AND d.cb = 100
ORDER BY 1, 2;

-- 16. a later derived table or JSON_TABLE reads an expression column of the null-padded view: padded rows give NULL
SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca, q.x
FROM ta
  LEFT JOIN (SELECT ca, 7 AS x FROM tc WHERE ca < 7) v ON v.ca = ta.ca,
  (SELECT v.x AS x FROM db_root) q
ORDER BY 1, 2;

SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca, j.x
FROM ta
  LEFT JOIN (SELECT ca, CAST(7 AS VARCHAR(10)) AS one FROM tc WHERE ca < 7) v ON v.ca = ta.ca,
  JSON_TABLE(v.one, '$' COLUMNS (x INT PATH '$')) AS j
ORDER BY 1, 2;

-- 17. a typed view whose columns are cast-wrapped is still merged on the null-padded side
CREATE VIEW vt (ca INT, bb BIGINT) AS SELECT ca, cb FROM tc;
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca, v.bb FROM ta LEFT JOIN vt v ON v.ca = ta.ca ORDER BY 1, 2;
DROP VIEW vt;

-- 18. view on the null-padded side with plain columns: still merged
--@queryplan
SELECT /*+ RECOMPILE NO_USE_HASH */ ta.ca, d.cb
FROM ta
  LEFT JOIN (SELECT ca, cb FROM tc) d ON d.ca = ta.ca
ORDER BY 1, 2;

DROP VIEW va;
DROP TABLE ta, tb, tc;
