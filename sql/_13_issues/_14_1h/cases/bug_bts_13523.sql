prepare st from 'select ''1'' + ?';
execute st using n'2';
prepare st from 'select ? + ?';
execute st USING '1',n'2';

prepare st from 'select ''1'' + ?';
execute st using '2';
prepare st from 'select ? + ?';
execute st USING '1','2';


prepare st from 'select 1 + ?';
execute st using 2;
prepare st from 'select ? + ?';
execute st USING 1,2;



prepare st from 'select ''abc'' + ?';
execute st using 2;
prepare st from 'select ? + ?';
execute st USING 'abc',2;

prepare st from 'select ''1'' + ?';
execute st using B'10001001';
prepare st from 'select ? + ?';
execute st USING '1',B'10001001';
select '1'+B'10001001';


prepare st from 'select ''1'' + ?';
execute st using x'31';
prepare st from 'select ? + ?';
execute st USING '1',x'31';
select '1'+x'31';

prepare st from 'select 1 + ?';
execute st using x'31';
prepare st from 'select ? + ?';
execute st USING 1,x'31';
select 1+x'31';
