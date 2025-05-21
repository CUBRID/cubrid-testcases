-- Verified the CBRD-25279
-- As-is: Casting functions in prepared statements with host variable arguments incorrectly encounter syntax errors
-- To-be: bug fix

PREPARE st from 'SELECT TO_CHAR(?,?,?)';
PREPARE st from 'SELECT TO_DATE(?,?,?)';
PREPARE st from 'SELECT TO_DATETIME(?,?,?)';
PREPARE st from 'SELECT TO_DATETIME_TZ(?,?,?)';
PREPARE st from 'SELECT TO_NUMBER(?,?)';
PREPARE st from 'SELECT TO_TIME(?,?,?)';
PREPARE st from 'SELECT TO_TIMESTAMP(?,?,?)';
PREPARE st from 'SELECT TO_TIMESTAMP_TZ(?,?,?)';
PREPARE st from 'SELECT DATE_FORMAT(?,?)';
PREPARE st from 'SELECT FORMAT(?,?)';
PREPARE st from 'SELECT TIME_FORMAT(?,?)';
PREPARE st from 'SELECT STR_TO_DATE(?,?)';


DROP PREPARE st;
