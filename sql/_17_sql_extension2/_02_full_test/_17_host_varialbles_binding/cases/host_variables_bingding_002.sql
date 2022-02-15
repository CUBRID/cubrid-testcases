--test with operators

--numeric, string
prepare st from 'select ? + ?';
execute st using 123.456, '7987293849238423842934.2374234809384';

prepare st from 'select ? * ?';
execute st using -92234293874923.098092384029348023, '987654321';

prepare st from 'select -1 + ?';
execute st using -1.7976931348623157E+308;
 
prepare st from 'select -100 + ?';
execute st using -1.7976931348623157E+308;

prepare st from 'select 2783462893789 + ?';
execute st using 1.7976931348623157E+308;

prepare st from 'select ? / ?';
execute st using -1.7976931348623157E+350, 100;

prepare st from 'select ? + ?';
execute st using 1.7976931348623157E+31, 'abcd';

--string
prepare st from 'select ? + ?';
execute st using 'abc', 'abcdwoeijalsdflkjjalsdfojlsdkfi398234234jldfksdalsdjkflskdfjalsdfjalsdkfasdlfkj234jkjlsdfsfla';

prepare st from 'select ? - 123';
execute st using N'abcdwoeijalsdflkjjalsdfojlsdkfi398234234jldfksdalsdjkflskdfjalsdfjalsdkfasdlfkj234jkjlsdfsfla';

--bit
prepare st from 'select ? + 1011';
execute st using B'101010101111111011';

--set
prepare st from 'select ? + ?';
execute st using {'abc', 'bcd', 'cde'}, 'def';

prepare st from 'select ? + ?';
execute st using {'abc', 123456, 'cde'}, 123;

prepare st from 'select {123, 345, 456} + ?';
execute st using '567';

deallocate prepare st;
