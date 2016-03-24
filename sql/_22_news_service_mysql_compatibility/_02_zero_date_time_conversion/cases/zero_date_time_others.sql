--+ holdcas on;
--TEST: pass zero values to other function


--TEST: other functions
SELECT MAKEDATE(0,0);
SELECT FROM_DAYS(365);
SELECT FROM_DAYS(0);
SELECT STR_TO_DATE('0,0,0000','%d,%m,%Y');
SELECT FROM_UNIXTIME(0);


--TEST: set return_null_on_function_errors=yes
set system parameters 'return_null_on_function_errors=yes';

SELECT MAKEDATE(0,0);
SELECT FROM_DAYS(365);
SELECT FROM_DAYS(0);
SELECT STR_TO_DATE('0,0,0000','%d,%m,%Y');
SELECT FROM_UNIXTIME(0);



set system parameters 'return_null_on_function_errors=no';


commit;
--+ holdcas off;
