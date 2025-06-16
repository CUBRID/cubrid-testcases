-------------------------------------------------------------------------------
-- Syntax
-------------------------------------------------------------------------------

-- Syntax/ Valid
SELECT '[1,2,3]' <+> '[3,2,1]'
SELECT '[1,2,3]' <+> '[3,2,1]'

-- Syntax/ Error
-- Syntax/ Arguments/ Error
SELECT <+>;
SELECT '[1,2,3]' <+>;
SELECT <+> '[1,2,3]';
SELECT '[1,2,3]' <+> '[2,3,4]' <+> '[4,5,6]';

-- Syntax/ NULL/ Valid
-- SELECT NULL <+> NULL;
-- SELECT NULL <+> '[3,2,1]';
-- SELECT '[1,2,3]' <+> NULL;
-- Syntax/ Wrong Metrics/ Error

-- Syntax/ Mistyped Comma
SELECT '[1, 2]' <+> '[1, 2]',;
SELECT '[1, 2]',, '[1, 2]';
SELECT ,'[1, 2]', '[1, 2]';

-------------------------------------------------------------------------------
-- Semantics
-------------------------------------------------------------------------------

-- -- Semantics/ NULL/ Valid
-- SELECT NULL <+> NULL;
-- SELECT NULL <+> '[3,2,1]';
-- SELECT '[1,2,3]' <+> NULL;

-- Semantics/ Wrong Argument Types/ Error
-- TODO: CTP fails due to assert !vec1.empty() && !vec2.empty()
-- SELECT 1 <+> '[3,2,1]';
-- SELECT '[1,2,3]' <+> 1;

-- Semantics
-- Semantics/ Wrong Argument Formats/ Error
-- TODO: CTP fails due to assert !vec1.empty() && !vec2.empty()
-- SELECT '' <+> '[3,2,1]';
-- SELECT '[' <+> '[3,2,1]';
-- SELECT ']' <+> '[3,2,1]';
-- SELECT '[]' <+> '[3,2,1]';
-- SELECT '1' <+> '[3,2,1]';
-- SELECT '[1' <+> '[3,2,1]';
-- SELECT '1]' <+> '[3,2,1]';
-- SELECT '[1]' <+> '[3,2,1]';
-- SELECT ',' <+> '[3,2,1]';
-- SELECT '[,' <+> '[3,2,1]';
-- SELECT ',]' <+> '[3,2,1]';
-- SELECT '[,]' <+> '[3,2,1]';
-- SELECT '1,' <+> '[3,2,1]';
-- SELECT '[1,' <+> '[3,2,1]';
-- SELECT '1,]' <+> '[3,2,1]';
-- SELECT '[1,]' <+> '[3,2,1]';
-- SELECT '[1,2,3' <+> '[3,2,1]';
-- SELECT '1,2,3]' <+> '[3,2,1]';
-- SELECT '1,2,3' <+> '[3,2,1]';
-- SELECT '[3,2,1]' <+> '';
-- SELECT '[3,2,1]' <+> '[';
-- SELECT '[3,2,1]' <+> ']';
-- SELECT '[3,2,1]' <+> '[]';
-- SELECT '[3,2,1]' <+> '1';
-- SELECT '[3,2,1]' <+> '[1';
-- SELECT '[3,2,1]' <+> '1]';
-- SELECT '[3,2,1]' <+> '[1]';
-- SELECT '[3,2,1]' <+> ',';
-- SELECT '[3,2,1]' <+> '[,';
-- SELECT '[3,2,1]' <+> ',]';
-- SELECT '[3,2,1]' <+> '[,]';
-- SELECT '[3,2,1]' <+> '1,';
-- SELECT '[3,2,1]' <+> '[1,';
-- SELECT '[3,2,1]' <+> '1,]';
-- SELECT '[3,2,1]' <+> '[1,]';
-- SELECT '[3,2,1]' <+> '[1,2,3';
-- SELECT '[3,2,1]' <+> '1,2,3]';
-- SELECT '[3,2,1]' <+> '1,2,3';
-- SELECT 'hello world' <+> '[3,2,1]';
-- SELECT '[hello world' <+> '[3,2,1]';
-- SELECT 'hello world]' <+> '[3,2,1]';
-- SELECT '[hello,world]' <+> '[3,2,1]';
-- SELECT '[1,2,3]' <+> '[hello,world]';

-- Semantics/ Wrong Argument Types Even Though in Vector/ Error
-- TODO: This must fail but it works. Add Type checks.
SELECT CAST('[1,2,3]' AS VARCHAR) <+> '[3,2,1]';
SELECT '[1,2,3]' <+> CAST('[3,2,1]' AS VARCHAR);
SELECT CAST('[1,2,3]' AS VARCHAR) <+> CAST('[3,2,1]' AS VARCHAR);

-- Execution/ Not Equal Dimensions/ Error
-- TODO: CTP fails due to assert vec1.size() == vec2.size()
-- SELECT '[1,2,3,4]' <+> '[3,2,1]';
-- SELECT '[1,2,3]' <+> '[3,2,1,4]';
