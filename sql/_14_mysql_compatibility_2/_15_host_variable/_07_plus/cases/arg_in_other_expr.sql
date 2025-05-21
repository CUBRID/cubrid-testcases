

prepare st from 'select repeat (''a'',? + ?)';
execute st using 3.3, 1;
deallocate prepare st;

prepare st from 'select repeat (''a'',? + 1)';
execute st using 3.3;
deallocate prepare st;

prepare st from 'select repeat (''a'',? + ? + ? + ? + ?)';
execute st using 1 , 1.1 , 1.12e0 , '1', '-2.3';
deallocate prepare st;

prepare st from 'select repeat(? + ?, 2)';
execute st using '1','6';
deallocate prepare st;

prepare st from 'select repeat(? + ''6'', 2)';
execute st using '1';
deallocate prepare st;

prepare st from 'select repeat(? + ?, 2)';
execute st using 1,'6';
deallocate prepare st;

prepare st from 'select repeat(? + ?, 2)';
execute st using time'10:11:12','6';
deallocate prepare st;

prepare st from 'select repeat(time''10:11:12''+ ?, 2)';
execute st using '6';
deallocate prepare st;

prepare st from 'select if(? + ?=''3'',1,0)';
execute st using 1,2;
deallocate prepare st;

prepare st from 'select if(? + 2=''3'',1,0)';
execute st using 1;
deallocate prepare st;

prepare st from 'select if(? + ?=''3'',1,0)';
execute st using '1',2;
deallocate prepare st;

prepare st from 'select if(''1'' + ?=''3'',1,0)';
execute st using '2.0';
deallocate prepare st;

prepare st from 'select if(? + ?=''12'',1,0)';
execute st using 1,2;
deallocate prepare st;

prepare st from 'select if(? + ?=''12'',1,0)';
execute st using '1',2;
deallocate prepare st;

prepare st from 'select if(? + ?=''12'',1,0)';
execute st using '1','2';
deallocate prepare st;

prepare st from 'select if(? + ?=3,1,0)';
execute st using 1,2;
deallocate prepare st;

prepare st from 'select if(''1'' + ?=3,1,0)';
execute st using 2;
deallocate prepare st;

prepare st from 'select if(? + ?=3,1,0)';
execute st using '1','2.0';
deallocate prepare st;

prepare st from 'select if(''1'' + ?=3,1,0)';
execute st using '2.0';
deallocate prepare st;

prepare st from 'select if(? + ?=n''3'',1,0)';
execute st using 1,2;
deallocate prepare st;

prepare st from 'select if(? + ?=n''3'',1,0)';
execute st using '1','2';
deallocate prepare st;
