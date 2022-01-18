--+ holdcas on;
prepare s from 'select replace (?, ?) into :result';
execute s using 'abc', 'b';
deallocate prepare s;
evaluate replace ('abc', 'b') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

prepare s from 'select replace (?, ?, ?) into :result';
execute s using 'abc', 'b', ' ';
deallocate prepare s;
evaluate replace ('abc', 'b', ' ') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

prepare s from 'select replace (?, ?) into :result';
execute s using 123, 2;
deallocate prepare s;
evaluate replace ('123', '2') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case3;

prepare s from 'select replace (?, ?, ?) into :result';
execute s using 123, 2, 0;
deallocate prepare s;
evaluate replace ('123', '2', '0') into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case4;

prepare s from 'select replace (?, ?, ?) into :result';
execute s using 'abc', 'b', NULL;
deallocate prepare s;
evaluate replace ('abc', 'b', NULL) into :expected;
select case when :expected <=> :result then 'YES' else 'NO' end as case5;


--+ holdcas off;
