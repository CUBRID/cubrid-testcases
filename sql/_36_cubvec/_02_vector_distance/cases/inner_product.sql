-------------------------------------------------------------------------------
-- Syntax
-------------------------------------------------------------------------------

-- Syntax/ Valid
SELECT INNER_PRODUCT('[1,2,3]', '[3,2,1]')

-------------------------------------------------------------------------------
-- Semantics
-------------------------------------------------------------------------------

-- Semantics/ Number of arguments/ Error
SELECT INNER_PRODUCT();
SELECT INNER_PRODUCT('[1,2,3]');

-- Semantics/ Number of arguments/ Valid
SELECT INNER_PRODUCT('[1,2,3]', '[3,2,1]');

-- Semantics/ Number of arguments/ Error
SELECT INNER_PRODUCT('[1,2,3]', '[3,2,1]', '[1,2,3]');

-- Spec/ NULL/ Valid
SELECT INNER_PRODUCT(NULL, NULL);
SELECT INNER_PRODUCT(NULL, '[3,2,1]');
SELECT INNER_PRODUCT('[1,2,3]', NULL);

-- Semantics/ Wrong Argument Types/ Error
SELECT INNER_PRODUCT(1, '[3,2,1]');
SELECT INNER_PRODUCT('[1,2,3]', 1);

-- Semantics/ Wrong Argument Types Even Though in Vector Format?
-- Is this possible in CSQL?
SELECT INNER_PRODUCT('[1,2,3]' AS VARCHAR, '[3,2,1]');
SELECT INNER_PRODUCT('[1,2,3]', '[3,2,1]' AS VARCHAR);
SELECT INNER_PRODUCT('[1,2,3]' AS VARCHAR, '[3,2,1]' AS VARCHAR);

-- Semantics/ Wrong Argument Formats/ Error
SELECT INNER_PRODUCT('hello world', '[3,2,1]');
SELECT INNER_PRODUCT('[hello,world]', '[3,2,1]');
SELECT INNER_PRODUCT('[1,2,3]', '[hello,world]');

-- Spec/ Not Equal Dimensions/ Error
SELECT INNER_PRODUCT('[1,2,3,4]', '[3,2,1]');
SELECT INNER_PRODUCT('[1,2,3]', '[3,2,1,4]');

