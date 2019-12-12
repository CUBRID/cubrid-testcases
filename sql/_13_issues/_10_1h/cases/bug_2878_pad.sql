--+ holdcas on;
prepare s from 'select lpad (?, ?) into :result'
execute s using 'aa', 10
deallocate prepare s;
evaluate lpad('aa', 10) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

prepare s from 'select lpad (?, ?, ?) into :result'
execute s using 'aa', 10, 'x'
deallocate prepare s;
evaluate lpad('aa', 10, 'x') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

prepare s from 'select lpad (?, ?) into :result'
execute s using 'aa', '10'
deallocate prepare s;
evaluate lpad('aa', 10) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

prepare s from 'select lpad (?, ?, ?) into :result'
execute s using 'aa', '10', 'x'
deallocate prepare s;
evaluate lpad('aa', 10, 'x') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;

prepare s from 'select lpad (?, ?) into :result'
execute s using 0, '10'
deallocate prepare s;
evaluate lpad('0', 10) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case5;

prepare s from 'select lpad (?, ?, ?) into :result'
execute s using 1, '10', 0
deallocate prepare s;
evaluate lpad('1', 10, '0') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case6;

prepare s from 'select rpad (?, ?) into :result'
execute s using 'aa', 10
deallocate prepare s;
evaluate rpad('aa', 10) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case7;

prepare s from 'select rpad (?, ?, ?) into :result'
execute s using 'aa', 10, 'x'
deallocate prepare s;
evaluate rpad('aa', 10, 'x') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case8;

prepare s from 'select rpad (?, ?) into :result'
execute s using 'aa', '10'
deallocate prepare s;
evaluate rpad('aa', 10) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case9;

prepare s from 'select rpad (?, ?, ?) into :result'
execute s using 'aa', '10', 'x'
deallocate prepare s;
evaluate rpad('aa', 10, 'x') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case10;

prepare s from 'select rpad (?, ?) into :result'
execute s using 0, '10'
deallocate prepare s;
evaluate rpad('0', 10) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case11;

prepare s from 'select rpad (?, ?, ?) into :result'
execute s using 1, '10', 0
deallocate prepare s;
evaluate rpad('1', 10, '0') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case12;


--+ holdcas off;
