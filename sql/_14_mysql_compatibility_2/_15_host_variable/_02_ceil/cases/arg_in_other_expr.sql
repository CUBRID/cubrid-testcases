--+ holdcas on;

prepare st from 'select repeat (''abc'',ceil(?))';
execute st using 3.3;
deallocate prepare st;

prepare st from 'select repeat (''abc'',ceil(ceil(ceil(ceil(ceil(ceil(ceil(?))))))))';
execute st using 3.3;
deallocate prepare st;

prepare st from 'select repeat(? + ?, ceil(?))';
execute st using '1','6','3.3';
deallocate prepare st;

set system parameters 'plus_as_concat=no';

prepare st from 'select repeat(? + ?, ceil(?))';
execute st using '1','6','3.3';
deallocate prepare st;

set system parameters 'plus_as_concat=yes';

prepare st from 'select repeat(? + ?, ceil(?))';
execute st using '1',6,'3.3';
deallocate prepare st;

prepare st from 'select repeat(? + ?, ceil(?))';
execute st using 1,6,'3.3';
deallocate prepare st;

prepare st from 'select repeat(? + ?, ceil(?))';
execute st using 'a','b','3.3';
deallocate prepare st;

prepare st from 'select if(ceil(?)=''4'',1,0)';
execute st using '3.3';
deallocate prepare st;

prepare st from 'select if(ceil(?)=''3'',1,0)';
execute st using '3';
deallocate prepare st;

prepare st from 'select if(ceil(?)=''3'',ceil(?),0)';
execute st using '3','3';
deallocate prepare st;

prepare st from 'select if(ceil(?)=''3'',ceil(?),0)';
execute st using '3','3.3';
deallocate prepare st;
commit;
--+ holdcas off;
