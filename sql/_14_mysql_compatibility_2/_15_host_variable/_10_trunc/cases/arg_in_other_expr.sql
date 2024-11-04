
prepare st from 'select repeat (''abc'',trunc(?,2))';
execute st using 3.3123;
deallocate prepare st;

prepare st from 'select repeat (''abc'',trunc(trunc(trunc(trunc(trunc(trunc(trunc(?,2),2),2),2),2),2),2))';
execute st using 3.31231;
deallocate prepare st;

prepare st from 'select repeat(''abc'', trunc(?,?))';
execute st using '3.3123',1;
deallocate prepare st;

prepare st from 'select repeat(''abc'', trunc(?,?))';
execute st using 2.123e0,'2';
deallocate prepare st;

prepare st from 'select repeat(trunc(?,?), 2)';
execute st using 2.12312,0;
deallocate prepare st;

prepare st from 'select if(trunc(?,?)=''3'',1,0)';
execute st using '3.3',0;
deallocate prepare st;

prepare st from 'select if(trunc(?,?)=''3'',1,0)';
execute st using '3',1;
deallocate prepare st;

prepare st from 'select if(trunc(?,?)=''3'',trunc(?,2.1),0)';
execute st using 3.123,'0',3.123;
deallocate prepare st;

prepare st from 'select if(trunc(?,?)=''3.000'',trunc(?,2.1),0)';
execute st using 3.123,'0',3.123;
deallocate prepare st;

prepare st from 'select if(trunc(?,?)=''3'',trunc(2.12,?),0)';
execute st using 3,1,1;
deallocate prepare st;
