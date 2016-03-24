do 2;
do acos(0.5);

do user();

prepare st from 'do ?'
execute st using '2';

-- should fail
do xyz123456;
