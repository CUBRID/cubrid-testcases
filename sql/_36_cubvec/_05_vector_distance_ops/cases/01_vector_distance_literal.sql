-------------------------------------------------------------------------------
-- Syntax
-------------------------------------------------------------------------------

-- Syntax/ Metrics/ Valid
-- TODO:Add more testcases where the third argument (metric) is omitted.
SELECT '[1,2,3]' <c> '[3,2,1]';
SELECT '[1,2,3]' <-> '[3,2,1]';
SELECT '[1,2,3]' <+> '[3,2,1]';
SELECT '[1,2,3]' <#> '[3,2,1]';
SELECT '[1,2,3]' <=> '[3,2,1]'; -- CUBRID null safe equality
-- Not Implemented/
-- SELECT '[1,2,3]' <~> '[3,2,1]'; -- hamming
-- SELECT '[1,2,3]' <%> '[3,2,1]'; -- jaccard
-- Syntax/ Operators/ Error
SELECT '[1,2,3]' hello '[3,2,1]';

-- Syntax/ Arguments/ Valid
SELECT '[1,2,3]' <-> '[3,2,1]';
-- Syntax/ Arguments/ Error
SELECT <->;
SELECT '[1,2,3]' <->;
SELECT <-> '[3,2,1]';

-- Syntax/ Null Arguments/ Valid
-- -- NULL arguments
-- SELECT '[1,2,3]' <-> NULL;
-- SELECT NULL <-> '[1,2,3]';
-- SELECT NULL <-> NULL;

-- Syntax/ Wrong Argument Types/ Error
SELECT 1 <-> 1;
SELECT 1 <-> '[3,2,1]';
SELECT '[1,2,3]' <-> 1;

-------------------------------------------------------------------------------
-- Semantics
-------------------------------------------------------------------------------

-- Semantics/ Wrong Argument Formats/ Error
-- SELECT '' <-> '[3,2,1]';
-- SELECT '[' <-> '[3,2,1]';
-- SELECT ']' <-> '[3,2,1]';
-- SELECT '[]' <-> '[3,2,1]';
-- SELECT '1' <-> '[3,2,1]';
-- SELECT '[1' <-> '[3,2,1]';
-- SELECT '1]' <-> '[3,2,1]';
-- SELECT '[1]' <-> '[3,2,1]';
-- SELECT ',' <-> '[3,2,1]';
-- SELECT '[,' <-> '[3,2,1]';
-- SELECT ',]' <-> '[3,2,1]';
-- SELECT '[,]' <-> '[3,2,1]';
-- SELECT '1,' <-> '[3,2,1]';
-- SELECT '[1,' <-> '[3,2,1]';
-- SELECT '1,]' <-> '[3,2,1]';
-- SELECT '[1,]' <-> '[3,2,1]';
-- SELECT '[1,2,3' <-> '[3,2,1]';
-- SELECT '1,2,3]' <-> '[3,2,1]';
-- SELECT '1,2,3' <-> '[3,2,1]';
-- SELECT 'hello world' <-> '[3,2,1]';
-- SELECT '[hello world' <-> '[3,2,1]';
-- SELECT 'hello world]' <-> '[3,2,1]';
-- SELECT '[hello,world]' <-> '[3,2,1]';
-- SELECT '[3,2,1]' <-> '';
-- SELECT '[3,2,1]' <-> '[';
-- SELECT '[3,2,1]' <-> ']';
-- SELECT '[3,2,1]' <-> '[]';
-- SELECT '[3,2,1]' <-> '1';
-- SELECT '[3,2,1]' <-> '[1';
-- SELECT '[3,2,1]' <-> '1]';
-- SELECT '[3,2,1]' <-> '[1]';
-- SELECT '[3,2,1]' <-> ',';
-- SELECT '[3,2,1]' <-> '[,';
-- SELECT '[3,2,1]' <-> ',]';
-- SELECT '[3,2,1]' <-> '[,]';
-- SELECT '[3,2,1]' <-> '1,';
-- SELECT '[3,2,1]' <-> '[1,';
-- SELECT '[3,2,1]' <-> '1,]';
-- SELECT '[3,2,1]' <-> '[1,]';
-- SELECT '[3,2,1]' <-> '[1,2,3';
-- SELECT '[3,2,1]' <-> '1,2,3]';
-- SELECT '[3,2,1]' <-> '1,2,3';
-- SELECT '[3,2,1]' <-> 'hello world';
-- SELECT '[3,2,1]' <-> '[hello world';
-- SELECT '[3,2,1]' <-> 'hello world]';
-- SELECT '[3,2,1]' <-> '[hello,world]';

-- Execution/ Not Equal Dimensions/ Error
-- SELECT '[1,2,3,4]' <-> '[3,2,1]';
-- SELECT '[1,2,3]' <-> '[3,2,1,4]';

