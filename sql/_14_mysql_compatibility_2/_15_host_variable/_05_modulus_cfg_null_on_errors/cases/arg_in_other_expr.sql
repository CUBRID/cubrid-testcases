--+ holdcas on;

set system parameters 'return_null_on_function_errors=yes';

prepare st from 'select repeat( mod(? , ?), 2)';
execute st using time'10:11:12','6';
deallocate prepare st;

prepare st from 'select repeat( mod (time''10:11:12'', ?), 2)';
execute st using '6';
deallocate prepare st;

prepare st from 'select repeat( mod (?, time''10:11:12''), 2)';
execute st using '6';
deallocate prepare st;


set system parameters 'return_null_on_function_errors=no';commit;
--+ holdcas off;
