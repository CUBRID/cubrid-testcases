/**
 * This test case verifies CBRD-27159: an outer join against a view must
 * keep its WHERE term in the main query to filter the NULL-extended row.
 *
 * Coverage:
 * 1-2. Base-table vs view-substituted LEFT JOIN, both correctly empty.
 * 3.   A real match passes; an unmatched row is still excluded.
 * 4.   No-OR conjunct still filters after LEFT->INNER conversion.
 * 5.   Symmetric RIGHT JOIN, view on the NULL-extendable side.
 * 6.   Same as 3 via a NO_MERGE derived table (pins the code path).
 * 7.   A non-deterministic term (RANDOM()) does not error or change the result.
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

evaluate 'Case 4: a single no-OR conjunct still filters after LEFT->INNER conversion';
SELECT a.c4
FROM repro_left_join_t1 AS a LEFT JOIN repro_left_join_v_t2 AS b ON a.c1 = b.c3
WHERE b.c15 < 6
ORDER BY a.c4;

evaluate 'Case 5: symmetric RIGHT JOIN, view on the NULL-extendable side';
SELECT a.c4
FROM repro_left_join_v_t2 AS b RIGHT JOIN repro_left_join_t1 AS a ON a.c1 = b.c3
WHERE b.c4 <> 'sample_24' OR b.c15 < 6
ORDER BY a.c4;

evaluate 'Case 6: same as Case 3 through a NO_MERGE derived table, pinning the fixed code path';
SELECT a.c4
FROM repro_left_join_t1 AS a
LEFT JOIN (SELECT /*+ NO_MERGE */ c15, c3, c4 FROM repro_left_join_t2) AS b ON a.c1 = b.c3
WHERE b.c4 <> 'sample_24' OR b.c15 < 6
ORDER BY a.c4;

evaluate 'Case 7: a non-deterministic term does not error or change the deterministic result';
SELECT a.c4
FROM repro_left_join_t1 AS a LEFT JOIN repro_left_join_v_t2 AS b ON a.c1 = b.c3
WHERE a.c1 >= 1 AND (b.c4 <> 'sample_24' OR b.c15 < 6) AND (b.c15 <> 999999 OR RANDOM() < 0)
ORDER BY a.c4;

DROP VIEW IF EXISTS repro_left_join_v_t2;
DROP TABLE IF EXISTS repro_left_join_t2;
DROP TABLE IF EXISTS repro_left_join_t1;
