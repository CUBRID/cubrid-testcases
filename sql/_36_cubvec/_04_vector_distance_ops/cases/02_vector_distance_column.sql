-------------------------------------------------------------------------------
-- Syntax
-------------------------------------------------------------------------------

DROP IF EXISTS test_non_vector;
CREATE TABLE test_non_vector (
    id INT,
    name VECTOR(3)
);
INSERT INTO test_non_vector VALUES (1, '[1, 2, 3]');
-- Syntax/ Wrong Comma/ Error
SELECT '[2, 3, 4]' <c>, name FROM test_non_vector;
SELECT '[2, 3, 4]' <c> name FROM test_non_vector;
SELECT '[2, 3, 4]' <c> name, FROM test_non_vector;
SELECT , '[2, 3, 4]' <c> name, FROM test_non_vector;
SELECT '[2, 3, 4]' <c> name, FROM test_non_vector;
SELECT , '[2, 3, 4]' <c> name FROM test_non_vector;
SELECT name <c> , name FROM test_non_vector;
SELECT name <c> name FROM test_non_vector;
SELECT name <c> name, FROM test_non_vector;
SELECT , name <c> name, FROM test_non_vector;
SELECT name <c> name, FROM test_non_vector;
SELECT , name <c> name FROM test_non_vector;

-------------------------------------------------------------------------------
-- Semantics
-------------------------------------------------------------------------------

-- Semantics/ Argument type mistmatch/ Error
DROP IF EXISTS test_non_vector;
CREATE TABLE test_non_vector (
    id INT,
    name VARCHAR(50)
);
INSERT INTO test_non_vector VALUES (1, 'Alice');
SELECT name <-> name FROM test_non_vector;
SELECT name <c> name FROM test_non_vector;
SELECT name <#> name FROM test_non_vector;
SELECT name <+> name FROM test_non_vector;

-- Semantics/ Argument looks like vector but not vector type/ Error
DROP IF EXISTS test_non_vector;
CREATE TABLE test_non_vector (
    id INT,
    name VARCHAR(50)
);
INSERT INTO test_non_vector VALUES (1, '[1,2,3]');
SELECT name <-> name FROM test_non_vector;
SELECT name <c> name FROM test_non_vector;
SELECT name <#> name FROM test_non_vector;
SELECT name <+> name FROM test_non_vector;

-- Semantics/ Vector and non-vector/ Error
DROP IF EXISTS test_non_vector;
CREATE TABLE test_non_vector (
    id INT,
    name VARCHAR(50),
    vec VECTOR(3)
);
-- Semantics/ Vector and non-vector/ Vector and Varchar/ Error
-- TODO: currently no error. Add type checks.
INSERT INTO test_non_vector VALUES (1, '[3,2,1]', '[1,2,3]');
INSERT INTO test_non_vector VALUES (2, '[2,3,4]', '[4,5,6]');
SELECT vec <-> name FROM test_non_vector;
SELECT name <-> vec FROM test_non_vector;
SELECT name <c> vec FROM test_non_vector;
SELECT vec <c> name FROM test_non_vector;
SELECT name <#> vec FROM test_non_vector;
SELECT name <+> vec FROM test_non_vector;

-- Semantics/ Vector and non-vector/ Vector and Int/ Error
SELECT vec <-> id FROM test_non_vector;
SELECT id <-> vec FROM test_non_vector;
SELECT id <c> vec FROM test_non_vector;
SELECT vec <c> id FROM test_non_vector;
SELECT id <#> vec FROM test_non_vector;
SELECT id <+> vec FROM test_non_vector;

-- Semantics/ Vector Element Type Not Binary/ Valid
SELECT vec <-> vec FROM test_non_vector;
SELECT vec <c> vec FROM test_non_vector;
-- Semantics/ Vector Element Type Not Binary/ Error
-- SELECT vec <~> vec FROM test_non_vector;
-- SELECT vec <@> vec FROM test_non_vector;

-------------------------------------------------------------------------------
-- Execution
-------------------------------------------------------------------------------

-- Execution/ Two Column Arguments/ Valid
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(3)
);
INSERT INTO test_vector_table VALUES (1, '[1,2,3]');
INSERT INTO test_vector_table VALUES (2, '[3,2,1]');

SELECT '[33, 44, 55]' <c> t2.vector_col
FROM test_vector_table t2;
SELECT '[33, 44, 55]' <#> t2.vector_col
FROM test_vector_table t2;
SELECT '[33, 44, 55]' <+> t2.vector_col
FROM test_vector_table t2;
SELECT '[33, 44, 55]' <-> t2.vector_col
FROM test_vector_table t2;

SELECT t1.vector_col <c> '[33, 44, 55]'
FROM test_vector_table t1;
SELECT t1.vector_col <#> '[33, 44, 55]'
FROM test_vector_table t1;
SELECT t1.vector_col <+> '[33, 44, 55]'
FROM test_vector_table t1;
SELECT t1.vector_col <-> '[33, 44, 55]'
FROM test_vector_table t1;

SELECT t1.vector_col <c> t2.vector_col
FROM test_vector_table t1, test_vector_table t2;
SELECT t1.vector_col <#> t2.vector_col
FROM test_vector_table t1, test_vector_table t2;
SELECT t1.vector_col <+> t2.vector_col
FROM test_vector_table t1, test_vector_table t2;
SELECT t1.vector_col <-> t2.vector_col
FROM test_vector_table t1, test_vector_table t2;

-- Execution/ Column and a literal/ Valid
SELECT
    vector_col <c> '[2, 3, 4]',
    vector_col <#> '[2, 3, 4]',
    vector_col <+> '[2, 3, 4]',
    vector_col <-> '[2, 3, 4]'
