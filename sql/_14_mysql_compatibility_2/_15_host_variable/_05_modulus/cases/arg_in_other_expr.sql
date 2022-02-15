

prepare st from 'select repeat (''a'', mod (? , ?))';
execute st using 5.2, 3;

prepare st from 'select repeat (''a'',  mod (? , 3))';
execute st using 5.2;

prepare st from 'select mod (? , mod (?, mod ( mod (?, ?), ? )))';
execute st using 32 , 21.0 , 12.0e0 , '10', '2.0';

prepare st from 'select repeat (''a'',mod (? , mod (?, mod ( mod (?, ?), ? ))))';
execute st using 32 , 21.0 , 12.0e0 , '10', '2.0';

prepare st from 'select repeat( mod (? , ?), 2)';
execute st using '4','2';

prepare st from 'select repeat( mod (? , ''2''), 2)';
execute st using '4';

prepare st from 'select repeat( mod (? , ?), 2)';
execute st using 4,'2';

prepare st from 'select repeat( mod(? , ?), 2)';
execute st using time'10:11:12','6';

prepare st from 'select repeat( mod (time''10:11:12'', ?), 2)';
execute st using '6';

prepare st from 'select if( mod (? , ?) =''2'',1,0)';
execute st using 5,3;

prepare st from 'select if( mod (? , 3)=''2'',1,0)';
execute st using 5;

prepare st from 'select if( mod (? , ?)=''2'',1,0)';
execute st using '5',3;

prepare st from 'select if( mod (''5'' , ?)=''2'',1,0)';
execute st using '3.0';

prepare st from 'select if( mod (? , ?) = 2,1,0)';
execute st using 5,3;

prepare st from 'select if( mod (''5'' , ?)=2,1,0)';
execute st using 3;

prepare st from 'select if( mod (? , ?)=2,1,0)';
execute st using '5','3.0';

prepare st from 'select if( mod (''5'' , ?)=2,1,0)';
execute st using '3.0';

prepare st from 'select if( mod (? , ?)=n''2'',1,0)';
execute st using 5,3;

prepare st from 'select if( mod (? , ?)=n''2'',1,0)';
execute st using '5','3';
