

prepare st from 'select repeat (''a'',? - ?)'
execute st using 3.3, 1;

prepare st from 'select repeat (''a'',? - 1)'
execute st using 3.3;

prepare st from 'select ? - ? - ? - ? - ?'
execute st using 32 , 1.1 , 1.12e0 , '1', '-2.3';

prepare st from 'select repeat (''a'',? - ? - ? - ? - ?)'
execute st using 32 , 1.1 , 1.12e0 , '1', '-2.3';

prepare st from 'select repeat(? - ?, 2)'
execute st using '1','6';

prepare st from 'select repeat(? - ''6'', 2)'
execute st using '1';

prepare st from 'select repeat(? - ?, 2)'
execute st using 1,'6';

prepare st from 'select repeat(? - ?, 2)'
execute st using time'10:00:01','10';

prepare st from 'select repeat(time''10:00:01'' - ?, 2)'
execute st using '10';

prepare st from 'select if(? - ?=''3'',1,0)'
execute st using 5,2;

prepare st from 'select if(? - 2=''3'',1,0)'
execute st using 5;

prepare st from 'select if(? - ?=''3'',1,0)'
execute st using '5',2;

prepare st from 'select if(''5'' - ?=''3'',1,0)'
execute st using '2.0';


prepare st from 'select if(? - ?=3,1,0)'
execute st using 5,2;

prepare st from 'select if(''5'' - ?=3,1,0)'
execute st using 2;

prepare st from 'select if(? - ?=3,1,0)'
execute st using '5','2.0';

prepare st from 'select if(''5'' - ?=3,1,0)'
execute st using '2.0';

prepare st from 'select if(? - ?=n''3'',1,0)'
execute st using 5,2;

prepare st from 'select if(? - ?=n''3'',1,0)'
execute st using '5','2';
