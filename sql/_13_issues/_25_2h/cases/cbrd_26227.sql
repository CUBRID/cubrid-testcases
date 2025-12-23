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
select /*+ recompile */ c1, c2 from t1 group by c2 with rollup;

evaluate 'Case 2: Multiple non-grouped columns(c1, c3) with ROLLUP';
select /*+ recompile */ c1, c2, c3 from t1 group by c2 with rollup;

evaluate 'Case 3: Non-grouped column with Aggregate function';
select /*+ recompile */ c1, c2, count(*) as cnt from t1 group by c2 with rollup;

evaluate 'Case 4: Non-grouped column with two GROUP BY items';
select /*+ recompile */ c1, c2, c3 from t1 group by c2, c3 with rollup;

DROP TABLE IF EXISTS t2;
CREATE TABLE t2 (
    c1 int,
    c2 float,
    c3 varchar(20)
);

INSERT INTO t2 VALUES
(1, 1, 'a'),
(NULL, 2, 'b'),
(3, NULL, 'c'),
(NULL, NULL, NULL);

evaluate 'Case 5: Non-grouped column contains actual NULL values';
select /*+ recompile */ c1, c2 from t2 group by c2 with rollup;

evaluate 'Case 6: Non-grouped column with ORDER BY';
select /*+ recompile */ c1, c2 from t2 group by c2 with rollup order by c2;

evaluate 'Case 7: Non-grouped column with HAVING and Aggregate condition';
select /*+ recompile */ c1, c2, count(*) as cnt from t2 group by c2 with rollup having count(*) >= 1;

evaluate 'Case 8: only_full_group_by = YES should raise error';
set system parameters 'only_full_group_by=yes';
select /*+ recompile */ c1, c2 from t2 group by c2 with rollup;

-- Test Cleanup
set system parameters 'only_full_group_by=no';
DROP TABLE t1;
DROP TABLE t2;
