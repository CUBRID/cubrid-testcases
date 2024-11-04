

prepare st from 'select repeat (''a'',? / ?)';
execute st using 4.2, 2;
deallocate prepare st;

prepare st from 'select repeat (''a'',? / 2)';
execute st using 4.2;
deallocate prepare st;

prepare st from 'select ? / ? / ? / ? / ?';
execute st using 32 , 2.0 , 2.0e0 , '1', '2.0';
deallocate prepare st;

prepare st from 'select repeat (''a'',? / ? / ? / ? / ?)';
execute st using 32 , 2.0 , 2.0e0 , '1', '2.0';
deallocate prepare st;

prepare st from 'select repeat(? / ?, 2)';
execute st using '4','2';
deallocate prepare st;

prepare st from 'select repeat(? / ''2'', 2)';
execute st using '4';
deallocate prepare st;

prepare st from 'select repeat(? / ?, 2)';
execute st using 4,'2';
deallocate prepare st;

prepare st from 'select repeat(? / ?, 2)';
execute st using time'10:11:12','6';
deallocate prepare st;

prepare st from 'select repeat(time''10:11:12''/ ?, 2)';
execute st using '6';
deallocate prepare st;

prepare st from 'select if(? / ?=''2'',1,0)';
execute st using 4,2;
deallocate prepare st;

prepare st from 'select if(? / 2=''2'',1,0)';
execute st using 4;
deallocate prepare st;

prepare st from 'select if(? / ?=''2'',1,0)';
execute st using '4',2;
deallocate prepare st;

prepare st from 'select if(''4'' / ?=''2'',1,0)';
execute st using '2.0';
deallocate prepare st;

prepare st from 'select if(? / ? = 2,1,0)';
execute st using 4,2;
deallocate prepare st;

prepare st from 'select if(''4'' / ?=2,1,0)';
execute st using 2;
deallocate prepare st;

prepare st from 'select if(? / ?=2,1,0)';
execute st using '4','2.0';
deallocate prepare st;

prepare st from 'select if(''4'' / ?=2,1,0)';
execute st using '2.0';
deallocate prepare st;

prepare st from 'select if(? / ?=n''2'',1,0)';
execute st using 4,2;
deallocate prepare st;

prepare st from 'select if(? / ?=n''2'',1,0)';
execute st using '4','2';
deallocate prepare st;
