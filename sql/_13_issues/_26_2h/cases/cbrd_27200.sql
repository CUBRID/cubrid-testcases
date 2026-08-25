/**
 * CBRD-27200: a constant TRUE predicate (WHERE 1=1) must not be treated as a
 * real predicate when deciding whether an inline view can be merged.
 * Engine PR #7632; 11.4 backport PR #7703.
 *
 * mq_is_pushable_subquery () used "is the main query's predicate list empty?"
 * to compute is_only_spec. A folded-always-true conjunct is still in the list,
 * so is_only_spec became false and the relaxations for an outer-joined spec
 * inside the view, inst_num and ORDER BY were lost -> NON_PUSHABLE. The
 * conjunct survives because pt_where_type () strips always-true conjuncts
 * during the type-check walk, while constant folding happens in the NEXT walk:
 * a literal TRUE is already a value and gets stripped, but 1=1 is still an
 * expression at that point. The fix adds pt_true_search_condition () and uses
 * it instead of "pred == NULL".
 *
 * Every case prints, via evaluate (), whether the view is expected to be
 * merged, and is followed by show trace. The "rewritten query:" line is what
 * proves it: a merged query is flat, a blocked one keeps "from (select ...)".
 * Result values cannot tell the two apart -- the JIRA report measured 62 cases
 * and found 28 plan changes with ZERO result changes -- so without the trace
 * this test would verify nothing about the fix.
 *
 * Data mirrors the JIRA report: tleft has NULLs in b/c, and only tleft.a 1 and 3
 * match tright.x, so the LEFT OUTER JOIN produces NULL-extended rows and tright keeps
 * non-matching rows (9, 10, 20).
 *
 * Groups (67 cases; 62 of them from the attached CBRD-27200_test_report.md)
 *   A 17  constant TRUE predicates            -> merged (A00/A01 already were)
 *   B 13  real predicates                     -> unchanged
 *   C 15  view shapes, WHERE 1=1 fixed
 *   D 12  outer clauses / main-query shape, WHERE 1=1 fixed
 *   E 10  non-SELECT paths                    -> results only, no plan needed
 */

--+ server-message on

DROP TABLE IF EXISTS tleft;
DROP TABLE IF EXISTS tright;

CREATE TABLE tleft (a INT, b INT, c VARCHAR(10));
INSERT INTO tleft VALUES (1,10,'p'),(2,NULL,'q'),(3,30,NULL),(4,NULL,NULL),(5,50,'r');
CREATE TABLE tright (x INT, y INT);
INSERT INTO tright VALUES (1,100),(3,300),(9,900),(10,1000),(20,2000);

set trace on;

-- ===== Group A : constant TRUE predicates ================================
evaluate 'A00 : no predicate (baseline) -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v ORDER BY 1, 2;
show trace;

evaluate 'A01 : WHERE TRUE -- merged (already before the fix)';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE TRUE ORDER BY 1, 2;
show trace;

evaluate 'A02 : WHERE 1=1 -- merged (the reported case)';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'A03 : WHERE ''a''=''a'' -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 'a'='a' ORDER BY 1, 2;
show trace;

evaluate 'A04 : WHERE 1=1 AND 2=2 -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 AND 2=2 ORDER BY 1, 2;
show trace;

evaluate 'A05 : WHERE 2>1 -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 2>1 ORDER BY 1, 2;
show trace;

evaluate 'A06 : WHERE NOT (1=0) -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE NOT (1=0) ORDER BY 1, 2;
show trace;

evaluate 'A07 : WHERE ''abc'' LIKE ''abc'' -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 'abc' LIKE 'abc' ORDER BY 1, 2;
show trace;

evaluate 'A08 : WHERE 1=1 AND ''x''=''x'' AND 3>2 -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 AND 'x'='x' AND 3>2 ORDER BY 1, 2;
show trace;

evaluate 'A09 : WHERE 1=1 OR v.a > 0 -- merged (folds to a single TRUE)';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 OR v.a > 0 ORDER BY 1, 2;
show trace;

evaluate 'A10 : WHERE CAST(1 AS INT)=1 -- NOT merged (not folded; the boundary of this change)';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE CAST(1 AS INT)=1 ORDER BY 1, 2;
show trace;

evaluate 'A11 : WHERE 1 IN (1,2) -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1 IN (1,2) ORDER BY 1, 2;
show trace;

evaluate 'A12 : WHERE ''a'' IS NOT NULL -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 'a' IS NOT NULL ORDER BY 1, 2;
show trace;

evaluate 'A13 : WHERE 1=1 AND TRUE -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 AND TRUE ORDER BY 1, 2;
show trace;

