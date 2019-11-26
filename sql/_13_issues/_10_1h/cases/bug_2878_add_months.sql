--+ holdcas on;
prepare s from 'select add_months (?, ?) into :result'
execute s using '05/17/2010', 1
deallocate prepare s;
evaluate add_months (date'05/17/2010', 1) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case1;

prepare s from 'select add_months (?, ?) into :result'
execute s using '2010-05-17', 1
deallocate prepare s;
evaluate add_months (date'2010-05-17', 1) into :expected;
select case when :expected = :result then 'YES' else 'NO' end as case2;

prepare s from 'select add_months (?, ?) into :result'
execute s using '2010-05-17', '1'
deallocate prepare s;
select case when :expected = :result then 'YES' else 'NO' end as case3;

--+ holdcas off;
