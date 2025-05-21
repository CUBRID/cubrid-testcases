--+ holdcas on;

prepare st from 'select repeat (''abc'',-(?))';
execute st using -3.3;
deallocate prepare st;

prepare st from 'select repeat (''abc'',-(-(-(-(-(-(-(?))))))))';
execute st using -3.3;
deallocate prepare st;

prepare st from 'select repeat(? + ?, -(?))';
execute st using '1','6','-3.3';
deallocate prepare st;

set system parameters 'plus_as_concat=no';

prepare st from 'select repeat(? + ?, -(?))';
execute st using '1','6','-3.3';
deallocate prepare st;

set system parameters 'plus_as_concat=yes';

prepare st from 'select repeat(? + ?, -(?))';
execute st using '1',6,'-3.3';
deallocate prepare st;

prepare st from 'select repeat(? + ?, -(?))';
execute st using 1,6,'-3.3';
deallocate prepare st;

prepare st from 'select repeat(? + ?, -(?))';
execute st using 'a','b','-3.3';
deallocate prepare st;

prepare st from 'select if(-(?)=''3'',1,0)';
execute st using '-3.3';
deallocate prepare st;

prepare st from 'select if(-(?)=''3'',1,0)';
execute st using '-3';
deallocate prepare st;

prepare st from 'select if(-(?)=''3'',-(?),0)';
execute st using '-3','-3';
deallocate prepare st;

prepare st from 'select if(-(?)=''3'',-(?),0)';
execute st using '-3','-3.3';
deallocate prepare st;
commit;
--+ holdcas off;