evaluate 'A14 : WHERE 1<>0 -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1<>0 ORDER BY 1, 2;
show trace;

evaluate 'A15 : WHERE 3 BETWEEN 1 AND 5 -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 3 BETWEEN 1 AND 5 ORDER BY 1, 2;
show trace;

evaluate 'A16 : WHERE 1=1 only INSIDE the view, none outside -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x WHERE 1=1) v ORDER BY 1, 2;
show trace;

-- ===== Group B : real predicates, must stay unchanged ====================
evaluate 'B01 : WHERE v.a > 0 -- NOT merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE v.a > 0 ORDER BY 1, 2;
show trace;

evaluate 'B02 : WHERE 1=1 AND v.a > 0 -- NOT merged (a real conjunct remains)';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 AND v.a > 0 ORDER BY 1, 2;
show trace;

evaluate 'B03 : WHERE 1=0 -- always false, no plan is produced';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=0 ORDER BY 1, 2;
show trace;

evaluate 'B04 : WHERE v.a = NULL -- unknown, no plan is produced';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE v.a = NULL ORDER BY 1, 2;
show trace;

evaluate 'B05 : WHERE ROWNUM <= 2 -- merged (rownum-only predicate path)';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE ROWNUM <= 2;
show trace;

evaluate 'B06 : WHERE v.a IN (subquery) -- NOT merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE v.a IN (SELECT x FROM tright) ORDER BY 1, 2;
show trace;

evaluate 'B07 : WHERE v.a IS NOT NULL -- NOT merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE v.a IS NOT NULL ORDER BY 1, 2;
show trace;

evaluate 'B08 : WHERE v.b IS NULL -- NOT merged (filters outer-join NULL-extended rows)';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE v.b IS NULL ORDER BY 1, 2;
show trace;

evaluate 'B09 : WHERE 1=1 AND v.b IS NULL -- NOT merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 AND v.b IS NULL ORDER BY 1, 2;
show trace;

evaluate 'B10 : WHERE 0=1 OR v.a > 3 -- NOT merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 0=1 OR v.a > 3 ORDER BY 1, 2;
show trace;

evaluate 'B11 : WHERE NULL = NULL -- unknown, no plan is produced';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE NULL = NULL ORDER BY 1, 2;
show trace;

evaluate 'B12 : WHERE 1=1 AND ROWNUM <= 2 -- merged (already before the fix)';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 AND ROWNUM <= 2;
show trace;

evaluate 'B13 : WHERE v.a = v.a -- NOT merged (column reference, not a constant)';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE v.a = v.a ORDER BY 1, 2;
show trace;

-- ===== Group C : view shapes, WHERE 1=1 fixed ============================
evaluate 'C01 : inner join view -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft INNER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C02 : right outer join view -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft RIGHT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C03 : GROUP BY view -- NOT merged (blocked by another rule)';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, COUNT(*) AS b FROM tleft GROUP BY tleft.a) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C04 : ORDER BY view -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tleft.b AS b FROM tleft ORDER BY tleft.a) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C05 : DISTINCT view -- NOT merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT DISTINCT tleft.a AS a, tleft.b AS b FROM tleft) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C06 : UNION ALL view -- NOT merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT a, b FROM tleft UNION ALL SELECT x, y FROM tright) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C07 : ROWNUM inside the view -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT ROWNUM AS a, tleft.b AS b FROM tleft) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C08 : ORDER BY + LIMIT view -- NOT merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tleft.b AS b FROM tleft ORDER BY tleft.a LIMIT 3) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C09 : no join, plain view -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tleft.b AS b FROM tleft) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C10 : two nested outer joins -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b, tright_b.y AS c FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x LEFT OUTER JOIN tright tright_b ON tleft.a = tright_b.x) v WHERE 1=1 ORDER BY 1, 2, 3;
show trace;

evaluate 'C11 : outer join + aggregate -- NOT merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, COUNT(tright.y) AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x GROUP BY tleft.a) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C12 : named view over an outer join -- merged';
CREATE OR REPLACE VIEW v_oj AS SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x;
SELECT /*+ RECOMPILE */ * FROM v_oj WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C13 : view on top of a view -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT a, b FROM v_oj) v WHERE 1=1 ORDER BY 1, 2;
show trace;
DROP VIEW v_oj;

evaluate 'C14 : expression in the view select list -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a * 2 AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 ORDER BY 1, 2;
show trace;

evaluate 'C15 : CTE instead of an inline view -- merged on develop; 11.4 keeps the CTE spec';
WITH cte AS (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x)
SELECT /*+ RECOMPILE */ * FROM cte WHERE 1=1 ORDER BY 1, 2;
show trace;

