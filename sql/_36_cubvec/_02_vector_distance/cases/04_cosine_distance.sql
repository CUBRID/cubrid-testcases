-------------------------------------------------------------------------------
-- Syntax
-------------------------------------------------------------------------------

-- Syntax/ Valid
SELECT cosine_distance('[1,2,3]', '[3,2,1]')
SELECT COSINE_DISTANCE('[1,2,3]', '[3,2,1]')

-- Syntax/ Error
-- Syntax/ Arguments/ Error
SELECT COSINE_DISTANCE();
SELECT COSINE_DISTANCE('[1,2,3]');
SELECT COSINE_DISTANCE('[1,2,3]', EUCLIDEAN);
SELECT COSINE_DISTANCE('[1,2,3]', '[3,2,1]', COSINE);
SELECT COSINE_DISTANCE('[1,2,3]', '[3,2,1]', hello);
SELECT COSINE_DISTANCE('[1,2,3]', '[3,2,1]', '1234');
SELECT COSINE_DISTANCE('[1,2,3]', '[3,2,1]', '[1,2,3]');

-- Syntax/ NULL/ Valid
-- SELECT COSINE_DISTANCE(NULL, NULL);
-- SELECT COSINE_DISTANCE(NULL, '[3,2,1]');
-- SELECT COSINE_DISTANCE('[1,2,3]', NULL);
-- Syntax/ Wrong Metrics/ Error

-- Syntax/ Mistyped Comma
SELECT COSINE_DISTANCE('[1, 2]', '[1, 2]',);
SELECT COSINE_DISTANCE('[1, 2]',, '[1, 2]');
SELECT COSINE_DISTANCE(,'[1, 2]', '[1, 2]');

-------------------------------------------------------------------------------
-- Semantics
-------------------------------------------------------------------------------

-- -- Semantics/ NULL/ Valid
-- SELECT COSINE_DISTANCE(NULL, NULL);
-- SELECT COSINE_DISTANCE(NULL, '[3,2,1]');
-- SELECT COSINE_DISTANCE('[1,2,3]', NULL);

-- Semantics/ Wrong Argument Types/ Error
-- TODO: CTP fails due to assert !vec1.empty() && !vec2.empty()
-- SELECT COSINE_DISTANCE(1, '[3,2,1]');
-- SELECT COSINE_DISTANCE('[1,2,3]', 1);

-- Semantics
-- Semantics/ Wrong Argument Formats/ Error
-- TODO: CTP fails due to assert !vec1.empty() && !vec2.empty()
-- SELECT COSINE_DISTANCE('', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[', '[3,2,1]');
-- SELECT COSINE_DISTANCE(']', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[]', '[3,2,1]');
-- SELECT COSINE_DISTANCE('1', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[1', '[3,2,1]');
-- SELECT COSINE_DISTANCE('1]', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[1]', '[3,2,1]');
-- SELECT COSINE_DISTANCE(',', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[,', '[3,2,1]');
-- SELECT COSINE_DISTANCE(',]', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[,]', '[3,2,1]');
-- SELECT COSINE_DISTANCE('1,', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[1,', '[3,2,1]');
-- SELECT COSINE_DISTANCE('1,]', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[1,]', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[1,2,3', '[3,2,1]');
-- SELECT COSINE_DISTANCE('1,2,3]', '[3,2,1]');
-- SELECT COSINE_DISTANCE('1,2,3', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[3,2,1]', '');
-- SELECT COSINE_DISTANCE('[3,2,1]', '[');
-- SELECT COSINE_DISTANCE('[3,2,1]', ']');
-- SELECT COSINE_DISTANCE('[3,2,1]', '[]');
-- SELECT COSINE_DISTANCE('[3,2,1]', '1');
-- SELECT COSINE_DISTANCE('[3,2,1]', '[1');
-- SELECT COSINE_DISTANCE('[3,2,1]', '1]');
-- SELECT COSINE_DISTANCE('[3,2,1]', '[1]');
-- SELECT COSINE_DISTANCE('[3,2,1]', ',');
-- SELECT COSINE_DISTANCE('[3,2,1]', '[,');
-- SELECT COSINE_DISTANCE('[3,2,1]', ',]');
-- SELECT COSINE_DISTANCE('[3,2,1]', '[,]');
-- SELECT COSINE_DISTANCE('[3,2,1]', '1,');
-- SELECT COSINE_DISTANCE('[3,2,1]', '[1,');
-- SELECT COSINE_DISTANCE('[3,2,1]', '1,]');
-- SELECT COSINE_DISTANCE('[3,2,1]', '[1,]');
-- SELECT COSINE_DISTANCE('[3,2,1]', '[1,2,3');
-- SELECT COSINE_DISTANCE('[3,2,1]', '1,2,3]');
-- SELECT COSINE_DISTANCE('[3,2,1]', '1,2,3');
-- SELECT COSINE_DISTANCE('hello world', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[hello world', '[3,2,1]');
-- SELECT COSINE_DISTANCE('hello world]', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[hello,world]', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[1,2,3]', '[hello,world]');

-- Semantics/ Wrong Argument Types Even Though in Vector/ Error
-- TODO: This must fail but it works. Add Type checks.
SELECT COSINE_DISTANCE(CAST('[1,2,3]' AS VARCHAR), '[3,2,1]');
SELECT COSINE_DISTANCE('[1,2,3]', CAST('[3,2,1]' AS VARCHAR));
SELECT COSINE_DISTANCE(CAST('[1,2,3]' AS VARCHAR), CAST('[3,2,1]' AS VARCHAR));

-- Execution/ Not Equal Dimensions/ Error
-- TODO: CTP fails due to assert vec1.size() == vec2.size()
-- SELECT COSINE_DISTANCE('[1,2,3,4]', '[3,2,1]');
-- SELECT COSINE_DISTANCE('[1,2,3]', '[3,2,1,4]');

