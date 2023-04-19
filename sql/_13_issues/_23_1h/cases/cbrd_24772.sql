-- This test case verifies CBRD-24705 issue.
-- A segfault occurs when using the connect by REGEXP_SUBSTR statement

select 1
from dual
connect by REGEXP_SUBSTR(1,'1', 1,level)=1;

select 1
from dual
connect by REGEXP_SUBSTR(level,'1', 1,1)=1;