-- ===== Group D : outer clauses, WHERE 1=1 fixed ==========================
evaluate 'D01 : outer ORDER BY -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 ORDER BY v.a DESC, 2;
show trace;

evaluate 'D02 : outer GROUP BY -- merged';
SELECT /*+ RECOMPILE */ v.a, COUNT(*) FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 GROUP BY v.a ORDER BY 1;
show trace;

evaluate 'D03 : outer ORDER BY ... LIMIT -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 ORDER BY v.a LIMIT 3;
show trace;

evaluate 'D04 : outer COUNT(*) -- merged';
SELECT /*+ RECOMPILE */ COUNT(*) FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1;
show trace;

evaluate 'D05 : outer DISTINCT -- merged';
SELECT /*+ RECOMPILE */ DISTINCT v.a FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 ORDER BY 1;
show trace;

evaluate 'D06 : partial column selection -- merged';
SELECT /*+ RECOMPILE */ v.b FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 ORDER BY 1;
show trace;

evaluate 'D07 : outer GROUP BY ... HAVING -- merged';
SELECT /*+ RECOMPILE */ v.a, COUNT(*) FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 GROUP BY v.a HAVING COUNT(*) >= 1 ORDER BY 1;
show trace;

evaluate 'D08 : expression in the outer select list -- merged';
SELECT /*+ RECOMPILE */ v.a * 2 FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 ORDER BY 1;
show trace;

evaluate 'D09 : ORDER BY a nullable outer-join column -- merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 ORDER BY v.b, v.a;
show trace;

evaluate 'D10 : HAVING 1=1 -- merged (HAVING is not the predicate list being checked)';
SELECT /*+ RECOMPILE */ v.a, COUNT(*) FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v GROUP BY v.a HAVING 1=1 ORDER BY 1;
show trace;

evaluate 'D11 : the view is not the only spec of the main query -- NOT merged';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v, tright w WHERE 1=1 AND v.a = w.x ORDER BY 1, 2, 3;
show trace;

evaluate 'D12 : the same two specs without any constant predicate -- NOT merged either';
SELECT /*+ RECOMPILE */ * FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v, tright w WHERE v.a = w.x ORDER BY 1, 2, 3;
show trace;

set trace off;

-- ===== Group E : non-SELECT paths, results only ==========================
evaluate 'E01 : UPDATE ... WHERE a IN (inline view ... WHERE 1=1)';
UPDATE tleft SET b = b + 1 WHERE a IN (SELECT v.a FROM (SELECT tleft.a AS a FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1);
SELECT a, b FROM tleft ORDER BY 1;

evaluate 'E02 : DELETE ... WHERE a IN (inline view ... WHERE 1=1)';
DELETE FROM tleft WHERE a IN (SELECT v.a FROM (SELECT tleft.a AS a FROM tleft WHERE tleft.a = 5) v WHERE 1=1);
SELECT a, b FROM tleft ORDER BY 1;

evaluate 'E03 : INSERT ... SELECT ... WHERE 1=1';
INSERT INTO tleft SELECT v.a + 100, v.b, 'z' FROM (SELECT tleft.a AS a, tleft.b AS b FROM tleft) v WHERE 1=1;
SELECT a, b, c FROM tleft ORDER BY 1;

evaluate 'E04 : a view that itself contains WHERE 1=1';
CREATE OR REPLACE VIEW v_true AS SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x WHERE 1=1;
SELECT * FROM v_true ORDER BY 1, 2;

evaluate 'E05 : the same view with an outer predicate';
SELECT * FROM v_true WHERE a <= 3 ORDER BY 1, 2;
DROP VIEW v_true;

evaluate 'E06 : scalar subquery containing WHERE 1=1';
SELECT (SELECT COUNT(*) FROM (SELECT tleft.a AS a FROM tleft) v WHERE 1=1) AS cnt FROM db_root;

evaluate 'E07 : UNION ALL of two inline views with WHERE 1=1';
SELECT * FROM (SELECT a FROM tleft WHERE 1=1 UNION ALL SELECT x FROM tright WHERE 1=1) v ORDER BY 1;

evaluate 'E08 : row count through the inline view';
SELECT COUNT(*) FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1;

evaluate 'E09 : outer join NULL-extended rows are preserved';
SELECT COUNT(*) FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=1 AND v.b IS NULL;

evaluate 'E10 : always-false predicate returns no rows';
SELECT COUNT(*) FROM (SELECT tleft.a AS a, tright.y AS b FROM tleft LEFT OUTER JOIN tright ON tleft.a = tright.x) v WHERE 1=0;

DROP TABLE tleft;
DROP TABLE tright;

--+ server-message off
