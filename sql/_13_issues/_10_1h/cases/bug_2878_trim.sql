--+ holdcas on;
prepare s from 'select trim (?) into :result';
execute s using '  aa  ';
deallocate prepare s;
evaluate trim ('  aa  ') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

prepare s from 'select trim (? from ?) into :result';
execute s using ' ', '  aa  ';
deallocate prepare s;
evaluate trim (' ' from '  aa  ') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

prepare s from 'select trim (? from ?) into :result';
execute s using '0', '00aa00';
deallocate prepare s;
evaluate trim ('0' from '00aa00') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

prepare s from 'select trim (? from ?) into :result';
execute s using 0, '00aa00';
deallocate prepare s;
evaluate trim ('0' from '00aa00') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;

prepare s from 'select trim (? from ?) into :result';
execute s using 9, 99123499;
deallocate prepare s;
evaluate trim ('9' from '99123499') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case5;


--+ holdcas off;
