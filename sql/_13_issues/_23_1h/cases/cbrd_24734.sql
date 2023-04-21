-- This test case verifies CBRD-24734 issue.
-- If string concatenation and NVL2 function are included in the "SELECT CASE WHEN" statement and SP is included in the "ELSE" clause, -1042 error occurs.

CREATE OR REPLACE FUNCTION SP_FUNC() RETURN STRING
 AS LANGUAGE JAVA
 NAME 'SpTest3.typeteststring3()  RETURN java.lang.String';

PREPARE st FROM '
 SELECT CASE WHEN ? = 1
             THEN ''1234567890'' || NVL2(?, ?, ''A'')
             ELSE ( SELECT sp_func() FROM dual )
        END AS p
 FROM dual
 ';

EXECUTE st USING 1, null, null;
DROP PREPARE st;

SELECT CASE WHEN 1 = 1
             THEN '1234567890' || NVL2(null, null, 'A')
             ELSE ( SELECT sp_func() FROM dual )
        END AS p
 FROM dual;

DROP FUNCTION SP_FUNC;
