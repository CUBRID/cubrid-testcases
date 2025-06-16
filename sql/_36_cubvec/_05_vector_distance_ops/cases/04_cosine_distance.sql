-------------------------------------------------------------------------------
-- Syntax
-------------------------------------------------------------------------------

-- Syntax/ Valid
SELECT '[1,2,3]' <c> '[3,2,1]'
SELECT '[1,2,3]' <c> '[3,2,1]'

-- Syntax/ Error
-- Syntax/ Arguments/ Error
SELECT <c>;
SELECT '[1,2,3]' <c>;
SELECT <c> '[1,2,3]';
SELECT '[1,2,3]' <c> '[2,3,4]' <c> '[4,5,6]';

-- Syntax/ NULL/ Valid
-- SELECT NULL <c> NULL;
-- SELECT NULL <c> '[3,2,1]';
-- SELECT '[1,2,3]' <c> NULL;
-- Syntax/ Wrong Metrics/ Error

-- Syntax/ Mistyped Comma
SELECT '[1, 2]' <c> '[1, 2]',;
SELECT '[1, 2]',, '[1, 2]';
SELECT ,'[1, 2]', '[1, 2]';

-------------------------------------------------------------------------------
-- Semantics
-------------------------------------------------------------------------------

-- -- Semantics/ NULL/ Valid
-- SELECT NULL <c> NULL;
-- SELECT NULL <c> '[3,2,1]';
-- SELECT '[1,2,3]' <c> NULL;

-- Semantics/ Wrong Argument Types/ Error
-- TODO: CTP fails due to assert !vec1.empty() && !vec2.empty()
-- SELECT 1 <c> '[3,2,1]';
-- SELECT '[1,2,3]' <c> 1;

-- Semantics
-- Semantics/ Wrong Argument Formats/ Error
-- TODO: CTP fails due to assert !vec1.empty() && !vec2.empty()
-- SELECT '' <c> '[3,2,1]';
-- SELECT '[' <c> '[3,2,1]';
-- SELECT ']' <c> '[3,2,1]';
-- SELECT '[]' <c> '[3,2,1]';
-- SELECT '1' <c> '[3,2,1]';
-- SELECT '[1' <c> '[3,2,1]';
-- SELECT '1]' <c> '[3,2,1]';
-- SELECT '[1]' <c> '[3,2,1]';
-- SELECT ',' <c> '[3,2,1]';
-- SELECT '[,' <c> '[3,2,1]';
-- SELECT ',]' <c> '[3,2,1]';
-- SELECT '[,]' <c> '[3,2,1]';
-- SELECT '1,' <c> '[3,2,1]';
-- SELECT '[1,' <c> '[3,2,1]';
-- SELECT '1,]' <c> '[3,2,1]';
-- SELECT '[1,]' <c> '[3,2,1]';
-- SELECT '[1,2,3' <c> '[3,2,1]';
-- SELECT '1,2,3]' <c> '[3,2,1]';
-- SELECT '1,2,3' <c> '[3,2,1]';
-- SELECT '[3,2,1]' <c> '';
-- SELECT '[3,2,1]' <c> '[';
-- SELECT '[3,2,1]' <c> ']';
-- SELECT '[3,2,1]' <c> '[]';
-- SELECT '[3,2,1]' <c> '1';
-- SELECT '[3,2,1]' <c> '[1';
-- SELECT '[3,2,1]' <c> '1]';
-- SELECT '[3,2,1]' <c> '[1]';
-- SELECT '[3,2,1]' <c> ',';
-- SELECT '[3,2,1]' <c> '[,';
-- SELECT '[3,2,1]' <c> ',]';
-- SELECT '[3,2,1]' <c> '[,]';
-- SELECT '[3,2,1]' <c> '1,';
-- SELECT '[3,2,1]' <c> '[1,';
-- SELECT '[3,2,1]' <c> '1,]';
-- SELECT '[3,2,1]' <c> '[1,]';
-- SELECT '[3,2,1]' <c> '[1,2,3';
-- SELECT '[3,2,1]' <c> '1,2,3]';
-- SELECT '[3,2,1]' <c> '1,2,3';
-- SELECT 'hello world' <c> '[3,2,1]';
-- SELECT '[hello world' <c> '[3,2,1]';
-- SELECT 'hello world]' <c> '[3,2,1]';
-- SELECT '[hello,world]' <c> '[3,2,1]';
-- SELECT '[1,2,3]' <c> '[hello,world]';

-- Semantics/ Wrong Argument Types Even Though in Vector/ Error
-- TODO: This must fail but it works. Add Type checks.
SELECT CAST('[1,2,3]' AS VARCHAR) <c> '[3,2,1]';
SELECT '[1,2,3]' <c> CAST('[3,2,1]' AS VARCHAR);
SELECT CAST('[1,2,3]' AS VARCHAR) <c> CAST('[3,2,1]' AS VARCHAR);

-- Execution/ Not Equal Dimensions/ Error
-- TODO: CTP fails due to assert vec1.size() == vec2.size()
-- SELECT '[1,2,3,4]' <c> '[3,2,1]';
-- SELECT '[1,2,3]' <c> '[3,2,1,4]';
