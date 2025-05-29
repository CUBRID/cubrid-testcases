--+ holdcas on;

prepare st from 'select repeat (''abc'',abs(?))'
execute st using -3.3;

prepare st from 'select repeat (''abc'',abs(abs(abs(abs(abs(abs(abs(?))))))))'
execute st using -3.3;

prepare st from 'select repeat(? + ?, abs(?))'
execute st using '1','6','-3.3';

set system parameters 'plus_as_concat=no';

prepare st from 'select repeat(? + ?, abs(?))'
execute st using '1','6','-3.3';

set system parameters 'plus_as_concat=yes';

prepare st from 'select repeat(? + ?, abs(?))'
execute st using '1',6,'-3.3';

prepare st from 'select repeat(? + ?, abs(?))'
execute st using 1,6,'-3.3';

prepare st from 'select repeat(? + ?, abs(?))'
execute st using 'a','b','-3.3';

prepare st from 'select if(abs(?)=''3'',1,0)'
execute st using '-3.3';

prepare st from 'select if(abs(?)=''3'',1,0)'
execute st using '-3';

prepare st from 'select if(abs(?)=''3'',abs(?),0)'
execute st using '-3','-3';

prepare st from 'select if(abs(?)=''3'',abs(?),0)'
execute st using '-3','-3.3';
commit;
--+ holdcas off;
