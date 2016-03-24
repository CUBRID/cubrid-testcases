-- 1
prepare s from 'select UCASE (?) into :result'
execute s using 'aaa'
deallocate prepare s;

evaluate 'AAA' into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case1;

-- 2
prepare s from 'select UCASE (?) into :result'
execute s using 'AAA'
deallocate prepare s;

evaluate 'AAA' into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case2;

-- 3
prepare s from 'select UCASE (?) into :result'
execute s using 123
deallocate prepare s;

evaluate '123' into :expected;
select case when (:expected = :result) then 'YES' else 'NO' end as case3;

-- 4
prepare s from 'select UCASE (?) into :result'
execute s using null
deallocate prepare s;

evaluate null into :expected;
select case when (:expected <=> :result) then 'YES' else 'NO' end as case4;
