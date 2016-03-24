--Test quarter with a string argument with date in compact form and trailing characters
--+ holdcas on;

SET SYSTEM PARAMETERS 'return_null_on_function_errors=false';

SELECT QUARTER('111111');
SELECT QUARTER('111111a');
SELECT QUARTER('111111Xasdfas');


SET SYSTEM PARAMETERS 'return_null_on_function_errors=true';

SELECT QUARTER('111111');
SELECT QUARTER('111111a');
SELECT QUARTER('111111Xasdfas');
SELECT QUARTER('abc111111Xasdfas');

SET SYSTEM PARAMETERS 'return_null_on_function_errors=false';

commit;

--+ holdcas off;

