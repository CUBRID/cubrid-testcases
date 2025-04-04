-------------------------------------------------------------------------------
-- Syntax
-------------------------------------------------------------------------------

-- Syntax/ Valid
SELECT inner_product('[1,2,3]', '[3,2,1]')
SELECT INNER_PRODUCT('[1,2,3]', '[3,2,1]')

-- Syntax/ Error
-- Syntax/ Arguments/ Error
SELECT INNER_PRODUCT();
SELECT INNER_PRODUCT('[1,2,3]');
SELECT INNER_PRODUCT('[1,2,3]', EUCLIDEAN);
SELECT INNER_PRODUCT('[1,2,3]', '[3,2,1]', COSINE);
SELECT INNER_PRODUCT('[1,2,3]', '[3,2,1]', hello);
SELECT INNER_PRODUCT('[1,2,3]', '[3,2,1]', '1234');
SELECT INNER_PRODUCT('[1,2,3]', '[3,2,1]', '[1,2,3]');

-- Syntax/ NULL/ Valid
-- SELECT INNER_PRODUCT(NULL, NULL);
-- SELECT INNER_PRODUCT(NULL, '[3,2,1]');
-- SELECT INNER_PRODUCT('[1,2,3]', NULL);
-- Syntax/ Wrong Metrics/ Error

-- Syntax/ Mistyped Comma
SELECT INNER_PRODUCT('[1, 2]', '[1, 2]',);
SELECT INNER_PRODUCT('[1, 2]',, '[1, 2]');
SELECT INNER_PRODUCT(,'[1, 2]', '[1, 2]');

-------------------------------------------------------------------------------
-- Semantics
-------------------------------------------------------------------------------

-- -- Semantics/ NULL/ Valid
-- SELECT INNER_PRODUCT(NULL, NULL);
-- SELECT INNER_PRODUCT(NULL, '[3,2,1]');
-- SELECT INNER_PRODUCT('[1,2,3]', NULL);

-- Semantics/ Wrong Argument Types/ Error
-- TODO: CTP fails due to assert !vec1.empty() && !vec2.empty()
-- SELECT INNER_PRODUCT(1, '[3,2,1]');
-- SELECT INNER_PRODUCT('[1,2,3]', 1);

-- Semantics
-- Semantics/ Wrong Argument Formats/ Error
-- TODO: CTP fails due to assert !vec1.empty() && !vec2.empty()
-- SELECT INNER_PRODUCT('', '[3,2,1]');
-- SELECT INNER_PRODUCT('[', '[3,2,1]');
-- SELECT INNER_PRODUCT(']', '[3,2,1]');
-- SELECT INNER_PRODUCT('[]', '[3,2,1]');
-- SELECT INNER_PRODUCT('1', '[3,2,1]');
-- SELECT INNER_PRODUCT('[1', '[3,2,1]');
-- SELECT INNER_PRODUCT('1]', '[3,2,1]');
-- SELECT INNER_PRODUCT('[1]', '[3,2,1]');
-- SELECT INNER_PRODUCT(',', '[3,2,1]');
-- SELECT INNER_PRODUCT('[,', '[3,2,1]');
-- SELECT INNER_PRODUCT(',]', '[3,2,1]');
-- SELECT INNER_PRODUCT('[,]', '[3,2,1]');
-- SELECT INNER_PRODUCT('1,', '[3,2,1]');
-- SELECT INNER_PRODUCT('[1,', '[3,2,1]');
-- SELECT INNER_PRODUCT('1,]', '[3,2,1]');
-- SELECT INNER_PRODUCT('[1,]', '[3,2,1]');
-- SELECT INNER_PRODUCT('[1,2,3', '[3,2,1]');
-- SELECT INNER_PRODUCT('1,2,3]', '[3,2,1]');
-- SELECT INNER_PRODUCT('1,2,3', '[3,2,1]');
-- SELECT INNER_PRODUCT('[3,2,1]', '');
-- SELECT INNER_PRODUCT('[3,2,1]', '[');
-- SELECT INNER_PRODUCT('[3,2,1]', ']');
-- SELECT INNER_PRODUCT('[3,2,1]', '[]');
-- SELECT INNER_PRODUCT('[3,2,1]', '1');
-- SELECT INNER_PRODUCT('[3,2,1]', '[1');
-- SELECT INNER_PRODUCT('[3,2,1]', '1]');
-- SELECT INNER_PRODUCT('[3,2,1]', '[1]');
-- SELECT INNER_PRODUCT('[3,2,1]', ',');
-- SELECT INNER_PRODUCT('[3,2,1]', '[,');
-- SELECT INNER_PRODUCT('[3,2,1]', ',]');
-- SELECT INNER_PRODUCT('[3,2,1]', '[,]');
-- SELECT INNER_PRODUCT('[3,2,1]', '1,');
-- SELECT INNER_PRODUCT('[3,2,1]', '[1,');
-- SELECT INNER_PRODUCT('[3,2,1]', '1,]');
-- SELECT INNER_PRODUCT('[3,2,1]', '[1,]');
-- SELECT INNER_PRODUCT('[3,2,1]', '[1,2,3');
-- SELECT INNER_PRODUCT('[3,2,1]', '1,2,3]');
-- SELECT INNER_PRODUCT('[3,2,1]', '1,2,3');
-- SELECT INNER_PRODUCT('hello world', '[3,2,1]');
-- SELECT INNER_PRODUCT('[hello world', '[3,2,1]');
-- SELECT INNER_PRODUCT('hello world]', '[3,2,1]');
-- SELECT INNER_PRODUCT('[hello,world]', '[3,2,1]');
-- SELECT INNER_PRODUCT('[1,2,3]', '[hello,world]');

-- Semantics/ Wrong Argument Types Even Though in Vector/ Error
-- TODO: This must fail but it works. Add Type checks.
SELECT INNER_PRODUCT(CAST('[1,2,3]' AS VARCHAR), '[3,2,1]');
SELECT INNER_PRODUCT('[1,2,3]', CAST('[3,2,1]' AS VARCHAR));
SELECT INNER_PRODUCT(CAST('[1,2,3]' AS VARCHAR), CAST('[3,2,1]' AS VARCHAR));

-- Execution/ Not Equal Dimensions/ Error
-- TODO: CTP fails due to assert vec1.size() == vec2.size()
-- SELECT INNER_PRODUCT('[1,2,3,4]', '[3,2,1]');
-- SELECT INNER_PRODUCT('[1,2,3]', '[3,2,1,4]');

