/**
 * This test case verifies CBRD-26227:
 *  When only_full_group_by = NO (default), non-GROUP-BY columns must NOT be output as NULL in WITH ROLLUP summary rows.
 */

-- Test Setup
DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (
    c1 int,
    c2 float,
    c3 varchar(20)
);

INSERT INTO t1 VALUES
(1, 1, 'a'),
(2, 2, 'b'), (2, 2, 'b'),
(3, 3, 'c'), (3, 3, 'c'), (3, 3, 'c');

set system parameters 'only_full_group_by=no';

evaluate 'Case 1: Single non-grouped column(c1) with ROLLUP';
select /*+ recompile */ c1, c2 from t1 group by c2 with rollup order by c2;

evaluate 'Case 2: Multiple non-grouped columns(c1, c3) with ROLLUP';
select /*+ recompile */ c1, c2, c3 from t1 group by c2 with rollup order by c2;

evaluate 'Case 3: Non-grouped column + aggregate column mixed with ROLLUP';
select /*+ recompile */ c1, c2, count(*) as cnt from t1 group by c2 with rollup order by c2;

evaluate 'Case 4: Non-grouped column with two GROUP BY items';
select /*+ recompile */ c1, c2, c3 from t1 group by c2, c3 with rollup order by c2;

DROP TABLE IF EXISTS t2;
CREATE TABLE t2 (
    c1 int,
    c2 float,
    c3 varchar(20)
);

INSERT INTO t2 VALUES
(1, 1, 'a'),
(NULL, 2, 'b'),
(3, 3, 'c'),
(NULL, 4, NULL);

evaluate 'Case 5: Non-grouped column contains actual NULL values';
select /*+ recompile */ c1, c2 from t2 group by c2 with rollup order by c2;

evaluate 'Case 6: Non-grouped column with two ORDER BY';
select /*+ recompile */ c1, c2 from t2 group by c2 with rollup order by c2, c1;

evaluate 'Case 7: Non-grouped column with HAVING and Aggregate condition';
select /*+ recompile */ c1, c2, count(*) as cnt from t2 group by c2 with rollup having count(*) >= 2 order by c2;

evaluate 'Case 8: Non-grouped expression columns with ROLLUP';
select /*+ recompile */ c1 + 1 as c1p, c2, upper(c3) as c3u from t1 group by c2 with rollup order by c2;

DROP TABLE IF EXISTS t3;
CREATE TABLE t3 (
    c1 int,
    c2 float,
    c3 varchar(20)
);

-- Check the distinction between group by NULL and rollup NULL
-- Make the c2 NULL group clear and distinguish it from the total row (ROLLUP NULL)
INSERT INTO t3 VALUES
(1, 1, 'a'),
(2, 2, 'b'),
(3, 3, 'c'),
(999, NULL, 'null_group'),
(999, NULL, 'null_group');

evaluate 'Case 9: GROUP BY key contains NULL (must produce two c2=NULL rows distinguishable by c1)';
select /*+ recompile */ c1, c2 from t3 group by c2 with rollup order by c2, c1;

set system parameters 'only_full_group_by=yes';

evaluate 'Case 10: only_full_group_by = YES should raise error';
select /*+ recompile */ c1, c2 from t2 group by c2 with rollup;

evaluate 'Case 11: only_full_group_by=YES should error for multiple non-grouped columns too';
select /*+ recompile */ c1, c2, c3 from t1 group by c2 with rollup;

-- Test Cleanup
set system parameters 'only_full_group_by=no';
DROP TABLE t1;
DROP TABLE t2;
