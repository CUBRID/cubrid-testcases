-------------------------------------------------------------------------------
-- Syntax
-------------------------------------------------------------------------------

-- Syntax: Valid
SELECT COSINE_DISTANCE('[1,2,3]', '[3,2,1]')

-------------------------------------------------------------------------------
-- Semantics
-------------------------------------------------------------------------------

-- Semantics: Number of arguments: Error
SELECT COSINE_DISTANCE();
SELECT COSINE_DISTANCE('[1,2,3]');

-- Semantics: Number of arguments: Valid
SELECT COSINE_DISTANCE('[1,2,3]', '[3,2,1]');

-- Semantics: Number of arguments: Error
SELECT COSINE_DISTANCE('[1,2,3]', '[3,2,1]', '[1,2,3]');

-- Spec: NULL: Valid
SELECT COSINE_DISTANCE(NULL, NULL);
SELECT COSINE_DISTANCE(NULL, '[3,2,1]');
SELECT COSINE_DISTANCE('[1,2,3]', NULL);

-- Semantics: Wrong Argument Types: Error
SELECT COSINE_DISTANCE(1, '[3,2,1]');
SELECT COSINE_DISTANCE('[1,2,3]', 1);

-- Semantics: Wrong Argument Types Even Though in Vector Format?
-- Is this possible in CSQL?
SELECT COSINE_DISTANCE('[1,2,3]' AS VARCHAR, '[3,2,1]');
SELECT COSINE_DISTANCE('[1,2,3]', '[3,2,1]' AS VARCHAR);
SELECT COSINE_DISTANCE('[1,2,3]' AS VARCHAR, '[3,2,1]' AS VARCHAR);

-- Semantics: Wrong Argument Formats: Error
SELECT COSINE_DISTANCE('hello world', '[3,2,1]');
SELECT COSINE_DISTANCE('[hello,world]', '[3,2,1]');
SELECT COSINE_DISTANCE('[1,2,3]', '[hello,world]');

-- Spec: Not Equal Dimensions: Error
SELECT COSINE_DISTANCE('[1,2,3,4]', '[3,2,1]');
SELECT COSINE_DISTANCE('[1,2,3]', '[3,2,1,4]');

