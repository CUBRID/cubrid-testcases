-------------------------------------------------------------------------------
-- Syntax
-------------------------------------------------------------------------------

-- Syntax/ Valid
SELECT L2_DISTANCE('[1,2,3]', '[3,2,1]')

-------------------------------------------------------------------------------
-- Semantics
-------------------------------------------------------------------------------

-- Semantics/ Number of arguments/ Error
SELECT L2_DISTANCE();
SELECT L2_DISTANCE('[1,2,3]');

-- Semantics/ Number of arguments/ Valid
SELECT L2_DISTANCE('[1,2,3]', '[3,2,1]');

-- Semantics/ Number of arguments/ Error
SELECT L2_DISTANCE('[1,2,3]', '[3,2,1]', '[1,2,3]');

-- Spec/ NULL/ Valid
SELECT L2_DISTANCE(NULL, NULL);
SELECT L2_DISTANCE(NULL, '[3,2,1]');
SELECT L2_DISTANCE('[1,2,3]', NULL);

-- Semantics/ Wrong Argument Types/ Error
SELECT L2_DISTANCE(1, '[3,2,1]');
SELECT L2_DISTANCE('[1,2,3]', 1);

-- Semantics/ Wrong Argument Types Even Though in Vector Format?
-- Is this possible in CSQL?
SELECT L2_DISTANCE('[1,2,3]' AS VARCHAR, '[3,2,1]');
SELECT L2_DISTANCE('[1,2,3]', '[3,2,1]' AS VARCHAR);
SELECT L2_DISTANCE('[1,2,3]' AS VARCHAR, '[3,2,1]' AS VARCHAR);

-- Semantics/ Wrong Argument Formats/ Error
SELECT L2_DISTANCE('hello world', '[3,2,1]');
SELECT L2_DISTANCE('[hello,world]', '[3,2,1]');
SELECT L2_DISTANCE('[1,2,3]', '[hello,world]');

-- Spec/ Not Equal Dimensions/ Error
SELECT L2_DISTANCE('[1,2,3,4]', '[3,2,1]');
SELECT L2_DISTANCE('[1,2,3]', '[3,2,1,4]');

