-- This test case verifies CBRD-24772 issue.
-- A segfault occurs when using the connect by REGEXP_SUBSTR statement
-- 10.2 does not support dual, REGEXP_SUBSTR function so change it to db_root, ELT function.
-- The result should be same with using dual, REGEXP_SUBSTR on version over 11.0.

select 1
from db_root
connect by ELT (2, 'string1', level, 'string3')=1;

select 1
from db_root
connect by ELT (3, 'string1', 'string2', level)=1;
