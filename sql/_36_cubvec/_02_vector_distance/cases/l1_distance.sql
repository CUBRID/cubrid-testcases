-------------------------------------------------------------------------------
-- Syntax
-------------------------------------------------------------------------------

-- Syntax/ Valid
SELECT L1_DISTANCE('[1,2,3]', '[3,2,1]')

-------------------------------------------------------------------------------
-- Semantics
-------------------------------------------------------------------------------

-- Semantics/ Number of arguments/ Error
SELECT L1_DISTANCE();
SELECT L1_DISTANCE('[1,2,3]');

-- Semantics/ Number of arguments/ Valid
SELECT L1_DISTANCE('[1,2,3]', '[3,2,1]');

-- Semantics/ Number of arguments/ Error
SELECT L1_DISTANCE('[1,2,3]', '[3,2,1]', '[1,2,3]');

-- Spec/ NULL/ Valid
SELECT L1_DISTANCE(NULL, NULL);
SELECT L1_DISTANCE(NULL, '[3,2,1]');
SELECT L1_DISTANCE('[1,2,3]', NULL);

-- Semantics/ Wrong Argument Types/ Error
SELECT L1_DISTANCE(1, '[3,2,1]');
SELECT L1_DISTANCE('[1,2,3]', 1);

-- Semantics/ Wrong Argument Types Even Though in Vector Format?
-- Is this possible in CSQL?
SELECT L1_DISTANCE('[1,2,3]' AS VARCHAR, '[3,2,1]');
SELECT L1_DISTANCE('[1,2,3]', '[3,2,1]' AS VARCHAR);
SELECT L1_DISTANCE('[1,2,3]' AS VARCHAR, '[3,2,1]' AS VARCHAR);

-- Semantics/ Wrong Argument Formats/ Error
SELECT L1_DISTANCE('hello world', '[3,2,1]');
SELECT L1_DISTANCE('[hello,world]', '[3,2,1]');
SELECT L1_DISTANCE('[1,2,3]', '[hello,world]');

-- Spec/ Not Equal Dimensions/ Error
SELECT L1_DISTANCE('[1,2,3,4]', '[3,2,1]');
SELECT L1_DISTANCE('[1,2,3]', '[3,2,1,4]');

