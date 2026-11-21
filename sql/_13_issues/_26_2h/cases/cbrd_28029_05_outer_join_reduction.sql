/**
 *  This test case verifies CBRD-28029 #5: a WHERE predicate that can be true when the inner (NULL-padded) table of a LEFT OUTER JOIN is all
 *  NULL must not turn the outer join into an inner join. The ON i.a = -1 is always false, so every outer row is padded.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t05o, t05i;
CREATE TABLE t05o (b VARCHAR);
CREATE TABLE t05i (a INT);
INSERT INTO t05o VALUES ('x'), ('y');
INSERT INTO t05i VALUES (5);
-- 5 NOT BETWEEN NULL AND 1 = NOT (NULL AND FALSE) = TRUE
-- expected: rows: 'x' | NULL / 'y' | NULL
evaluate 'Case 5-1';
SELECT o.b, i.a FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE 5 NOT BETWEEN i.a AND 1 ORDER BY 1;
-- expected: rows: 'x' | NULL
evaluate 'Case 5-2';
SELECT o.b, i.a FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (o.b = 'x' OR i.a = 1) IS NOT NULL ORDER BY 1;
-- expected: rows: 'x' | NULL
evaluate 'Case 5-3';
SELECT o.b, i.a FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT ((o.b = 'x' OR i.a = 1) IS NULL) ORDER BY 1;
-- expected: rows: 'x' | NULL / 'y' | NULL
evaluate 'Case 5-4';
SELECT o.b, i.a FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a IS NOT NULL) IS FALSE ORDER BY 1;
-- expected: rows: 'x' | NULL / 'y' | NULL
evaluate 'Case 5-c1';
SELECT o.b, i.a FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE i.a IS NULL ORDER BY 1;
-- fixed by CBRD-27952, kept as guards
-- expected: rows: 2
evaluate 'Case 5-c2';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE 0 IN (0, i.a);
-- expected: rows: 2
evaluate 'Case 5-c3';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT (i.a = 1 AND o.b = 'q');
-- more predicates that are true on the NULL-padded row
-- expected: rows: 2
evaluate 'Case 5-5';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT (5 BETWEEN i.a AND 1);
-- expected: rows: 2
evaluate 'Case 5-6';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a = 5) IS NOT TRUE;
-- expected: rows: 2
evaluate 'Case 5-7';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a = 5) IS UNKNOWN;
-- expected: rows: 2
evaluate 'Case 5-8';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a > 0) IS NULL;
-- expected: rows: 2
evaluate 'Case 5-9';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a IS NULL) IS TRUE;
-- expected: rows: 2
evaluate 'Case 5-10';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT (i.a IS NOT NULL);
-- expected: rows: 2
evaluate 'Case 5-11';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE COALESCE(i.a, 0) = 0;
-- expected: rows: 2
evaluate 'Case 5-12';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NVL(i.a, 0) = 0;
-- expected: rows: 2
evaluate 'Case 5-13';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE i.a <=> NULL;
-- expected: rows: 2
evaluate 'Case 5-14';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a = 1 OR o.b = 'x') IS NOT FALSE;
-- expected: rows: 2
evaluate 'Case 5-15';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a = 1) IS NOT FALSE;
-- expected: rows: 2
evaluate 'Case 5-16';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT ((i.a > 0) IS TRUE);
-- expected: rows: 2
evaluate 'Case 5-17';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (CASE WHEN i.a IS NULL THEN 1 ELSE 0 END) = 1;
-- expected: rows: 2
evaluate 'Case 5-18';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NULLIF(i.a, 1) IS NULL;
-- expected: rows: 1
evaluate 'Case 5-19';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a = 1 AND o.b = 'x') IS NULL;
-- expected: rows: 2
evaluate 'Case 5-20';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a = 1 AND o.b = 'x') IS NOT TRUE;
-- expected: rows: 2
evaluate 'Case 5-21';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a IS NOT NULL) IS NOT TRUE;
-- expected: rows: 2
evaluate 'Case 5-22';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT ((i.a IS NOT NULL) IS TRUE);
-- expected: rows: 2
evaluate 'Case 5-23';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a IS NOT NULL OR o.b = 'zz') IS FALSE;
-- expected: rows: 1
evaluate 'Case 5-24';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE ((i.a = 5) OR (o.b = 'x')) IS NOT UNKNOWN;
-- expected: rows: 2
evaluate 'Case 5-25';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a IN (1, 2)) IS NULL;
-- expected: rows: 2
evaluate 'Case 5-26';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a NOT BETWEEN 1 AND 2) IS NULL;
-- expected: rows: 2
evaluate 'Case 5-27';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a + 1) IS NULL;
-- expected: rows: 2
evaluate 'Case 5-28';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE IF(i.a IS NULL, 1, 0) = 1;
-- expected: rows: 1
evaluate 'Case 5-29';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE o.b = 'x' AND i.a IS NULL;
-- expected: rows: 2
evaluate 'Case 5-30';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT (i.a IS NOT NULL AND o.b = 'x');
-- expected: rows: 2
evaluate 'Case 5-31';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a > 0) IS NOT TRUE;
-- expected: rows: 2
evaluate 'Case 5-32';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (NOT (i.a > 0)) IS NULL;
-- an OR under IS TRUE, an AND under IS FALSE, functions that are not NULL on a NULL argument
-- expected: rows: 1
evaluate 'Case 5-33';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a = 1 OR o.b = 'x') IS TRUE;
-- expected: rows: 1
evaluate 'Case 5-34';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a = 1 AND o.b = 'x') IS FALSE;
-- expected: rows: 2
evaluate 'Case 5-35';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NULLIF(1, i.a) = 1;
-- expected: rows: 2
evaluate 'Case 5-36';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE FIELD(i.a, 1, 2) = 0;
-- expected: rows: 2
evaluate 'Case 5-37';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a IN (SELECT a FROM t05i WHERE 1 = 2)) IS FALSE;
-- expected: rows: 2
evaluate 'Case 5-38';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE EXISTS (SELECT 1 FROM t05o z WHERE z.b = 'x' OR i.a = 1);
-- expected: rows: 1
evaluate 'Case 5-39';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (((i.a = 1) OR (o.b = 'x')) IS NOT FALSE) AND (((i.a = 1) OR (o.b = 'x')) IS NOT UNKNOWN);
-- predicates that are false or unknown on the padded row: the reduction is right, the answer is no row
-- expected: rows: 0
evaluate 'Case 5-n1';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE 5 NOT BETWEEN 1 AND i.a;
-- expected: rows: 0
evaluate 'Case 5-n2';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE i.a NOT BETWEEN 1 AND 2;
-- expected: rows: 0
evaluate 'Case 5-n3';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE 5 NOT IN (i.a, 1);
-- expected: rows: 0
evaluate 'Case 5-n4';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT (i.a IN (1, 2));
-- expected: rows: 0
evaluate 'Case 5-n5';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a > 0) IS TRUE;
-- expected: rows: 0
evaluate 'Case 5-n6';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a > 0) IS FALSE;
-- expected: rows: 0
evaluate 'Case 5-n7';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a IS NOT NULL) IS TRUE;
-- expected: rows: 0
evaluate 'Case 5-n8';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE i.a = 5;
-- expected: rows: 0
evaluate 'Case 5-n9';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE 5 BETWEEN i.a AND 10;
-- expected: rows: 0
evaluate 'Case 5-n10';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT (i.a IS NULL);
-- expected: rows: 0
evaluate 'Case 5-n11';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT (i.a <> 5);
-- the reduction must still happen for null-rejecting predicates (plan: no left outer join)
-- expected: rows: 0
evaluate 'Case 5-p1';
--@queryplan
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE i.a > 0;
-- expected: rows: 0
evaluate 'Case 5-p2';
--@queryplan
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (i.a > 0) IS TRUE;
-- expected: rows: 0
evaluate 'Case 5-p3';
--@queryplan
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE i.a IS NOT NULL;
-- expected: rows: 0
evaluate 'Case 5-p4';
--@queryplan
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE i.a BETWEEN 1 AND 9;
-- expected: rows: 0
evaluate 'Case 5-p5';
--@queryplan
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE i.a + 1 > 0 AND o.b = 'x';
-- RIGHT OUTER JOIN with the sides swapped
-- expected: rows: 2
evaluate 'Case 5-r1';
SELECT COUNT(*) AS cnt FROM t05i i RIGHT OUTER JOIN t05o o ON i.a = -1 WHERE 5 NOT BETWEEN i.a AND 1;
-- expected: rows: 2
evaluate 'Case 5-r2';
SELECT COUNT(*) AS cnt FROM t05i i RIGHT OUTER JOIN t05o o ON i.a = -1 WHERE (i.a IS NOT NULL) IS FALSE;
-- expected: rows: 1
evaluate 'Case 5-r3';
SELECT COUNT(*) AS cnt FROM t05i i RIGHT OUTER JOIN t05o o ON i.a = -1 WHERE (o.b = 'x' OR i.a = 1) IS NOT NULL;
-- TLP: p, NOT p and p IS NULL add up to the 2 joined rows
-- expected: rows: 2 | 0 | 0
evaluate 'Case 5-t1';
SELECT (SELECT COUNT(*) FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE 5 NOT BETWEEN i.a AND 1) AS p, (SELECT COUNT(*) FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT (5 NOT BETWEEN i.a AND 1)) AS np, (SELECT COUNT(*) FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (5 NOT BETWEEN i.a AND 1) IS NULL) AS pn FROM db_root;
-- expected: rows: 1 | 1 | 0
evaluate 'Case 5-t2';
SELECT (SELECT COUNT(*) FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (o.b = 'x' OR i.a = 1) IS NOT NULL) AS p, (SELECT COUNT(*) FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT ((o.b = 'x' OR i.a = 1) IS NOT NULL)) AS np, (SELECT COUNT(*) FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE ((o.b = 'x' OR i.a = 1) IS NOT NULL) IS NULL) AS pn FROM db_root;
-- functions that are not NULL on a NULL argument, and aggregate subqueries that return a row from no row
-- (found while implementing: develop reduces the outer join for these too)
-- expected: rows: 2
evaluate 'Case 5-40';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE JSON_ARRAY(i.a) IS NOT NULL;
-- expected: rows: 2
evaluate 'Case 5-41';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE JSON_OBJECT('k', i.a) IS NOT NULL;
-- expected: rows: 2
evaluate 'Case 5-42';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE ELT(1, o.b, CAST(i.a AS VARCHAR)) = o.b;
-- expected: rows: 2
evaluate 'Case 5-43';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE TYPEOF(i.a) IS NOT NULL;
-- expected: rows: 2
evaluate 'Case 5-44';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE JSON_SET('{}', '$.a', i.a) IS NOT NULL;
-- expected: rows: 2
evaluate 'Case 5-45';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (SELECT COUNT(*) FROM t05i z WHERE z.a = i.a) = 0;
-- expected: rows: 2
evaluate 'Case 5-46';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE EXISTS (SELECT COUNT(*) FROM t05i z WHERE z.a = i.a);
-- expected: rows: 2
evaluate 'Case 5-47';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE 1 IN (SELECT COUNT(*) + 1 FROM t05i z WHERE z.a = i.a);
-- expected: rows: 2
evaluate 'Case 5-48';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE RAND(i.a) >= 0;
-- expected: rows: 2
evaluate 'Case 5-49';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE WEEK(DATE'2020-01-02', i.a) IS NOT NULL;
-- expected: rows: 2
evaluate 'Case 5-50';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE JSON_SEARCH('["a"]', 'one', 'a', CAST(i.a AS CHAR(1))) IS NOT NULL;
-- expected: rows: 2
evaluate 'Case 5-51';
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE NOT EXISTS (SELECT 1 FROM t05i z WHERE z.a = i.a);
-- null-rejecting subqueries and functions: the reduction stays
-- expected: rows: 0
evaluate 'Case 5-p6';
--@queryplan
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE EXISTS (SELECT 1 FROM t05i z WHERE z.a = i.a);
-- expected: rows: 0
evaluate 'Case 5-p7';
--@queryplan
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (SELECT z.a FROM t05i z WHERE z.a = i.a) = 5;
-- expected: rows: 0
evaluate 'Case 5-p8';
--@queryplan
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE REGEXP_LIKE(CAST(i.a AS VARCHAR), '5') = 1;
-- expected: rows: 0
evaluate 'Case 5-p9';
--@queryplan
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE 5 NOT IN (1, i.a);
-- MAX of no row is NULL: still null-rejecting (COUNT of no row is 0, 5-45)
-- expected: rows: 0
evaluate 'Case 5-p10';
--@queryplan
SELECT COUNT(*) AS cnt FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 WHERE (SELECT MAX(z.a) FROM t05i z WHERE z.a = i.a) = 5;
-- three tables: the predicate reads the inner table of the second outer join
-- expected: rows: 'x' | NULL | NULL / 'y' | NULL | NULL
evaluate 'Case 5-m1';
SELECT o.b, i.a, i2.a FROM t05o o LEFT OUTER JOIN t05i i ON i.a = -1 LEFT OUTER JOIN t05i i2 ON i2.a = i.a WHERE 5 NOT BETWEEN i2.a AND 1 ORDER BY 1;
DROP TABLE t05o, t05i;
