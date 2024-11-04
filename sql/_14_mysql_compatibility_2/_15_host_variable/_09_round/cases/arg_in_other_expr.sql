
prepare st from 'select repeat (''abc'',round(?,2))';
execute st using 3.3123;
deallocate prepare st;

prepare st from 'select repeat (''abc'',round(round(round(round(round(round(round(?,2),2),2),2),2),2),2))';
execute st using 3.31231;
deallocate prepare st;

prepare st from 'select repeat(''abc'', round(?,?))';
execute st using '3.3123',1;
deallocate prepare st;

prepare st from 'select repeat(''abc'', round(?,?))';
execute st using 2.123e0,'2';
deallocate prepare st;

prepare st from 'select repeat(round(?,?), 2)';
execute st using 2.12312,0;
deallocate prepare st;

prepare st from 'select if(round(?,?)=''3'',1,0)';
execute st using '3.3',0;
deallocate prepare st;

prepare st from 'select if(round(?,?)=''3'',1,0)';
execute st using '3',1;
deallocate prepare st;

prepare st from 'select if(round(?,?)=''3'',round(?,2.1),0)';
execute st using 3.123,'0',3.123;
deallocate prepare st;

prepare st from 'select if(round(?,?)=''3.000'',round(?,2.1),0)';
execute st using 3.123,'0',3.123;
deallocate prepare st;

prepare st from 'select if(round(?,?)=''3'',round(2.12,?),0)';
execute st using 3,1,1;
deallocate prepare st;
