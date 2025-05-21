--+ holdcas on;
set system parameters 'return_null_on_function_errors=yes';

prepare st from 'select repeat (''a'',? * ?)';
execute st using 4.2, 2;
deallocate prepare st;

prepare st from 'select repeat (''a'',? * 2)';
execute st using 4.2;
deallocate prepare st;

prepare st from 'select ? * ? * ? * ? * ?';
execute st using 2 , 2.0 , 2.0e0 , '1', '2.0';
deallocate prepare st;

prepare st from 'select repeat (''a'',? * ? * ? * ? * ?)';
execute st using 2 , 2.0 , 2.0e0 , '1', '2.0';
deallocate prepare st;

prepare st from 'select repeat(? * ?, 2)';
execute st using '4','2';
deallocate prepare st;

prepare st from 'select repeat(? * ''2'', 2)';
execute st using '4';
deallocate prepare st;

prepare st from 'select repeat(? * ?, 2)';
execute st using 4,'2';
deallocate prepare st;

prepare st from 'select repeat(? * ?, 2)';
execute st using time'10:11:12','6';
deallocate prepare st;

prepare st from 'select repeat(time''10:11:12'' * ?, 2)';
execute st using '6';
deallocate prepare st;

prepare st from 'select if(? * ?=''8'',1,0)';
execute st using 4,2;
deallocate prepare st;

prepare st from 'select if(? * 2=''8'',1,0)';
execute st using 4;
deallocate prepare st;

prepare st from 'select if(? * ?=''8'',1,0)';
execute st using '4',2;
deallocate prepare st;

prepare st from 'select if(''4'' * ?=''8'',1,0)';
execute st using '2.0';
deallocate prepare st;

prepare st from 'select if(? * ? = 8,1,0)';
execute st using 4,2;
deallocate prepare st;

prepare st from 'select if(''4'' * ?=8,1,0)';
execute st using 2;
deallocate prepare st;

prepare st from 'select if(? * ?=8,1,0)';
execute st using '4','2.0';
deallocate prepare st;

prepare st from 'select if(''4'' * ?=8,1,0)';
execute st using '2.0';
deallocate prepare st;

prepare st from 'select if(? * ?=n''8'',1,0)';
execute st using 4,2;
deallocate prepare st;

prepare st from 'select if(? * ?=n''8'',1,0)';
execute st using '4','2';
deallocate prepare st;

set system parameters 'return_null_on_function_errors=no';commit;
--+ holdcas off;