FROM test_vector_table;

SELECT
    '[2, 3, 4]' <c> vector_col,
    '[2, 3, 4]' <#> vector_col,
    '[2, 3, 4]' <+> vector_col,
    '[2, 3, 4]' <-> vector_col
FROM test_vector_table;

-- -- Execution/ NULL and column/ Valid
-- SELECT
--     NULL <-> vector_col,
--     NULL <c> vector_col,
--     NULL <#> vector_col,
--     NULL <+> vector_col,
--     NULL <-> vector_col
-- FROM test_vector_table;

-- -- Execution/ column and NULL/ Valid
-- SELECT
--     vector_col <c> NULL,
--     vector_col <#> NULL,
--     vector_col <+> NULL,
--     vector_col <-> NULL
-- FROM test_vector_table;

-- Execution/ Different vector dimensions
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR
);
DROP IF EXISTS test_vector_table2;
CREATE TABLE test_vector_table2 (
    id INT,
    vector_col VECTOR
);
INSERT INTO test_vector_table VALUES (1, '[1,2,3]');
INSERT INTO test_vector_table VALUES (2, '[1,2,3,4]');
INSERT INTO test_vector_table VALUES (3, '[1,2]');
INSERT INTO test_vector_table2 VALUES (1, '[1,2,3,4]');
INSERT INTO test_vector_table2 VALUES (2, '[1,2,3]');
INSERT INTO test_vector_table VALUES (3, '[1,2]');

-- Execution / Different vector dimensions/ With itself/ Valid
SELECT
    t1.vector_col <c> t1.vector_col,
    t1.vector_col <#> t1.vector_col,
    t1.vector_col <+> t1.vector_col,
    t1.vector_col <-> t1.vector_col
FROM test_vector_table t1;

-- Execution / Different vector dimensions/ With Constant Vectors/ Error
-- TODO: disable due to CTP crash (with assert()). Enable after error handling.
-- SELECT
--     '[1,2,3]' <c> t2.vector_col,
--     '[1,2,3]' <#> t2.vector_col,
--     '[1,2,3]' <+> t2.vector_col,
--     '[1,2,3]' <-> t2.vector_col
-- FROM test_vector_table t1, test_vector_table t2;

-- Execution / Different vector dimensions/ With table of different dimensions/ Error
-- TODO: disable due to CTP crash (with assert()). Enable after error handling.
-- SELECT
--     t1.vector_col <c> t2.vector_col,
--     t1.vector_col <#> t2.vector_col,
--     t1.vector_col <+> t2.vector_col,
--     t1.vector_col <-> t2.vector_col
-- FROM test_vector_table t1, test_vector_table2 t2;

-- Execution/ Empty vectors/ Error
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR
);
INSERT INTO test_vector_table VALUES (1, '[]');
INSERT INTO test_vector_table VALUES (2, '[1,2,3]');
-- TODO: disable due to CTP crash (with assert()). Enable after error handling.
-- SELECT
--     t1.vector_col <c> t2.vector_col
-- FROM test_vector_table t1, test_vector_table t2;

-- Execution/ Zero vectors/ Valid
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(4)
);
INSERT INTO test_vector_table VALUES (1, '[0,0,0,0]');
INSERT INTO test_vector_table VALUES (2, '[0,0,0,0]');
SELECT
    t1.vector_col <c> t2.vector_col,
    t1.vector_col <#> t2.vector_col,
    t1.vector_col <+> t2.vector_col,
    t1.vector_col <-> t2.vector_col
FROM test_vector_table t1, test_vector_table t2;

-- Execution/ Negative values/ Valid
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(3)
);
INSERT INTO test_vector_table VALUES (1, '[-1,-2,-3]');
INSERT INTO test_vector_table VALUES (2, '[1,2,3]');
SELECT
    t1.vector_col <c> t2.vector_col,
    t1.vector_col <#> t2.vector_col,
    t1.vector_col <+> t2.vector_col,
    t1.vector_col <-> t2.vector_col
FROM test_vector_table t1, test_vector_table t2;

-- Execution/ Non integer values/ Valid
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(3)
);
INSERT INTO test_vector_table VALUES (1, '[1.5,2.5,3.5]');
INSERT INTO test_vector_table VALUES (2, '[0.1,0.2,0.3]');
SELECT
    t1.vector_col <c> t2.vector_col,
    t1.vector_col <#> t2.vector_col,
    t1.vector_col <+> t2.vector_col,
    t1.vector_col <-> t2.vector_col
FROM test_vector_table t1, test_vector_table t2;

-- Execution/ large numbers/ Valid
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(3)
);
INSERT INTO test_vector_table VALUES (1, '[1e10,2e10,3e10]');
INSERT INTO test_vector_tablE VALUES (2, '[1e-10,2e-10,3e-10]');
SELECT
    t1.vector_col <c> t2.vector_col,
    t1.vector_col <#> t2.vector_col,
    t1.vector_col <+> t2.vector_col,
    t1.vector_col <-> t2.vector_col
FROM test_vector_table t1, test_vector_table t2;

-- Execution/ very large numbers exceeding floating points range/ Error
DROP IF EXISTS test_vector_table;
CREATE TABLE test_vector_table (
    id INT,
    vector_col VECTOR(3)
);
INSERT INTO test_vector_table VALUES (1, '[1e100,2e100,3e100]'); -- error
-- No way yet to insert vectors with very large numbers.
-- SELECT
--     t1.vector_col <c> t2.vector_col,
--     t1.vector_col <#> t2.vector_col,
--     t1.vector_col <+> t2.vector_col,
--     t1.vector_col <-> t2.vector_col
-- FROM test_vector_table t1, test_vector_table t2;
