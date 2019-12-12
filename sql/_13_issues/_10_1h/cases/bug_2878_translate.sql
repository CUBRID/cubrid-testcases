--+ holdcas on;
prepare s from 'select translate (?, ?, ?) into :result'
execute s using 'abcde', 'abc', '123'
deallocate prepare s;
evaluate translate ('abcde', 'abc', '123') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

prepare s from 'select translate (?, ?, ?) into :result'
execute s using '12345', '12345', 'abcde'
deallocate prepare s;
evaluate translate ('12345', '12345', 'abcde') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

prepare s from 'select translate (?, ?, ?) into :result'
execute s using 12345, 12345, 'abcde'
deallocate prepare s;
evaluate translate ('12345', '12345', 'abcde') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

prepare s from 'select translate (?, ?, ?) into :result'
execute s using 12345, 12345, 67890
deallocate prepare s;
evaluate translate ('12345', '12345', '67890') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;


--+ holdcas off;
