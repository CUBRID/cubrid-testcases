--+ holdcas on;

prepare st from 'select repeat (''abc'',floor(?))';
execute st using 3.3;
deallocate prepare st;

prepare st from 'select repeat (''abc'',floor(floor(floor(floor(floor(floor(floor(?))))))))';
execute st using 3.3;
deallocate prepare st;

prepare st from 'select repeat(? + ?, floor(?))';
execute st using '1','6','3.3';
deallocate prepare st;

set system parameters 'plus_as_concat=no';

prepare st from 'select repeat(? + ?, floor(?))';
execute st using '1','6','3.3';
deallocate prepare st;

set system parameters 'plus_as_concat=yes';

prepare st from 'select repeat(? + ?, floor(?))';
execute st using '1',6,'3.3';
deallocate prepare st;

prepare st from 'select repeat(? + ?, floor(?))';
execute st using 1,6,'3.3';
deallocate prepare st;

prepare st from 'select repeat(? + ?, floor(?))';
execute st using 'a','b','3.3';
deallocate prepare st;

prepare st from 'select if(floor(?)=''3'',1,0)';
execute st using '3.3';
deallocate prepare st;

prepare st from 'select if(floor(?)=''3'',1,0)';
execute st using '3';
deallocate prepare st;

prepare st from 'select if(floor(?)=''3'',floor(?),0)';
execute st using '3','-3';
deallocate prepare st;

prepare st from 'select if(floor(?)=''3'',floor(?),0)';
execute st using '3','-3.3';
deallocate prepare st;
commit;
--+ holdcas off;
