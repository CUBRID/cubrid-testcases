--normal test

--numeric
prepare st from 'select ?';
execute st using 123.456;
deallocate prepare st;

prepare st from 'select ?';
execute st using -92234293874923.098092384029348023;
deallocate prepare st;

prepare st from 'select ?';
execute st using -1.7976931348623157E+308;
deallocate prepare st;
 
prepare st from 'select ?';
execute st using -1.7976931348623157E+350;
deallocate prepare st;

prepare st from 'select ?';
execute st using 1.7976931348623157E+310;
deallocate prepare st;

--string
prepare st from 'select ?';
execute st using 'abcdwoeijalsdflkjjalsdfojlsdkfi398234234jldfksdalsdjkflskdfjalsdfjalsdkfasdlfkj234jkjlsdfsfla';
deallocate prepare st;

prepare st from 'select ?';
execute st using N'abcdwoeijalsdflkjjalsdfojlsdkfi398234234jldfksdalsdjkflskdfjalsdfjalsdkfasdlfkj234jkjlsdfsfla';
deallocate prepare st;

--bit
--prepare st from 'select ?';
--execute st using B'101010101111111011';

--set
--prepare st from 'select ?';
--execute st using {'abc', 'bcd', 'cde'};

prepare st from 'select ?';
execute st using {'abc', 123456, 'cde'};
deallocate prepare st;

