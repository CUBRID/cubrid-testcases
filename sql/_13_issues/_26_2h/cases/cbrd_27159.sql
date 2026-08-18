/**
 * This test case verifies CBRD-27159: a LEFT/RIGHT JOIN against a
 * projection-only view must keep its WHERE term in the main query so it
 * can still filter the join's NULL-extended row when the view produces
 * no match for that row.
 *
 * Coverage:
 * 1. Base-table LEFT JOIN, view not involved - correctly empty (baseline).
 * 2. Main repro - the same query through a view is also empty.
 * 3. A real match through the view still passes the OR filter; an
 *    unmatched row is still correctly excluded.
 * 4. INNER JOIN through the same view is unaffected (contrast).
 * 5. Symmetric RIGHT JOIN, view on the NULL-extendable side.
 */

DROP VIEW IF EXISTS repro_left_join_v_t2;
DROP TABLE IF EXISTS repro_left_join_t2;
DROP TABLE IF EXISTS repro_left_join_t1;

CREATE TABLE repro_left_join_t1 (c1 INT, c4 INT);
CREATE TABLE repro_left_join_t2 (c3 INT, c4 VARCHAR(50), c15 DOUBLE);
INSERT INTO repro_left_join_t1 VALUES (1, 127);

CREATE VIEW repro_left_join_v_t2 AS
    SELECT c15, c3, c4 FROM repro_left_join_t2;

evaluate 'Case 1: base-table LEFT JOIN is correctly empty (baseline)';
SELECT a.c4
FROM repro_left_join_t1 AS a LEFT JOIN repro_left_join_t2 AS b ON a.c1 = b.c3
WHERE b.c4 <> 'sample_24' OR b.c15 < 6
ORDER BY a.c4;

evaluate 'Case 2: main repro - view-substituted LEFT JOIN is also empty';
SELECT a.c4
FROM repro_left_join_t1 AS a LEFT JOIN repro_left_join_v_t2 AS b ON a.c1 = b.c3
WHERE b.c4 <> 'sample_24' OR b.c15 < 6
ORDER BY a.c4;

INSERT INTO repro_left_join_t1 VALUES (2, 999);
INSERT INTO repro_left_join_t2 VALUES (1, 'sample_24', 5);

evaluate 'Case 3: a real match through the view still passes, an unmatched row is still excluded';
SELECT a.c4
FROM repro_left_join_t1 AS a LEFT JOIN repro_left_join_v_t2 AS b ON a.c1 = b.c3
WHERE b.c4 <> 'sample_24' OR b.c15 < 6
ORDER BY a.c4;

evaluate 'Case 4: INNER JOIN through the same view is unaffected';
SELECT a.c4
FROM repro_left_join_t1 AS a INNER JOIN repro_left_join_v_t2 AS b ON a.c1 = b.c3
WHERE b.c4 <> 'sample_24' OR b.c15 < 6
ORDER BY a.c4;

evaluate 'Case 5: symmetric RIGHT JOIN, view on the NULL-extendable side';
SELECT a.c4
FROM repro_left_join_v_t2 AS b RIGHT JOIN repro_left_join_t1 AS a ON a.c1 = b.c3
WHERE b.c4 <> 'sample_24' OR b.c15 < 6
ORDER BY a.c4;

DROP VIEW IF EXISTS repro_left_join_v_t2;
DROP TABLE IF EXISTS repro_left_join_t2;
DROP TABLE IF EXISTS repro_left_join_t1;
